package com.mdd.common.entity.orders;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class Orders implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value="id", type= IdType.AUTO)
    private Integer id;
    private Integer aid;
    private String number;
    private Integer deskId;
    private Integer userNum;
    private Integer userId;
    private Integer type;
    private Integer diningMode;
    private Integer source;
    private Integer status;
    private Integer payStatus;
    private String payType;
    private BigDecimal payAmount;
    private Long payTime;
    private BigDecimal deliveryFee;
    private String contactName;
    private String contactMobile;
    private Integer addressId;
    private String addressSnapshot;
    private String pickupCode;
    private Long submitTime;
    private Long cancelTime;
    private String cancelReason;
    private String remark;
    private String amount;
    private Long createTime;
    private Long checkoutTime;
    private Long calledTime;

    @TableField(exist = false)
    private String deskName;
}
