package com.mdd.admin.vo.coupon;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class UserCouponRecordListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    // ========== UserCoupon 字段 ==========
    private Integer id;
    private Integer templateId;
    private Integer userId;
    private Integer status;
    private String verifyCode;
    private Long claimTime;
    private Long useTime;
    private Integer orderId;
    private Integer verifyAdminId;
    private Long verifyTime;

    // ========== CouponTemplate 关联字段 ==========
    private String templateName;
    private Integer type;
    private BigDecimal discountAmount;
    private BigDecimal minAmount;

    // ========== User 关联字段 ==========
    private String userNickname;
    private String userMobile;
    private String userRealName;

    // ========== UserCompany 公司认证关联字段 ==========
    private String userCompanyName;

    // ========== Orders 关联字段 ==========
    private String orderNumber;

    // ========== SystemAuthAdmin 关联字段（核销人） ==========
    private String verifyAdminName;

    // ========== 格式化后的时间字符串 ==========
    private String claimTimeFormatted;
    private String useTimeFormatted;
    private String verifyTimeFormatted;
}
