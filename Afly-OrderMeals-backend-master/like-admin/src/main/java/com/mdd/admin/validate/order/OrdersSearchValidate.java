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

    /** 订单渠道: cashier=收银台/扫码, miniapp=小程序, 空=全部 */
    private String channel;

    /** 叫号状态: 0=未叫号, 1=已叫号 */
    private Integer called;

}
