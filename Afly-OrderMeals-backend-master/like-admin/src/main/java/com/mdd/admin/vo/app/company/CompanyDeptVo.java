package com.mdd.admin.vo.app.company;

import lombok.Data;

import java.io.Serializable;

@Data
public class CompanyDeptVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long deptId;

    private Long parentId;

    private String deptName;
}
