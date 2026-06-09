package com.mdd.admin.vo.app.order;

import lombok.Data;

import java.io.Serializable;

@Data
public class FoodVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String title;
    private String intro;
    private String price;
    private String image;
}
