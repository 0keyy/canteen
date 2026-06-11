package com.mdd.admin.vo.app.order;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@Data
public class OrderDetailVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String number;
    private Integer diningMode;
    private Integer status;
    private Integer payStatus;
    private String payType;
    private BigDecimal payAmount;
    private BigDecimal deliveryFee;
    private String amount;
    private String remark;
    private String contactName;
    private String contactMobile;
    private String addressSnapshot;
    private String pickupCode;
    private Long calledTime;
    private Integer deskId;
    private String deskName;
    private String createTime;
    private String submitTime;
    private Boolean needPay;
    private List<OrderDishVo> dishes;
}
