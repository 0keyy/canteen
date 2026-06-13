package com.mdd.admin.service.app;

import com.mdd.admin.vo.coupon.CouponApplicableVo;
import com.mdd.admin.vo.coupon.CouponTemplateListVo;
import com.mdd.admin.vo.coupon.UserCouponListVo;

import java.util.List;
import java.util.Map;

public interface IAppCouponService {

    List<CouponTemplateListVo> center(Integer userId);

    Map<String, Object> claim(Integer templateId, Integer userId);

    List<UserCouponListVo> myCoupons(Integer userId, Integer status);

    CouponApplicableVo bestForOrder(Integer orderId, Integer userId);

    String verifyCode(Integer userCouponId, Integer userId);
}
