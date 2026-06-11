package com.mdd.admin.validate.app.company;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class CompanyAuthValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "部门不能为空")
    private Long deptId;

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;
}
