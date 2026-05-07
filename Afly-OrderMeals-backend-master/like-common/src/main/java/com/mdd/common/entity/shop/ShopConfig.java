package com.mdd.common.entity.shop;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;
@Data
public class ShopConfig implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id",type = IdType.AUTO)
    private Integer id;
    private Integer aid;
    private String name;
    private String intro;
    private String notice;
    private String image;
    private Integer status;
    private Integer prePay;
    private Long createTime;
    private Long updateTime;
}
