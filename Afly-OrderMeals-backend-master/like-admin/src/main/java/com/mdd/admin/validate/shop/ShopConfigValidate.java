package com.mdd.admin.validate.shop;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;
@Data
public class ShopConfigValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    @Length(max = 30, message = "参数异常")
    private String name;
    @Length(max = 200, message = "参数异常")
    private String intro;
    @Length(max = 200, message = "参数异常")
    private String notice;
    private String image;
    private Integer status;
    private Integer prePay;
}
