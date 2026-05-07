package com.mdd.admin.vo.orders;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrdersListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;  // 主键
    private String number;  // 订单号
    private String deskName;  //
    private Integer userId;  //
    private Integer type;  // 订单类型 0:后台点单1:扫码点单
    private Integer status;  // 订单状态0:待下单1:待结帐2:已完成
    private String remark;  //
    private String amount;  //
    private String createTime; //
    private String checkoutTime;  // 结账时间

}
