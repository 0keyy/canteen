package com.mdd.admin.validate.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrdersSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer type;
    private Integer diningMode;
    private Integer source;
    private Integer status;
    private Integer payStatus;
    private String contactMobile;
    private String checkoutTime;
    private String createTime;

}
