package com.mdd.admin.vo.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class OrderDishCateVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;        // 主键
    private String name;       // 分类名称
    private Integer sort;      // 排序编号
}
