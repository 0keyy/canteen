package com.mdd.common.entity.system;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;

/**
 * 系统部门实体
 */
@Data
public class SystemAuthDept implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value="id", type= IdType.AUTO)
    private Integer id;       // 主键
    private Integer aid;      // 管理员id
    private Integer areaId;   // 区域id
    private String name;      // 餐桌名称
    private Integer num;      // 最大就餐人数
    private Integer status;   //餐桌状态：[1:就餐中 0:空闲]
    private Integer sort;     // 排序编号
    private Integer isStop;   // 是否禁用: [0=否, 1=是]
    private Integer isDelete; // 是否删除: [0=否, 1=是]
    private Long createTime;  // 创建时间
    private Long updateTime;  // 更新时间
    private Long deleteTime;  // 删除时间

}
