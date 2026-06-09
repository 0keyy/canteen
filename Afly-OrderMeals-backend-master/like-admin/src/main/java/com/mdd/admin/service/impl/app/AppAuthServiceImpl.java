package com.mdd.admin.service.impl.app;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.bean.WxMaJscode2SessionResult;
import cn.binarywang.wx.miniapp.bean.WxMaPhoneNumberInfo;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.entity.user.User;
import com.mdd.common.entity.user.UserAuth;
import com.mdd.common.entity.user.UserSession;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.user.UserAuthMapper;
import com.mdd.common.mapper.user.UserMapper;
import com.mdd.common.mapper.user.UserSessionMapper;
import com.mdd.common.util.RedisUtils;
import com.mdd.common.util.TimeUtils;
import com.mdd.common.util.WeChatUtils;
import com.mdd.common.util.YmlUtils;
import com.mdd.admin.config.StpUserUtil;
import com.mdd.admin.enums.app.ClientEnum;
import com.mdd.admin.service.app.IAppAuthService;
import com.mdd.admin.validate.app.auth.*;
import com.mdd.admin.vo.app.auth.LoginVo;
import com.mdd.admin.vo.app.auth.UserProfileVo;
import me.chanjar.weixin.common.error.WxErrorException;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Random;

@Service
public class AppAuthServiceImpl implements IAppAuthService {

    private static final String SMS_KEY_PREFIX = "uniapp:sms:";

    @Resource
    private UserMapper userMapper;
    @Resource
    private UserAuthMapper userAuthMapper;
    @Resource
    private UserSessionMapper userSessionMapper;

    @Override
    @Transactional
    public LoginVo wxLogin(WxLoginValidate validate) {
        try {
            WxMaService wxMaService = WeChatUtils.mnp();
            WxMaJscode2SessionResult session = wxMaService.getUserService().getSessionInfo(validate.getCode());
            String openid = session.getOpenid();
            String sessionKey = session.getSessionKey();

            UserAuth userAuth = userAuthMapper.selectOne(new QueryWrapper<UserAuth>()
                    .eq("openid", openid)
                    .eq("client", ClientEnum.MP_WEIXIN)
                    .last("limit 1"));

            Integer userId = 0;
            if (userAuth != null) {
                userId = userAuth.getUserId();
            }

            saveSession(userId, openid, sessionKey, ClientEnum.MP_WEIXIN);

            LoginVo vo = new LoginVo();
            vo.setOpenid(openid);
            vo.setUserId(userId);
            boolean needBindPhone = userId == 0 || getUserMobile(userId).isEmpty();
            vo.setNeedBindPhone(needBindPhone);
            if (userId > 0 && !needBindPhone) {
                fillUserInfo(vo, userId);
                StpUserUtil.login(userId);
                vo.setToken(StpUserUtil.getTokenValue());
            }
            return vo;
        } catch (WxErrorException e) {
            throw new BaseException(500, "微信登录失败: " + e.getError().getErrorMsg());
        }
    }

    @Override
    @Transactional
    public LoginVo wxPhone(WxPhoneValidate validate) {
        try {
            WxMaService wxMaService = WeChatUtils.mnp();
            WxMaPhoneNumberInfo phoneInfo = wxMaService.getUserService().getNewPhoneNoInfo(validate.getPhoneCode());
            String mobile = phoneInfo.getPurePhoneNumber();
            if (mobile == null || mobile.isEmpty()) {
                mobile = phoneInfo.getPhoneNumber();
            }
            if (mobile == null || mobile.trim().isEmpty()) {
                throw new BaseException(500, "获取手机号失败，请重试");
            }
            mobile = mobile.trim();

            UserAuth userAuth = userAuthMapper.selectOne(new QueryWrapper<UserAuth>()
                    .eq("openid", validate.getOpenid())
                    .eq("client", ClientEnum.MP_WEIXIN)
                    .last("limit 1"));

            Integer userId = bindOrCreateUser(mobile, validate.getOpenid(), ClientEnum.MP_WEIXIN, userAuth);
            StpUserUtil.login(userId);

            LoginVo vo = new LoginVo();
            vo.setOpenid(validate.getOpenid());
            vo.setUserId(userId);
            vo.setMobile(mobile);
            vo.setNeedBindPhone(false);
            vo.setToken(StpUserUtil.getTokenValue());
            fillUserInfo(vo, userId);
            return vo;
        } catch (WxErrorException e) {
            throw new BaseException(500, "获取手机号失败: " + e.getError().getErrorMsg());
        }
    }

    @Override
    public LoginVo aliLogin(AliLoginValidate validate) {
        String openid = "ali_" + validate.getAuthCode().hashCode();
        UserAuth userAuth = userAuthMapper.selectOne(new QueryWrapper<UserAuth>()
                .eq("openid", openid)
                .eq("client", ClientEnum.MP_ALIPAY)
                .last("limit 1"));

        LoginVo vo = new LoginVo();
        vo.setOpenid(openid);
        if (userAuth != null) {
            vo.setUserId(userAuth.getUserId());
            vo.setNeedBindPhone(getUserMobile(userAuth.getUserId()).isEmpty());
            if (!vo.getNeedBindPhone()) {
                StpUserUtil.login(userAuth.getUserId());
                vo.setToken(StpUserUtil.getTokenValue());
                fillUserInfo(vo, userAuth.getUserId());
            }
        } else {
            vo.setUserId(0);
            vo.setNeedBindPhone(true);
        }
        return vo;
    }

    @Override
    @Transactional
    public LoginVo aliPhone(AliLoginValidate validate) {
        String openid = "ali_" + validate.getAuthCode().hashCode();
        String mobile = "138" + String.format("%08d", Math.abs(validate.getAuthCode().hashCode()) % 100000000);

        UserAuth userAuth = userAuthMapper.selectOne(new QueryWrapper<UserAuth>()
                .eq("openid", openid)
                .eq("client", ClientEnum.MP_ALIPAY)
                .last("limit 1"));

        Integer userId = bindOrCreateUser(mobile, openid, ClientEnum.MP_ALIPAY, userAuth);
        StpUserUtil.login(userId);

        LoginVo vo = new LoginVo();
        vo.setOpenid(openid);
        vo.setUserId(userId);
        vo.setMobile(mobile);
        vo.setNeedBindPhone(false);
        vo.setToken(StpUserUtil.getTokenValue());
        fillUserInfo(vo, userId);
        return vo;
    }

    @Override
    public void smsSend(SmsSendValidate validate) {
        String code = String.format("%06d", new Random().nextInt(1000000));
        RedisUtils.set(SMS_KEY_PREFIX + validate.getMobile(), code, 300);
    }

    @Override
    @Transactional
    public LoginVo smsLogin(SmsLoginValidate validate) {
        String cacheKey = SMS_KEY_PREFIX + validate.getMobile();
        Object cacheCode = RedisUtils.get(cacheKey);
        if (cacheCode == null || !cacheCode.toString().equals(validate.getCode())) {
            throw new BaseException(500, "验证码错误或已过期");
        }
        RedisUtils.del(cacheKey);

        User user = userMapper.selectOne(new QueryWrapper<User>()
                .eq("mobile", validate.getMobile())
                .eq("is_delete", 0)
                .last("limit 1"));

        Integer userId;
        if (user == null) {
            userId = createUser(validate.getMobile(), ClientEnum.APP);
        } else {
            userId = user.getId();
            updateLoginTime(userId);
        }

        StpUserUtil.login(userId);
        LoginVo vo = new LoginVo();
        vo.setUserId(userId);
        vo.setMobile(validate.getMobile());
        vo.setNeedBindPhone(false);
        vo.setToken(StpUserUtil.getTokenValue());
        fillUserInfo(vo, userId);
        return vo;
    }

    @Override
    @Transactional
    public LoginVo mockPhoneLogin(MockPhoneLoginValidate validate) {
        if (!isMockLoginEnabled()) {
            throw new BaseException(403, "模拟登录未开启");
        }

        String mobile = validate.getMobile();
        if (mobile == null || mobile.trim().isEmpty()) {
            mobile = YmlUtils.get("like.app-mock-login-mobile");
            if (mobile == null || mobile.trim().isEmpty()) {
                mobile = "13800138000";
            }
        }
        mobile = mobile.trim();
        if (!mobile.matches("^1\\d{10}$")) {
            throw new BaseException(500, "请输入正确手机号");
        }

        String openid = "mock_wx_" + mobile;
        UserAuth userAuth = userAuthMapper.selectOne(new QueryWrapper<UserAuth>()
                .eq("openid", openid)
                .eq("client", ClientEnum.MP_WEIXIN)
                .last("limit 1"));

        Integer userId = bindOrCreateUser(mobile, openid, ClientEnum.MP_WEIXIN, userAuth);
        saveSession(userId, openid, "mock_session_key", ClientEnum.MP_WEIXIN);
        StpUserUtil.login(userId);

        LoginVo vo = new LoginVo();
        vo.setOpenid(openid);
        vo.setUserId(userId);
        vo.setMobile(mobile);
        vo.setNeedBindPhone(false);
        vo.setToken(StpUserUtil.getTokenValue());
        fillUserInfo(vo, userId);
        return vo;
    }

    @Override
    public UserProfileVo profile(Integer userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BaseException(500, "用户不存在");
        }
        UserProfileVo vo = new UserProfileVo();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }

    @Override
    public void logout(Integer userId) {
        StpUserUtil.logout(userId);
    }

    private void saveSession(Integer userId, String openid, String sessionKey, int client) {
        UserSession session = userSessionMapper.selectOne(new QueryWrapper<UserSession>()
                .eq("openid", openid)
                .eq("client", client)
                .last("limit 1"));
        long now = TimeUtils.timestamp();
        if (session == null) {
            session = new UserSession();
            session.setUserId(userId);
            session.setOpenid(openid);
            session.setSessionKey(sessionKey);
            session.setClient(client);
            session.setExpireTime(now + 7200);
            session.setCreateTime(now);
            session.setUpdateTime(now);
            userSessionMapper.insert(session);
        } else {
            session.setUserId(userId);
            session.setSessionKey(sessionKey);
            session.setExpireTime(now + 7200);
            session.setUpdateTime(now);
            userSessionMapper.updateById(session);
        }
    }

    private Integer bindOrCreateUser(String mobile, String openid, int client, UserAuth existingAuth) {
        User user = userMapper.selectOne(new QueryWrapper<User>()
                .eq("mobile", mobile)
                .eq("is_delete", 0)
                .last("limit 1"));

        Integer userId;
        if (user == null) {
            userId = resolveUserIdForNewMobile(mobile, client, existingAuth);
        } else {
            userId = user.getId();
            updateLoginTime(userId);
        }

        if (existingAuth == null) {
            UserAuth auth = new UserAuth();
            auth.setUserId(userId);
            auth.setOpenid(openid);
            auth.setClient(client);
            auth.setCreateTime(TimeUtils.timestamp());
            auth.setUpdateTime(TimeUtils.timestamp());
            userAuthMapper.insert(auth);
        } else if (!existingAuth.getUserId().equals(userId)) {
            existingAuth.setUserId(userId);
            existingAuth.setUpdateTime(TimeUtils.timestamp());
            userAuthMapper.updateById(existingAuth);
        }

        UserSession session = userSessionMapper.selectOne(new QueryWrapper<UserSession>()
                .eq("openid", openid)
                .last("limit 1"));
        if (session != null) {
            session.setUserId(userId);
            session.setUpdateTime(TimeUtils.timestamp());
            userSessionMapper.updateById(session);
        }
        return userId;
    }

    private Integer resolveUserIdForNewMobile(String mobile, int client, UserAuth existingAuth) {
        if (existingAuth != null && existingAuth.getUserId() != null && existingAuth.getUserId() > 0) {
            User linkedUser = userMapper.selectById(existingAuth.getUserId());
            if (linkedUser != null && linkedUser.getIsDelete() == 0) {
                linkedUser.setMobile(mobile);
                if (linkedUser.getNickname() == null || linkedUser.getNickname().isEmpty()) {
                    linkedUser.setNickname("用户" + mobile.substring(mobile.length() - 4));
                }
                linkedUser.setUpdateTime(TimeUtils.timestamp());
                userMapper.updateById(linkedUser);
                return linkedUser.getId();
            }
        }
        return createUser(mobile, client);
    }

    private Integer createUser(String mobile, int channel) {
        User user = new User();
        user.setSn(generateSn());
        user.setMobile(mobile);
        user.setNickname("用户" + mobile.substring(mobile.length() - 4));
        user.setChannel(channel);
        user.setIsDisable(0);
        user.setIsDelete(0);
        long now = TimeUtils.timestamp();
        user.setCreateTime(now);
        user.setUpdateTime(now);
        user.setLastLoginTime(now);
        userMapper.insert(user);
        return user.getId();
    }

    private void updateLoginTime(Integer userId) {
        User user = new User();
        user.setId(userId);
        user.setLastLoginTime(TimeUtils.timestamp());
        user.setUpdateTime(TimeUtils.timestamp());
        userMapper.updateById(user);
    }

    private Integer generateSn() {
        return (int) (System.currentTimeMillis() % 1000000000);
    }

    private String getUserMobile(Integer userId) {
        if (userId == null || userId == 0) {
            return "";
        }
        User user = userMapper.selectById(userId);
        return user == null || user.getMobile() == null ? "" : user.getMobile();
    }

    private boolean isMockLoginEnabled() {
        return "true".equals(YmlUtils.get("like.app-mock-login"));
    }

    private void fillUserInfo(LoginVo vo, Integer userId) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            vo.setNickname(user.getNickname());
            vo.setAvatar(user.getAvatar());
            if (user.getMobile() != null) {
                vo.setMobile(user.getMobile());
            }
        }
    }
}
