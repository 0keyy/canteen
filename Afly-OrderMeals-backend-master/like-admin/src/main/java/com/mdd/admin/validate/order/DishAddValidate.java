package com.mdd.admin.validate.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class DishAddValidate implements Serializable {
    private static final Long serialVersionUID = 1L;

    private Integer orderId;
    private Integer dishId;
}
