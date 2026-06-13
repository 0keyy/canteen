package com.mdd.admin.vo.app.pay;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CreditPayInfoVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Boolean enabled;

    private String disabledReason;

    private BigDecimal creditLimit;

    private BigDecimal creditUsed;

    private BigDecimal creditRemain;

    private Long roleId;

    private String roleName;
}
