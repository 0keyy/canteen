package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 挂账职级上限配置
 */
@Data
@TableName("la_credit_role_config")
public class CreditRoleConfig implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Long roleId;

    private String roleName;

    /** 月挂账上限（元） */
    private BigDecimal monthlyLimit;

    /** 是否启用 0=否 1=是 */
    private Integer isEnable;

    private Long createTime;

    private Long updateTime;
}
