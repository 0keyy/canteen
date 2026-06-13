package com.mdd.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mdd.admin.LikeAdminThreadLocal;
import com.mdd.admin.service.ICouponVerifyService;
import com.mdd.common.entity.coupon.CouponTemplate;
import com.mdd.common.entity.coupon.CouponVerifyLog;
import com.mdd.common.entity.coupon.UserCoupon;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.coupon.CouponTemplateMapper;
import com.mdd.common.mapper.coupon.CouponVerifyLogMapper;
import com.mdd.common.mapper.coupon.UserCouponMapper;
import com.mdd.common.util.TimeUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service
public class CouponVerifyServiceImpl implements ICouponVerifyService {

    @Resource
    UserCouponMapper userCouponMapper;

    @Resource
    CouponTemplateMapper couponTemplateMapper;

    @Resource
    CouponVerifyLogMapper couponVerifyLogMapper;

    @Override
    @Transactional
    public Map<String, Object> verify(String verifyCode) {
        // 查找用户券
        UserCoupon userCoupon = userCouponMapper.selectOne(
                new QueryWrapper<UserCoupon>()
                        .eq("verify_code", verifyCode));

        if (userCoupon == null) {
            throw new BaseException(500, "核销码不存在");
        }

        // 查找券模板
        CouponTemplate template = couponTemplateMapper.selectById(userCoupon.getTemplateId());
        if (template == null) {
            throw new BaseException(500, "券模板不存在");
        }

        // 验证券类型（仅兑换券和套餐券可通过扫码核销）
        if (template.getType() != 3 && template.getType() != 4) {
            throw new BaseException(500, "该券类型不支持扫码核销，仅兑换券和套餐券支持");
        }

        // 验证券状态
        if (userCoupon.getStatus() != 1) {
            if (userCoupon.getStatus() == 2) {
                throw new BaseException(500, "该券已被核销使用");
            } else if (userCoupon.getStatus() == 3) {
                throw new BaseException(500, "该券已过期");
            }
            throw new BaseException(500, "该券状态异常");
        }

        // 验证有效期
        long now = TimeUtils.timestamp();
        if (userCoupon.getUseStartTime() > 0 && now < userCoupon.getUseStartTime()) {
            throw new BaseException(500, "该券尚未生效");
        }
        if (userCoupon.getUseEndTime() > 0 && now > userCoupon.getUseEndTime()) {
            throw new BaseException(500, "该券已过期");
        }

        Integer adminId = LikeAdminThreadLocal.getAdminId();

        // 标记已使用
        userCoupon.setStatus(2);
        userCoupon.setUseTime(now);
        userCoupon.setVerifyAdminId(adminId);
        userCoupon.setVerifyTime(now);
        userCouponMapper.updateById(userCoupon);

        // 记录核销日志
        CouponVerifyLog log = new CouponVerifyLog();
        log.setUserCouponId(userCoupon.getId());
        log.setVerifyCode(verifyCode);
        log.setAdminId(adminId);
        log.setVerifyTime(now);
        log.setCreateTime(now);
        couponVerifyLogMapper.insert(log);

        // 返回核销结果
        Map<String, Object> result = new HashMap<>();
        result.put("couponId", userCoupon.getId());
        result.put("templateName", template.getName());
        result.put("type", template.getType());
        result.put("discountAmount", template.getDiscountAmount());
        result.put("userId", userCoupon.getUserId());
        result.put("verifyTime", TimeUtils.timestampToDate(now));
        return result;
    }
}
