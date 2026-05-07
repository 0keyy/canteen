package com.mdd.admin.vo.shop;

import lombok.Data;

import java.io.Serializable;
@Data
public class PrinterVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String name;
    private Integer type;
    private String finalNumber;
    private Integer mode;
    private Integer status;
}
