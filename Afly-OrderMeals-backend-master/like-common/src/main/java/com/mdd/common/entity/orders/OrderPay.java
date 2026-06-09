package com.mdd.common.entity.orders;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class OrderPay implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer orderId;
    private String orderNumber;
    private Integer userId;
    private Integer aid;
    private String payChannel;
    private String payScene;
    private String outTradeNo;
    private String transactionId;
    private BigDecimal payAmount;
    private Integer payStatus;
    private String notifyData;
    private Long createTime;
    private Long payTime;
}
