package com.mdd.admin.vo.app.pay;

import lombok.Data;

import java.io.Serializable;

@Data
public class PayMethodVo implements Serializable {
    private static final long serialVersionUID = 1L;

    /** 支付渠道标识 */
    private String channel;

    /** 展示名称 */
    private String name;

    /** 描述/副标题 */
    private String desc;

    /** 是否可用 */
    private Boolean enabled;

    /** 不可用原因 */
    private String disabledReason;

    /** 余额渠道：当前可用余额 */
    private Integer balance;

    /** 余额渠道：本次所需余额 */
    private Integer requiredBalance;
}
