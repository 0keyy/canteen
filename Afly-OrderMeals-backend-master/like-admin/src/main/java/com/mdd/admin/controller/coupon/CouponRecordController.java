package com.mdd.admin.controller.coupon;

import com.mdd.admin.service.ICouponRecordService;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.coupon.UserCouponRecordSearchValidate;
import com.mdd.admin.vo.coupon.UserCouponRecordListVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.core.PageResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api/coupon/record")
public class CouponRecordController {

    @Resource
    ICouponRecordService couponRecordService;

    @GetMapping("/list")
    public AjaxResult<PageResult<UserCouponRecordListVo>> list(
            @Validated PageValidate pageValidate,
            @Validated UserCouponRecordSearchValidate searchValidate) {
        return AjaxResult.success(couponRecordService.list(pageValidate, searchValidate));
    }
}
