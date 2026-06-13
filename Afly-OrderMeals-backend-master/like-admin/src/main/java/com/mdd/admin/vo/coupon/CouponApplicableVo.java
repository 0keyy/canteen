package com.mdd.admin.vo.coupon;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CouponApplicableVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer userCouponId;
    private Integer templateId;
    private String templateName;
    private Integer type;
    private BigDecimal discountAmount;
    private BigDecimal minAmount;
    private BigDecimal originalAmount;
    private BigDecimal finalPrice;
    private String verifyCode;
    private Boolean hasCoupon;
    private String couponDesc;
}
