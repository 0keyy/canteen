package com.mdd.admin.vo.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class PointsGrantResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String nickName;
    private String deptName;
    private Integer amount;
    private Integer balanceAfter;
    private String ruoyiRoleName;
}
