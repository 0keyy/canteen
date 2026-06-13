package com.mdd.admin.vo.credit;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CreditMonthlyStatsVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String mobile;
    private String nickname;
    private String deptName;
    private String creditMonth;
    private BigDecimal totalAmount;
    private Integer orderCount;
    private BigDecimal monthlyLimit;
    private BigDecimal remainAmount;
    private String ruoyiRoleName;
}
