package com.mdd.admin.vo.front;

import lombok.Data;

import java.io.Serializable;

@Data
public class FoodsVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String title;      // 菜品名称
    private String intro;      // 简介
    private String price;    // 价格
    private String image;      // 封面
}
