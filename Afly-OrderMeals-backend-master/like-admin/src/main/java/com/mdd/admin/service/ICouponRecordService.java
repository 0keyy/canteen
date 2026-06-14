package com.mdd.admin.service;

import com.mdd.admin.validate.commons.PageValidate;
import com.mdd.admin.validate.coupon.UserCouponRecordSearchValidate;
import com.mdd.admin.vo.coupon.UserCouponRecordListVo;
import com.mdd.common.core.PageResult;

public interface ICouponRecordService {

    /**
     * 用户核销领取记录列表
     *
     * @param pageValidate   分页参数
     * @param searchValidate 搜索参数
     * @return PageResult<UserCouponRecordListVo>
     */
    PageResult<UserCouponRecordListVo> list(PageValidate pageValidate, UserCouponRecordSearchValidate searchValidate);
}
