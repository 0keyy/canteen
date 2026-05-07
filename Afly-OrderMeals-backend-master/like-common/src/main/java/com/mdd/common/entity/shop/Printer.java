package com.mdd.common.entity.shop;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;

@Data
public class Printer implements Serializable {
    private static final long serialVersionUID = 1L;
    @TableId(value = "id",type = IdType.AUTO)
    private Integer id;
    private Integer aid;
    private String name;
    private Integer type;
    private String finalNumber;
    private String secret;
    private Integer mode;
    private Integer status;
    private Integer isDelete;
    private Long createTime;
    private Long deleteTime;
}
