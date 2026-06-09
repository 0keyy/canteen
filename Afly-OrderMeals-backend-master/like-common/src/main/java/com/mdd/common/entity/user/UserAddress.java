package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;

@Data
public class UserAddress implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer userId;
    private String contactName;
    private String contactMobile;
    private String province;
    private String city;
    private String district;
    private String detail;
    private String lat;
    private String lng;
    private Integer isDefault;
    private Integer isDelete;
    private Long createTime;
    private Long updateTime;
}
