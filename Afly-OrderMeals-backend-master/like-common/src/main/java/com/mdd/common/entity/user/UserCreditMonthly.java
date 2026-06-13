package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 用户月挂账账户（对标 la_user_points，按自然月）
 */
@Data
@TableName("la_user_credit_monthly")
public class UserCreditMonthly implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private String creditMonth;

    /** 当月挂账上限（元） */
    private BigDecimal monthlyLimit;

    /** 当月已挂账（元） */
    private BigDecimal usedAmount;

    private Long ruoyiRoleId;

    private String ruoyiRoleName;

    private Long createTime;

    private Long updateTime;

    @TableField(exist = false)
    private String mobile;

    @TableField(exist = false)
    private String nickname;

    @TableField(exist = false)
    private String deptName;

    public BigDecimal getRemainAmount() {
        if (monthlyLimit == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal used = usedAmount == null ? BigDecimal.ZERO : usedAmount;
        BigDecimal remain = monthlyLimit.subtract(used);
        return remain.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : remain;
    }
}
