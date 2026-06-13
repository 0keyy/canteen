package com.mdd.common.entity.coupon;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;

@Data
public class UserCoupon implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer templateId;
    private Integer userId;
    private String verifyCode;
    private Integer status;
    private Long useStartTime;
    private Long useEndTime;
    private Long claimTime;
    private Long useTime;
    private Integer orderId;
    private Integer verifyAdminId;
    private Long verifyTime;
    private Integer isDelete;
    private Long createTime;
    private Long updateTime;
    private Long deleteTime;
}
