package com.mdd.admin.vo.app.address;

import lombok.Data;

import java.io.Serializable;

@Data
public class AddressVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String contactName;
    private String contactMobile;
    private String province;
    private String city;
    private String district;
    private String address;
    private String detail;
    private String lat;
    private String lng;
    private Integer isDefault;
    private String fullAddress;
    private String gender;
    private Integer label;
}
