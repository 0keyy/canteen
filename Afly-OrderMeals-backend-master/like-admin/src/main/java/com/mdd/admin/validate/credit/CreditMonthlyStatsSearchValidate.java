package com.mdd.admin.validate.credit;

import lombok.Data;

import java.io.Serializable;

@Data
public class CreditMonthlyStatsSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String mobile;
    private String nickName;
    private String deptName;
    private String creditMonth;
}
