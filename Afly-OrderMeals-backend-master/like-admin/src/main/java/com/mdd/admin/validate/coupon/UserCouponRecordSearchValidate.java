package com.mdd.admin.validate.coupon;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserCouponRecordSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 状态: 1=已领取 2=已使用 3=已过期 */
    private Integer status;

    /** 券类型: 1=无门槛 2=满减 3=兑换券 4=套餐券 5=夜间券 */
    private Integer type;

    /** 模糊搜索: 用户昵称/手机号/券名称 */
    private String userInfo;

    /** 领取时间范围: 逗号分隔的两个Unix秒时间戳 */
    private String claimTime;
}
