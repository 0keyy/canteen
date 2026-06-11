package com.mdd.admin.vo.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserPointsLogListVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private String mobile;
    private String nickname;
    private Integer changeAmount;
    private Integer balanceAfter;
    private Integer source;
    private String sourceText;
    private String grantMonth;
    private Integer orderId;
    private String ruoyiRoleName;
    private String createTime;
}
