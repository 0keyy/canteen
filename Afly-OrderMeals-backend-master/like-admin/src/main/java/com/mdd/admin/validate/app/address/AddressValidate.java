package com.mdd.admin.validate.app.address;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.io.Serializable;

@Data
public class AddressValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;

    @NotBlank(message = "联系人不能为空")
    @Size(max = 32, message = "联系人姓名不能超过32个字符")
    private String contactName;

    @NotBlank(message = "联系电话不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String contactMobile;

    private String province;

    private String city;

    private String district;

    private String address;

    @Size(max = 255, message = "详细地址不能超过255个字符")
    private String detail;

    private String gender;

    private String lat;
    private String lng;
    private Integer isDefault;
}
