package com.mdd.admin.vo.app.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrderListVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String number;
    private Integer diningMode;
    private Integer status;
    private Integer payStatus;
    private String amount;
    private String pickupCode;
    private Long calledTime;
    private String createTime;
}
