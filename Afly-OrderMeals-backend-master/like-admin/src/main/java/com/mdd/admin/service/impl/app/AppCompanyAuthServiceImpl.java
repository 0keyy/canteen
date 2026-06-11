package com.mdd.admin.service.impl.app;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.common.entity.ruoyi.RuoyiSysDept;
import com.mdd.common.entity.ruoyi.RuoyiSysUser;
import com.mdd.common.entity.user.UserCompany;
import com.mdd.common.exception.OperateException;
import com.mdd.common.mapper.user.UserCompanyMapper;
import com.mdd.common.util.RuoyiPasswordUtils;
import com.mdd.common.util.TimeUtils;
import com.mdd.common.entity.user.UserPointsLog;
import com.mdd.admin.service.app.IAppCompanyAuthService;
import com.mdd.admin.service.app.IUserPointsService;
import com.mdd.admin.service.ruoyi.RuoyiSysService;
import com.mdd.admin.validate.app.company.CompanyAuthValidate;
import com.mdd.admin.vo.app.company.CompanyAuthVo;
import com.mdd.admin.vo.app.company.CompanyDeptVo;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class AppCompanyAuthServiceImpl implements IAppCompanyAuthService {

    @Resource
    private RuoyiSysService ruoyiSysService;
    @Resource
    private UserCompanyMapper userCompanyMapper;
    @Resource
    private IUserPointsService userPointsService;

    @Override
    public List<CompanyDeptVo> deptList() {
        return ruoyiSysService.selectDeptList();
    }

    @Override
    public CompanyAuthVo status(Integer userId) {
        UserCompany record = userCompanyMapper.selectOne(new QueryWrapper<UserCompany>()
                .eq("user_id", userId)
                .last("limit 1"));
        return toAuthVo(record);
    }

    @Override
    public CompanyAuthVo authenticate(Integer userId, CompanyAuthValidate validate) {
        // 注意：不可在此方法加 @Transactional。
        // 事务会绑定 master 连接，导致 RuoyiSysService 的 @DS(ruoyi) 失效，去 like_admin 查 sys_dept。
        if (validate.getDeptId() == null) {
            throw new OperateException("用户不存在");
        }

        RuoyiSysDept dept = ruoyiSysService.selectDeptById(validate.getDeptId());
        if (dept == null) {
            throw new OperateException("部门不存在");
        }

        RuoyiSysUser sysUser = ruoyiSysService.selectUserByUserNameAndDeptId(
                validate.getUsername(), dept.getDeptId());
        if (sysUser == null) {
            throw new OperateException("用户不存在");
        }

        if (!"0".equals(sysUser.getStatus())) {
            throw new OperateException("用户已停用");
        }

        if (!RuoyiPasswordUtils.matches(validate.getPassword(), sysUser.getPassword())) {
            throw new OperateException("密码错误");
        }

        UserCompany ruoyiBound = userCompanyMapper.selectOne(new QueryWrapper<UserCompany>()
                .eq("ruoyi_user_id", sysUser.getUserId())
                .last("limit 1"));
        if (ruoyiBound != null && !ruoyiBound.getUserId().equals(userId)) {
            throw new OperateException("该若依账号已被其他用户认证，请更换账号");
        }

        long now = TimeUtils.timestamp();
        UserCompany existing = userCompanyMapper.selectOne(new QueryWrapper<UserCompany>()
                .eq("user_id", userId)
                .last("limit 1"));

        if (existing != null) {
            throw new OperateException("您已完成公司认证，无法重新认证");
        }

        try {
            UserCompany record = new UserCompany();
            record.setUserId(userId);
            record.setRuoyiUserId(sysUser.getUserId());
            record.setDeptId(dept.getDeptId());
            record.setDeptName(dept.getDeptName());
            record.setUserName(sysUser.getUserName());
            record.setNickName(sysUser.getNickName());
            record.setAuthTime(now);
            record.setCreateTime(now);
            record.setUpdateTime(now);
            userCompanyMapper.insert(record);
            CompanyAuthVo vo = toAuthVo(record);
            int granted = userPointsService.grantMonthlyPoints(
                    userId, sysUser.getUserId(), UserPointsLog.SOURCE_FIRST_AUTH);
            vo.setBalanceGranted(granted);
            vo.setMonthlyBalance(granted > 0 ? granted : null);
            return vo;
        } catch (DuplicateKeyException e) {
            throw new OperateException(resolveDuplicateMessage(e));
        }
    }

    private String resolveDuplicateMessage(DuplicateKeyException e) {
        String message = e.getMessage();
        if (message != null && message.contains("uk_ruoyi_user_id")) {
            return "该若依账号已被其他用户认证，请更换账号";
        }
        if (message != null && message.contains("uk_user_id")) {
            return "您已完成公司认证，无需重复认证";
        }
        return "认证信息已被占用，请更换账号后重试";
    }

    private CompanyAuthVo toAuthVo(UserCompany record) {
        CompanyAuthVo vo = new CompanyAuthVo();
        if (record == null) {
            vo.setVerified(false);
            return vo;
        }
        BeanUtils.copyProperties(record, vo);
        vo.setVerified(true);
        return vo;
    }
}
