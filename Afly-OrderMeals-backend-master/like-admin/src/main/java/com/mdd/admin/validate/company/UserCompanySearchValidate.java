package com.mdd.admin.validate.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserCompanySearchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    private String deptName;
    private String userName;
    private String nickName;
    private String mobile;
    private String authTime;
}
