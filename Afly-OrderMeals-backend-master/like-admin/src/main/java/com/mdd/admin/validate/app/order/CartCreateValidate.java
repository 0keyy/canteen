package com.mdd.admin.validate.app.order;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class CartCreateValidate implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotNull(message = "店铺ID不能为空")
    private Integer aid;

    @NotNull(message = "就餐方式不能为空")
    private Integer diningMode;

    private Integer deskId;
    private Integer userNum;
    private Integer source;
}
