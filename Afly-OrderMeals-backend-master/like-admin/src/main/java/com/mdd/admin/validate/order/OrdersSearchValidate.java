package com.mdd.admin.validate.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrdersSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer type;//订单类型

    private Integer status;//订单状态

    private String checkoutTime;//结账时间

    private String createTime;//创建时间

}
