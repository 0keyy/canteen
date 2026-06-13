package com.mdd.admin.validate.coupon;

import com.mdd.common.validator.annotation.IDMust;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode(callSuper = true)
public class CouponTemplateUpdateValidate extends CouponTemplateCreateValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @IDMust(message = "id参数必传且需大于0")
    private Integer id;
}
