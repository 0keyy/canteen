package com.mdd.admin.validate.shop;

import lombok.Data;

import java.io.Serializable;
@Data
public class PrinterValidate implements Serializable {
    private String name;
    private Integer type;
    private String finalNumber;
    private String secret;
    private Integer mode;
    private Integer status;
}
