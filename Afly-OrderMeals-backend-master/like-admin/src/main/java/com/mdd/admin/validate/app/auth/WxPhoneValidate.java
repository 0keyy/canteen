package com.mdd.admin.validate.app.auth;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

@Data
public class WxPhoneValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotBlank(message = "openid不能为空")
    private String openid;

    @NotBlank(message = "phoneCode不能为空")
    private String phoneCode;
}
