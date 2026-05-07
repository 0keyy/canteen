package com.mdd.admin.validate.front;

import lombok.Data;

import java.io.Serializable;

@Data
public class FrontOrdersCreateValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer aid;     //商户id
    private Integer deskId;  //桌号id
    private Integer userNum; //用餐人数
    private Integer type;    //下单类型0:后台点单1:扫码点单
}
