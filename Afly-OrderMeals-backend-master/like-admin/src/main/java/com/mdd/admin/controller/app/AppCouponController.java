package com.mdd.admin.controller.app;

import com.mdd.admin.AppThreadLocal;
import com.mdd.admin.service.app.IAppCouponService;
import com.mdd.admin.validate.coupon.CouponClaimValidate;
import com.mdd.admin.vo.coupon.CouponApplicableVo;
import com.mdd.admin.vo.coupon.CouponTemplateListVo;
import com.mdd.admin.vo.coupon.UserCouponListVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.validator.annotation.IDMust;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/front/coupon")
public class AppCouponController {

    @Resource
    private IAppCouponService appCouponService;

    @GetMapping("/center")
    public AjaxResult<List<CouponTemplateListVo>> center() {
        Integer userId = AppThreadLocal.getUserId();
        return AjaxResult.success(appCouponService.center(userId));
    }

    @PostMapping("/claim")
    public AjaxResult<Map<String, Object>> claim(
            @Validated @RequestBody CouponClaimValidate validate) {
        Integer userId = AppThreadLocal.getUserId();
        return AjaxResult.success(appCouponService.claim(validate.getTemplateId(), userId));
    }

    @GetMapping("/my")
    public AjaxResult<List<UserCouponListVo>> myCoupons(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer userId = AppThreadLocal.getUserId();
        return AjaxResult.success(appCouponService.myCoupons(userId, status));
    }

    @GetMapping("/bestForOrder")
    public AjaxResult<CouponApplicableVo> bestForOrder(
            @Validated @IDMust() @RequestParam("orderId") Integer orderId) {
        Integer userId = AppThreadLocal.getUserId();
        return AjaxResult.success(appCouponService.bestForOrder(orderId, userId));
    }

    @GetMapping("/verifyCode")
    public AjaxResult<Object> verifyCode(
            @Validated @IDMust() @RequestParam("userCouponId") Integer userCouponId) {
        Integer userId = AppThreadLocal.getUserId();
        String code = appCouponService.verifyCode(userCouponId, userId);
        return AjaxResult.success((Object) code);
    }
}
