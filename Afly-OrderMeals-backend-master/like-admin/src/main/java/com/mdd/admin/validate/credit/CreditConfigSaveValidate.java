package com.mdd.admin.validate.credit;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@Data
public class CreditConfigSaveValidate implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "请设置挂账开关")
    private Integer creditEnable;

    private List<RoleConfigItem> roleConfigs;

    @Data
    public static class RoleConfigItem implements Serializable {
        private static final long serialVersionUID = 1L;

        @NotNull(message = "角色ID不能为空")
        private Long roleId;

        private String roleName;

        private BigDecimal monthlyLimit;

        private Integer isEnable;
    }
}
