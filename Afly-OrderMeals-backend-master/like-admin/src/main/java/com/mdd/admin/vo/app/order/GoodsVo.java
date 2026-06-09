package com.mdd.admin.vo.app.order;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

@Data
public class GoodsVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;
    private List<FoodVo> foods;
}
