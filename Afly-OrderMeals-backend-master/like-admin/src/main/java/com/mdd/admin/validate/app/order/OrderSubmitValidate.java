package com.mdd.admin.validate.app.order;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class OrderSubmitValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotNull(message = "订单ID不能为空")
    private Integer orderId;

    private String remark;
    private Integer addressId;
    private String contactName;
    private String contactMobile;
    private String payChannel;
    private String payScene;
    private Integer couponId;
}
