package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 挂账支付明细
 */
@Data
@TableName("la_credit_log")
public class CreditLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private Integer orderId;

    private String outTradeNo;

    private BigDecimal amount;

    /** 变动金额，扣减为负 */
    private BigDecimal changeAmount;

    /** 变动后当月上限快照 */
    private BigDecimal monthlyLimit;

    /** 变动后当月已用 */
    private BigDecimal usedAfter;

    /** 变动后当月剩余 */
    private BigDecimal remainAfter;

    private String creditMonth;

    private Long ruoyiRoleId;

    private String ruoyiRoleName;

    private Long createTime;

    @TableField(exist = false)
    private String mobile;

    @TableField(exist = false)
    private String nickName;

    /** 小程序用户昵称（la_user.nickname），与 nickName 不可同名避免 Lombok 冲突 */
    @TableField(exist = false)
    private String userNickname;

    @TableField(exist = false)
    private String deptName;

    @TableField(exist = false)
    private String orderNumber;
}
