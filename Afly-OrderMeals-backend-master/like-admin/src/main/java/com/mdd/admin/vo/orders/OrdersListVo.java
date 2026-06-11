package com.mdd.admin.vo.orders;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrdersListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private String number;
    private String deskName;
    private Integer userId;
    private Integer userNum;
    private Integer type;
    private Integer diningMode;
    private Integer source;
    private Integer status;
    private Integer payStatus;
    private String payType;
    private String contactName;
    private String contactMobile;
    private String pickupCode;
    private String addressSnapshot;
    private String remark;
    private String amount;
    private String createTime;
    private String submitTime;
    private String payTime;
    private String calledTime;
    private String checkoutTime;

}
