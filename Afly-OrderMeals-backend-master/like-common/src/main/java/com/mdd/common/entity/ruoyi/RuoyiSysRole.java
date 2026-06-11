package com.mdd.common.entity.ruoyi;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 若依 sys_role
 */
@Data
@TableName("sys_role")
public class RuoyiSysRole implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId("role_id")
    private Long roleId;

    private String roleName;

    private String roleKey;

    /** 角色状态（0正常 1停用） */
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;
}
