package com.mdd.admin.vo.coupon;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CouponTemplateDetailVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer aid;
    private String name;
    private Integer type;
    private BigDecimal discountAmount;
    private BigDecimal minAmount;
    private String nightStartTime;
    private String nightEndTime;
    private Integer validDays;
    private Long useStartTime;
    private Long useEndTime;
    private Long claimStartTime;
    private Long claimEndTime;
    private Integer totalStock;
    private Integer claimedCount;
    private Integer sort;
    private Integer isShow;
    private String createTime;
    private String updateTime;
}
