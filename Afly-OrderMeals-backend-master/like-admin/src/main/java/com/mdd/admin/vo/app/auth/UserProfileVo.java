package com.mdd.admin.vo.app.auth;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserProfileVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String nickname;
    private String avatar;
    private String mobile;
}
