package com.mdd.admin.validate.app.pay;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class PayCreateValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotNull(message = "订单ID不能为空")
    private Integer orderId;

    private String payChannel;
    private String payScene;
}
