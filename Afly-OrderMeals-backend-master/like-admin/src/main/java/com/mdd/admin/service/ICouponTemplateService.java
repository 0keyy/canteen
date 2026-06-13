package com.mdd.admin.service;

import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.coupon.CouponTemplateCreateValidate;
import com.mdd.admin.validate.coupon.CouponTemplateSearchValidate;
import com.mdd.admin.validate.coupon.CouponTemplateUpdateValidate;
import com.mdd.admin.vo.coupon.CouponTemplateDetailVo;
import com.mdd.admin.vo.coupon.CouponTemplateListVo;
import com.mdd.common.core.PageResult;

import java.util.List;

public interface ICouponTemplateService {

    PageResult<CouponTemplateListVo> list(PageValidate pageValidate, CouponTemplateSearchValidate searchValidate);

    CouponTemplateDetailVo detail(Integer id);

    void add(CouponTemplateCreateValidate createValidate);

    void edit(CouponTemplateUpdateValidate updateValidate);

    void del(Integer id);

    void change(Integer id);
}
