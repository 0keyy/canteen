package com.mdd.admin.validate.company;

import lombok.Data;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class PointsGrantValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "用户ID不能为空")
    private Integer userId;

    /** 自定义积分数，为空则按若依角色自动计算 */
    @Min(value = 1, message = "积分数量必须大于0")
    private Integer amount;
}
