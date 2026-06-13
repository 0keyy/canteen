package com.mdd.admin.vo.coupon;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class UserCouponListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer templateId;
    private Integer userId;
    private String verifyCode;
    private Integer status;
    private Long useStartTime;
    private Long useEndTime;
    private Long claimTime;
    private Long useTime;
    private Integer orderId;
    private Integer verifyAdminId;
    private Long verifyTime;

    // 模板关联字段
    private String templateName;
    private Integer type;
    private BigDecimal discountAmount;
    private BigDecimal minAmount;
    private String nightStartTime;
    private String nightEndTime;

    // 计算字段
    private Boolean nightUnavailable;
}
