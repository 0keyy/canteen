package com.mdd.admin.validate.app.auth;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

@Data
public class WxLoginValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotBlank(message = "code不能为空")
    private String code;
}
