package com.mdd.admin.vo.orders;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrdersCurrentVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer number; //订单号
    private Integer deskId;//桌号id
    private Integer userNum;//用餐人数
    private Integer status;//订单状态
    private String amount;//订单金额
}
