package com.mdd.common.entity.orders;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class OrdersDish implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value="id", type= IdType.AUTO)
    private Integer id;         // 主键
    private Integer orderId;    //订单id
    private Integer dishId;     //菜品id
    private Integer quantity;   //菜品数量
    private BigDecimal amount;  //金额
    private Long createTime;
}
