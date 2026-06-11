package com.mdd.common.entity.ruoyi;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 若依 sys_user
 */
@Data
@TableName("sys_user")
public class RuoyiSysUser implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId("user_id")
    private Long userId;

    private Long deptId;

    private String userName;

    private String nickName;

    private String password;

    /** 帐号状态（0正常 1停用） */
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;

    private Date loginDate;

    private Date createTime;

    private Date updateTime;
}
