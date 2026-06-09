package com.mdd.admin.validate.app.auth;

import lombok.Data;

import java.io.Serializable;

@Data
public class MockPhoneLoginValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 模拟手机号，不传则使用配置默认值 */
    private String mobile;
}
