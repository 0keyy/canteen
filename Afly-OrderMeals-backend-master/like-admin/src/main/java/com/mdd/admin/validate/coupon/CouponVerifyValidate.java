package com.mdd.admin.validate.coupon;

import lombok.Data;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;

@Data
public class CouponVerifyValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotEmpty(message = "核销码不能为空")
    private String verifyCode;
}
