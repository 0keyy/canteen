package com.mdd.admin.vo.system;

import lombok.Data;

import java.io.Serializable;

/**
 * 部门Vo
 */
@Data
public class SystemAuthDeptVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;        // 主键
    private String area;       // 区域
    private String name;       // 名称
    private Integer num;       // 最大就餐人数
    private Integer sort;      // 排序编号
    private Integer isStop;    // 是否停用: [0=否, 1=是]
    private String createTime; // 创建时间
    private String updateTime; // 更新时间

}
