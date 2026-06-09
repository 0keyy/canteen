package com.mdd.admin.validate.app.order;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class DishAddValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotNull(message = "订单ID不能为空")
    private Integer orderId;

    @NotNull(message = "菜品ID不能为空")
    private Integer dishId;
}
