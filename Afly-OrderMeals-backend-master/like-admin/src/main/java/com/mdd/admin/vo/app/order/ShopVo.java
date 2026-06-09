package com.mdd.admin.vo.app.order;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class ShopVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer aid;
    private String name;
    private String intro;
    private String notice;
    private String image;
    private Integer status;
    private Integer prePay;
    private Integer takeoutEnable;
    private Integer deliveryEnable;
    private BigDecimal deliveryFee;
    private BigDecimal minOrderAmount;
    private BigDecimal deliveryRadius;
}
