package com.mdd.admin.vo.shop;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

@Data
public class ShopConfigVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String name;
    private String intro;
    private String notice;
    private String image;
    private Integer status;
    private Integer prePay;
    private Integer takeoutEnable;
    private Integer deliveryEnable;
    private java.math.BigDecimal deliveryFee;
    private java.math.BigDecimal minOrderAmount;
    private java.math.BigDecimal deliveryRadius;
}
