package com.mdd.admin.vo.app.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class CompanyAuthVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Boolean verified;

    private Long deptId;

    private String deptName;

    private String userName;

    private String nickName;

    private Long authTime;

    /** 本次认证发放的余额（仅首次认证时有值） */
    private Integer balanceGranted;

    /** 当前角色对应的月度余额标准 */
    private Integer monthlyBalance;
}
