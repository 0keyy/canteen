package com.mdd.admin.vo.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserCompanyListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private String mobile;
    private String nickname;
    private String deptName;
    private String userName;
    private String nickName;
    private Integer balance;
    private String authTime;
}
