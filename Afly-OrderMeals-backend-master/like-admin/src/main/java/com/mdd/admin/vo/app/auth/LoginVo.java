package com.mdd.admin.vo.app.auth;

import lombok.Data;

import java.io.Serializable;

@Data
public class LoginVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private String token;
    private Integer userId;
    private String openid;
    private String mobile;
    private String nickname;
    private String avatar;
    private Boolean needBindPhone;
}
