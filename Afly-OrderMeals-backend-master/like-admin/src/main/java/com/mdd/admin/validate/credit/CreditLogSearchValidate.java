package com.mdd.admin.validate.credit;

import lombok.Data;

import java.io.Serializable;

@Data
public class CreditLogSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String mobile;
    private String creditMonth;
    private String createTime;
}
