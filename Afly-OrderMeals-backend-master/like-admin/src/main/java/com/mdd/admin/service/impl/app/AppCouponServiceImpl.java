package com.mdd.admin.service.impl.app;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.github.yulichang.query.MPJQueryWrapper;
import com.mdd.admin.service.app.IAppCouponService;
import com.mdd.admin.vo.coupon.CouponApplicableVo;
import com.mdd.admin.vo.coupon.CouponTemplateListVo;
import com.mdd.admin.vo.coupon.UserCouponListVo;
import com.mdd.common.entity.coupon.CouponTemplate;
import com.mdd.common.entity.coupon.UserCoupon;
import com.mdd.common.entity.orders.Orders;
import com.mdd.common.entity.orders.OrdersDish;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.coupon.CouponTemplateMapper;
import com.mdd.common.mapper.coupon.UserCouponMapper;
import com.mdd.common.mapper.orders.OrdersDishMapper;
import com.mdd.common.mapper.orders.OrdersMapper;
import com.mdd.common.util.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

@Service
public class AppCouponServiceImpl implements IAppCouponService {

    @Resource
    CouponTemplateMapper couponTemplateMapper;

    @Resource
    UserCouponMapper userCouponMapper;

    @Resource
    OrdersMapper ordersMapper;

    @Resource
    OrdersDishMapper ordersDishMapper;

    @Override
    public List<CouponTemplateListVo> center(Integer userId) {
        long now = TimeUtils.timestamp();

        QueryWrapper<CouponTemplate> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("is_delete", 0)
                .eq("is_show", 1)
                .orderByDesc(Arrays.asList("sort", "id"));

        // 筛选领取时间窗口
        queryWrapper.and(w -> {
            // claim_start_time为空或已到领取开始时间
            w.isNull("claim_start_time").or().le("claim_start_time", now);
        });
        queryWrapper.and(w -> {
            // claim_end_time为空或未过领取结束时间
            w.isNull("claim_end_time").or().ge("claim_end_time", now);
        });

        List<CouponTemplate> templates = couponTemplateMapper.selectList(queryWrapper);

        List<CouponTemplateListVo> list = new ArrayList<>();
        for (CouponTemplate template : templates) {
            CouponTemplateListVo vo = new CouponTemplateListVo();
            BeanUtils.copyProperties(template, vo);
            vo.setUseStartTime(template.getUseStartTime() != null && template.getUseStartTime() > 0
                    ? TimeUtils.timestampToDate(template.getUseStartTime()) : "");
            vo.setUseEndTime(template.getUseEndTime() != null && template.getUseEndTime() > 0
                    ? TimeUtils.timestampToDate(template.getUseEndTime()) : "");
            vo.setClaimStartTime(template.getClaimStartTime() != null && template.getClaimStartTime() > 0
                    ? TimeUtils.timestampToDate(template.getClaimStartTime()) : "");
            vo.setClaimEndTime(template.getClaimEndTime() != null && template.getClaimEndTime() > 0
                    ? TimeUtils.timestampToDate(template.getClaimEndTime()) : "");
            vo.setCreateTime(TimeUtils.timestampToDate(template.getCreateTime()));
            vo.setUpdateTime(TimeUtils.timestampToDate(template.getUpdateTime()));
            list.add(vo);
        }

        return list;
    }

    @Override
    @Transactional
    public Map<String, Object> claim(Integer templateId, Integer userId) {
        long now = TimeUtils.timestamp();

        // 使用 FOR UPDATE 悲观锁查询模板，防止并发超发
        CouponTemplate template = couponTemplateMapper.selectOne(
                new QueryWrapper<CouponTemplate>()
                        .eq("id", templateId)
                        .eq("is_delete", 0)
                        .eq("is_show", 1)
                        .last("FOR UPDATE"));

        if (template == null) {
            throw new BaseException(500, "券不存在或已下架");
        }

        // 验证领取时间窗口
        if (template.getClaimStartTime() > 0 && now < template.getClaimStartTime()) {
            throw new BaseException(500, "尚未到领取时间");
        }
        if (template.getClaimEndTime() > 0 && now > template.getClaimEndTime()) {
            throw new BaseException(500, "领取时间已过");
        }

        // 验证库存（FOR UPDATE 保证并发安全）
        int claimedCount = template.getClaimedCount() != null ? template.getClaimedCount() : 0;
        if (template.getTotalStock() > 0 && claimedCount >= template.getTotalStock()) {
            throw new BaseException(500, "该券已被领完");
        }

        // 验证用户是否已领取（过滤软删除记录）
        Long alreadyClaimed = userCouponMapper.selectCount(
                new QueryWrapper<UserCoupon>()
                        .eq("template_id", templateId)
                        .eq("user_id", userId)
                        .eq("is_delete", 0));
        if (alreadyClaimed > 0) {
            throw new BaseException(500, "您已领取过该券");
        }

        // 计算使用有效期
        long useStartTime;
        long useEndTime;
        if (template.getValidDays() != null && template.getValidDays() > 0) {
            useStartTime = now;
            useEndTime = now + template.getValidDays() * 86400L;
        } else {
            useStartTime = template.getUseStartTime() != null ? template.getUseStartTime() : 0;
            useEndTime = template.getUseEndTime() != null ? template.getUseEndTime() : 0;
        }

        // 生成核销码（仅兑换券和套餐券，其余类型为 NULL 避免唯一键冲突）
        String verifyCode = null;
        if (template.getType() == 3 || template.getType() == 4) {
            verifyCode = UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase();
        }

        // 创建用户券
        UserCoupon userCoupon = new UserCoupon();
        userCoupon.setTemplateId(templateId);
        userCoupon.setUserId(userId);
        userCoupon.setVerifyCode(verifyCode);
        userCoupon.setStatus(1);
        userCoupon.setUseStartTime(useStartTime);
        userCoupon.setUseEndTime(useEndTime);
        userCoupon.setClaimTime(now);
        userCoupon.setCreateTime(now);
        userCouponMapper.insert(userCoupon);

        // 增加已领取计数
        template.setClaimedCount(claimedCount + 1);
        couponTemplateMapper.updateById(template);

        Map<String, Object> result = new HashMap<>();
        result.put("id", userCoupon.getId());
        result.put("templateId", templateId);
        result.put("templateName", template.getName());
        result.put("discountAmount", template.getDiscountAmount());
        result.put("verifyCode", verifyCode != null ? verifyCode : "");
        return result;
    }

    @Override
    public List<UserCouponListVo> myCoupons(Integer userId, Integer status) {
        long now = TimeUtils.timestamp();

        // 自动过期：将过期的券标记为 status=3
        userCouponMapper.update(null,
                new com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper<UserCoupon>()
                        .set("status", 3)
                        .eq("status", 1)
                        .gt("use_end_time", 0)
                        .lt("use_end_time", now));

        // 查询用户券
        QueryWrapper<UserCoupon> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        if (status != null && status > 0) {
            queryWrapper.eq("status", status);
        }
        queryWrapper.orderByDesc("id");

        List<UserCoupon> userCoupons = userCouponMapper.selectList(queryWrapper);

        List<UserCouponListVo> list = new ArrayList<>();
        for (UserCoupon userCoupon : userCoupons) {
            CouponTemplate template = couponTemplateMapper.selectById(userCoupon.getTemplateId());
            if (template == null) {
                continue;
            }

            UserCouponListVo vo = new UserCouponListVo();
            BeanUtils.copyProperties(userCoupon, vo);
            vo.setTemplateName(template.getName());
            vo.setType(template.getType());
            vo.setDiscountAmount(template.getDiscountAmount());
            vo.setMinAmount(template.getMinAmount());
            vo.setNightStartTime(template.getNightStartTime());
            vo.setNightEndTime(template.getNightEndTime());

            // 夜间券：检查当前时间是否在夜间窗口内
            if (template.getType() == 5 && userCoupon.getStatus() == 1) {
                vo.setNightUnavailable(!isInNightWindow(template.getNightStartTime(), template.getNightEndTime()));
            } else {
                vo.setNightUnavailable(false);
            }

            list.add(vo);
        }

        return list;
    }

    @Override
    public CouponApplicableVo bestForOrder(Integer orderId, Integer userId) {
        long now = TimeUtils.timestamp();

        // 自动过期
        userCouponMapper.update(null,
                new com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper<UserCoupon>()
                        .set("status", 3)
                        .eq("status", 1)
                        .gt("use_end_time", 0)
                        .lt("use_end_time", now));

        // 获取订单
        Orders orders = ordersMapper.selectById(orderId);
        if (orders == null) {
            throw new BaseException(500, "订单不存在");
        }

        // 计算菜品总额
        BigDecimal dishAmount = ordersDishMapper.compute(orderId);
        if (dishAmount == null || dishAmount.compareTo(BigDecimal.ZERO) <= 0) {
            CouponApplicableVo vo = new CouponApplicableVo();
            vo.setHasCoupon(false);
            vo.setOriginalAmount(BigDecimal.ZERO);
            vo.setFinalPrice(BigDecimal.ZERO);
            vo.setCouponDesc("订单无菜品");
            return vo;
        }

        // 查询可用券
        QueryWrapper<UserCoupon> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId)
                .eq("status", 1);
        // 使用时间过滤
        queryWrapper.and(w -> {
            w.isNull("use_start_time").or().le("use_start_time", now);
        });
        queryWrapper.and(w -> {
            w.isNull("use_end_time").or().ge("use_end_time", now);
        });

        List<UserCoupon> userCoupons = userCouponMapper.selectList(queryWrapper);

        BigDecimal bestPrice = dishAmount;
        UserCoupon bestCoupon = null;
        CouponTemplate bestTemplate = null;

        for (UserCoupon userCoupon : userCoupons) {
            CouponTemplate template = couponTemplateMapper.selectById(userCoupon.getTemplateId());
            if (template == null) {
                continue;
            }

            BigDecimal candidatePrice = null;

            switch (template.getType()) {
                case 1: // 无门槛券
                    candidatePrice = dishAmount.subtract(template.getDiscountAmount()).max(BigDecimal.ZERO);
                    break;

                case 2: // 满减券
                    if (dishAmount.compareTo(template.getMinAmount()) >= 0) {
                        candidatePrice = dishAmount.subtract(template.getDiscountAmount()).max(BigDecimal.ZERO);
                    }
                    break;

                case 3: // 兑换券 - 不自动抵扣，跳过
                case 4: // 套餐券 - 不自动抵扣，跳过
                    break;

                case 5: // 夜间券
                    if (isInNightWindow(template.getNightStartTime(), template.getNightEndTime())) {
                        BigDecimal minAmount = template.getMinAmount() != null ? template.getMinAmount() : BigDecimal.ZERO;
                        if (minAmount.compareTo(BigDecimal.ZERO) > 0) {
                            // 有门槛 → 按满减规则
                            if (dishAmount.compareTo(minAmount) >= 0) {
                                candidatePrice = dishAmount.subtract(template.getDiscountAmount()).max(BigDecimal.ZERO);
                            }
                        } else {
                            // 无门槛 → 直接减
                            candidatePrice = dishAmount.subtract(template.getDiscountAmount()).max(BigDecimal.ZERO);
                        }
                    }
                    break;
            }

            if (candidatePrice != null && candidatePrice.compareTo(bestPrice) < 0) {
                bestPrice = candidatePrice;
                bestCoupon = userCoupon;
                bestTemplate = template;
            }
        }

        CouponApplicableVo vo = new CouponApplicableVo();
        vo.setOriginalAmount(dishAmount);
        vo.setHasCoupon(bestCoupon != null);
        vo.setFinalPrice(bestPrice);

        if (bestCoupon != null && bestTemplate != null) {
            vo.setUserCouponId(bestCoupon.getId());
            vo.setTemplateId(bestTemplate.getId());
            vo.setTemplateName(bestTemplate.getName());
            vo.setType(bestTemplate.getType());
            vo.setDiscountAmount(bestTemplate.getDiscountAmount());
            vo.setMinAmount(bestTemplate.getMinAmount());
            vo.setVerifyCode(bestCoupon.getVerifyCode());
            vo.setCouponDesc("可优惠 ¥" + bestTemplate.getDiscountAmount().setScale(2, RoundingMode.HALF_UP));
        } else {
            vo.setCouponDesc("暂无可用优惠券");
        }

        return vo;
    }

    @Override
    public String verifyCode(Integer userCouponId, Integer userId) {
        UserCoupon userCoupon = userCouponMapper.selectOne(
                new QueryWrapper<UserCoupon>()
                        .eq("id", userCouponId)
                        .eq("user_id", userId));

        if (userCoupon == null) {
            throw new BaseException(500, "券不存在");
        }

        CouponTemplate template = couponTemplateMapper.selectById(userCoupon.getTemplateId());
        if (template == null || (template.getType() != 3 && template.getType() != 4)) {
            throw new BaseException(500, "该券不支持核销码");
        }

        if (userCoupon.getStatus() != 1) {
            throw new BaseException(500, "该券不可用");
        }

        return userCoupon.getVerifyCode();
    }

    /**
     * 判断当前时间是否在夜间窗口内
     * @param nightStart 开始时间，如 "21:00"
     * @param nightEnd 结束时间，如 "06:00"（跨午夜）
     */
    private boolean isInNightWindow(String nightStart, String nightEnd) {
        if (nightStart == null || nightStart.isEmpty() || nightEnd == null || nightEnd.isEmpty()) {
            return false;
        }

        try {
            String[] startParts = nightStart.split(":");
            String[] endParts = nightEnd.split(":");
            int startMin = Integer.parseInt(startParts[0]) * 60 + Integer.parseInt(startParts[1]);
            int endMin = Integer.parseInt(endParts[0]) * 60 + Integer.parseInt(endParts[1]);

            Calendar cal = Calendar.getInstance();
            int nowMin = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE);

            if (startMin <= endMin) {
                // 同一天内的窗口，如 18:00 - 22:00
                return nowMin >= startMin && nowMin <= endMin;
            } else {
                // 跨午夜窗口，如 21:00 - 06:00
                return nowMin >= startMin || nowMin <= endMin;
            }
        } catch (Exception e) {
            return false;
        }
    }
}
