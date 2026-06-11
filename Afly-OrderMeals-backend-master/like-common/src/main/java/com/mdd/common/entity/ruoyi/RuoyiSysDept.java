package com.mdd.common.entity.ruoyi;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 若依 sys_dept
 */
@Data
@TableName("sys_dept")
public class RuoyiSysDept implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId("dept_id")
    private Long deptId;

    private Long parentId;

    private String ancestors;

    private String deptName;

    private Integer orderNum;

    /** 部门状态（0正常 1停用） */
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;

    private Date createTime;

    private Date updateTime;
}
