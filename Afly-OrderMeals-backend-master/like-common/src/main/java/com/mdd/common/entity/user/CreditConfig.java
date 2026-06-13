package com.mdd.common.entity.user;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 挂账全局配置
 */
@Data
@TableName("la_credit_config")
public class CreditConfig implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId("id")
    private Integer id;

    /** 是否开启挂账支付 */
    private Integer creditEnable;

    private Long createTime;

    private Long updateTime;
}
