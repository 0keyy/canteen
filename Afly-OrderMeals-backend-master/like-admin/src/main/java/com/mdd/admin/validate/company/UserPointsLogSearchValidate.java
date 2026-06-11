package com.mdd.admin.validate.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserPointsLogSearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String mobile;
    private Integer source;
    private String grantMonth;
    private String createTime;
}
