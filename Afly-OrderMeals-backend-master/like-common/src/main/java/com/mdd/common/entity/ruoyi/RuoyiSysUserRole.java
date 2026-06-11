package com.mdd.common.entity.ruoyi;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 若依 sys_user_role
 */
@Data
@TableName("sys_user_role")
public class RuoyiSysUserRole implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long userId;

    private Long roleId;

    private Date createTime;
}
