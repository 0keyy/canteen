package com.mdd.admin.validate.coupon;

import com.mdd.common.validator.annotation.IDMust;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class CouponClaimValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "模板ID不能为空")
    @IDMust(message = "模板ID必须大于0")
    private Integer templateId;
}
