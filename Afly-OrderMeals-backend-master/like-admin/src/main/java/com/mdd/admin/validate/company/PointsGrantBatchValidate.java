package com.mdd.admin.validate.company;

import lombok.Data;

import javax.validation.constraints.Min;
import java.io.Serializable;

@Data
public class PointsGrantBatchValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 自定义积分数，为空则按若依角色自动计算 */
    @Min(value = 1, message = "积分数量必须大于0")
    private Integer amount;
}
