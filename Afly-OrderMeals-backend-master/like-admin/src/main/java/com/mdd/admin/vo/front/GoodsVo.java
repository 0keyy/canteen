package com.mdd.admin.vo.front;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

@Data
public class GoodsVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;          //分类名称
    private List<FoodsVo> foods;  //当前分类所有菜品
}
