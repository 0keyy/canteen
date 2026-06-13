package com.mdd.admin.vo.credit;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CreditLogListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private String mobile;
    private String nickname;
    private String deptName;
    private Integer orderId;
    private String orderNumber;
    private String outTradeNo;
    private BigDecimal amount;
    private BigDecimal changeAmount;
    private BigDecimal monthlyLimit;
    private BigDecimal usedAfter;
    private BigDecimal remainAfter;
    private String creditMonth;
    private Long ruoyiRoleId;
    private String ruoyiRoleName;
    private String createTime;
}
