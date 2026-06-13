package com.mdd.admin.validate.coupon;

import com.mdd.common.validator.annotation.IntegerContains;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CouponTemplateCreateValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotEmpty(message = "券名称不能为空")
    @Length(min = 1, max = 64, message = "券名称不能大于64个字符")
    private String name;

    @NotNull(message = "券类型不能为空")
    @IntegerContains(values = {1, 2, 3, 4, 5}, message = "券类型值不合法，仅支持1-5")
    private Integer type;

    @NotNull(message = "优惠金额不能为空")
    @DecimalMin(value = "0", message = "优惠金额不能小于0")
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

    private Integer sort;

    @NotNull(message = "缺少isShow参数")
    @IntegerContains(values = {0, 1}, message = "isShow不是合法值")
    private Integer isShow;
}
