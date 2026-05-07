package com.mdd.admin.validate.system;

import com.mdd.common.validator.annotation.IDMust;
import com.mdd.common.validator.annotation.IntegerContains;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * 系统岗位更新参数
 */
@Data
public class SystemPostUpdateValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @IDMust(message = "id参数必传且需大于0")
    private Integer id;

    @NotNull(message = "code参数缺失")
    private String code;

    @NotNull(message = "name参数缺失")
    private String name;

    @NotNull(message = "请选择状态")
    @IntegerContains(values = {0, 1})
    private Integer isStop = 0;

    private String remarks = "";

    @NotNull(message = "排序号不能为空")
    @DecimalMin(value = "0", message = "排序号值不能少于0")
    private Integer sort = 0;

}
