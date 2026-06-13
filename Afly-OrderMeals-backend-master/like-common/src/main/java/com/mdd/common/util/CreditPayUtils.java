package com.mdd.common.util;

import com.mdd.common.entity.ruoyi.RuoyiSysRole;
import com.mdd.common.entity.user.CreditRoleConfig;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 挂账支付职级匹配工具
 */
public final class CreditPayUtils {

    private CreditPayUtils() {
    }

    /**
     * 在用户拥有的角色中，选取月上限最高的已启用职级配置
     */
    public static CreditRoleConfig resolveBestConfig(List<RuoyiSysRole> roles,
                                                     Map<Long, CreditRoleConfig> configMap) {
        if (roles == null || roles.isEmpty() || configMap == null || configMap.isEmpty()) {
            return null;
        }
        return roles.stream()
                .filter(role -> role.getRoleId() != null)
                .map(role -> configMap.get(role.getRoleId()))
                .filter(config -> config != null
                        && config.getIsEnable() != null && config.getIsEnable() == 1
                        && config.getMonthlyLimit() != null
                        && config.getMonthlyLimit().compareTo(BigDecimal.ZERO) > 0)
                .max(Comparator.comparing(CreditRoleConfig::getMonthlyLimit))
                .orElse(null);
    }

    public static Map<Long, CreditRoleConfig> toRoleConfigMap(List<CreditRoleConfig> configs) {
        if (configs == null || configs.isEmpty()) {
            return java.util.Collections.emptyMap();
        }
        return configs.stream()
                .filter(item -> item.getRoleId() != null)
                .collect(Collectors.toMap(CreditRoleConfig::getRoleId, item -> item, (a, b) -> a));
    }
}
