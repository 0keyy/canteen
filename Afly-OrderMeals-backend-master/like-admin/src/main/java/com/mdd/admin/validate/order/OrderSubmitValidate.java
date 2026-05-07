package com.mdd.admin.validate.order;

import lombok.Data;

import java.io.Serializable;
@Data
public class OrderSubmitValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer number;//订单号
    private String remark;//订单备注
}
