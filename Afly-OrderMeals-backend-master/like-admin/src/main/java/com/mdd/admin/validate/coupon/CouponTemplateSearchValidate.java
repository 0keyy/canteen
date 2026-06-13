package com.mdd.admin.validate.coupon;

import lombok.Data;

import java.io.Serializable;

@Data
public class CouponTemplateSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private String name;

    private Integer type;

    private Integer isShow;
}
