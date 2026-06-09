package com.mdd.admin.vo.app.order;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class OrderDishVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer dishId;
    private String dishName;
    private String dishImage;
    private Integer quantity;
    private BigDecimal amount;
    private String remark;
}
