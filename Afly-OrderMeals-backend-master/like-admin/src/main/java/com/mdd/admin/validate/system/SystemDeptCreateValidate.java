package com.mdd.admin.validate.system;

import com.mdd.common.validator.annotation.IntegerContains;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.DecimalMax;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.io.Serializable;

/**
 * 系统部门创建参数
 */
@Data
public class SystemDeptCreateValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "areaId参数缺失")
    @DecimalMin(value = "0", message = "值不能少于0")
    private Integer areaId;

    @NotNull(message = "name参数缺失")
    @Length(min = 1, max = 100, message = "部门名称必须在1~100个字符内")
    private String name;

    @NotNull(message = "请设置最大就餐人数")
    @DecimalMin(value = "1",message = "人数最少设置1")
    @DecimalMax(value = "100",message = "人数最多设置100")
    private Integer num;

    @NotNull(message = "请选择状态")
    @IntegerContains(values = {0, 1})
    private Integer isStop;

    @NotNull(message = "排序号不能为空")
    @DecimalMin(value = "0", message = "排序号值不能少于0")
    @DecimalMax(value = "9999", message = "排序号值不能大于9999")
    private Integer sort;

}
