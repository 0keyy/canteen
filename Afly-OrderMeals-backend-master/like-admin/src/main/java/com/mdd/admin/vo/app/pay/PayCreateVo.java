package com.mdd.admin.vo.app.pay;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class PayCreateVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer orderId;
    private String outTradeNo;
    private BigDecimal payAmount;
    private String payChannel;
    private String payScene;
    private Boolean mockPay;
    private String timeStamp;
    private String nonceStr;
    private String packageValue;
    private String signType;
    private String paySign;
    private String tradeNo;

    /** 是否已完成支付（余额等同步支付渠道） */
    private Boolean completed;
}
