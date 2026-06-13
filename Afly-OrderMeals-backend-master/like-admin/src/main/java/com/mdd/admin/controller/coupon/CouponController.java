package com.mdd.admin.controller.coupon;

import com.mdd.admin.config.aop.Log;
import com.mdd.admin.service.ICouponTemplateService;
import com.mdd.admin.service.ICouponVerifyService;
import com.mdd.admin.validate.commons.IdValidate;
import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.coupon.CouponTemplateCreateValidate;
import com.mdd.admin.validate.coupon.CouponTemplateSearchValidate;
import com.mdd.admin.validate.coupon.CouponTemplateUpdateValidate;
import com.mdd.admin.validate.coupon.CouponVerifyValidate;
import com.mdd.admin.vo.coupon.CouponTemplateDetailVo;
import com.mdd.admin.vo.coupon.CouponTemplateListVo;
import com.mdd.common.core.AjaxResult;
import com.mdd.common.core.PageResult;
import com.mdd.common.validator.annotation.IDMust;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Map;

@RestController
@RequestMapping("/api/coupon")
public class CouponController {

    @Resource
    ICouponTemplateService couponTemplateService;

    @Resource
    ICouponVerifyService couponVerifyService;

    @GetMapping("/template/list")
    public AjaxResult<PageResult<CouponTemplateListVo>> list(
            @Validated PageValidate pageValidate,
            @Validated CouponTemplateSearchValidate searchValidate) {
        return AjaxResult.success(couponTemplateService.list(pageValidate, searchValidate));
    }

    @GetMapping("/template/detail")
    public AjaxResult<CouponTemplateDetailVo> detail(
            @Validated @IDMust() @RequestParam("id") Integer id) {
        return AjaxResult.success(couponTemplateService.detail(id));
    }

    @Log(title = "优惠券模板新增")
    @PostMapping("/template/add")
    public AjaxResult<Object> add(
            @Validated @RequestBody CouponTemplateCreateValidate createValidate) {
        couponTemplateService.add(createValidate);
        return AjaxResult.success();
    }

    @Log(title = "优惠券模板编辑")
    @PostMapping("/template/edit")
    public AjaxResult<Object> edit(
            @Validated @RequestBody CouponTemplateUpdateValidate updateValidate) {
        couponTemplateService.edit(updateValidate);
        return AjaxResult.success();
    }

    @Log(title = "优惠券模板删除")
    @PostMapping("/template/del")
    public AjaxResult<Object> del(
            @Validated @RequestBody IdValidate idValidate) {
        couponTemplateService.del(idValidate.getId());
        return AjaxResult.success();
    }

    @Log(title = "优惠券模板状态")
    @PostMapping("/template/change")
    public AjaxResult<Object> change(
            @Validated @RequestBody IdValidate idValidate) {
        couponTemplateService.change(idValidate.getId());
        return AjaxResult.success();
    }

    @Log(title = "核销验证")
    @PostMapping("/verify")
    public AjaxResult<Map<String, Object>> verify(
            @Validated @RequestBody CouponVerifyValidate validate) {
        return AjaxResult.success(couponVerifyService.verify(validate.getVerifyCode()));
    }
}
