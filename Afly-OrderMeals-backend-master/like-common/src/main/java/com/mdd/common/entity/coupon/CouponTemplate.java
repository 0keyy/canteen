package com.mdd.common.entity.coupon;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CouponTemplate implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer aid;
    private String name;
    private Integer type;
    private BigDecimal discountAmount;
    private BigDecimal minAmount;
    private String nightStartTime;
    private String nightEndTime;
    private Integer validDays;
    private Long useStartTime;
    private Long useEndTime;
    private Long claimStartTime;
    private Long claimEndTime;
    private Integer totalStock;
    private Integer claimedCount;
    private Integer sort;
    private Integer isShow;
    private Integer isDelete;
    private Long createTime;
    private Long updateTime;
    private Long deleteTime;
}
