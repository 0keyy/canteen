package com.mdd.admin.vo.credit;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@Data
public class CreditConfigDetailVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer creditEnable;

    private List<RoleConfigVo> roleConfigs;

    @Data
    public static class RoleConfigVo implements Serializable {
        private static final long serialVersionUID = 1L;

        private Long roleId;
        private String roleName;
        private String roleKey;
        private BigDecimal monthlyLimit;
        private Integer isEnable;
    }
}
