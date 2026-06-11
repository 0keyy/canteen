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

    /** 是否已完成公司认证 */
    private Boolean companyVerified;

    /** 认证部门名称 */
    private String companyDeptName;

    /** 若依用户名 */
    private String companyUserName;

    /** 若依昵称 */
    private String companyNickName;

    /** 用户余额（认证/月度发放累计） */
    private Integer balance;
}
