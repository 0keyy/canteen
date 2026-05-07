package com.mdd.admin.vo.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrderDeskVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;        // 主键
    private String area;       // 区域
    private String name;       // 餐桌名称
    private Integer num;       // 餐桌最大人数
    private Integer status;    //餐桌状态
    private Integer sort;      // 排序编号
    private Integer isStop;    // 是否停用: [0=否, 1=是]
    private String createTime; // 创建时间
    private String updateTime; // 更新时间
}
