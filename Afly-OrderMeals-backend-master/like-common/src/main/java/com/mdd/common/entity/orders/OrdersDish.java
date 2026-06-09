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
    private Integer id;
    private Integer orderId;
    private Integer dishId;
    private Integer quantity;
    private BigDecimal amount;
    private String dishName;
    private String dishImage;
    private String remark;
    private Long createTime;
}
