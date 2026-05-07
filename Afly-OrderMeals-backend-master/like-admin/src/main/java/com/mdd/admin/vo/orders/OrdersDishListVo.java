package com.mdd.admin.vo.orders;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class OrdersDishListVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;//菜品名称
    private Integer number;//数量
    private BigDecimal amount;//价格
}
