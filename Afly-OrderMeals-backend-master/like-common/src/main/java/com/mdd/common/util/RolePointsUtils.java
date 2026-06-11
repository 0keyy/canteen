package com.mdd.common.util;

import com.mdd.common.entity.ruoyi.RuoyiSysRole;

import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 根据若依角色计算月度积分
 */
public final class RolePointsUtils {

    public static final int HIGH_POINTS = 500;
    public static final int NORMAL_POINTS = 200;

    /** 超级管理员 role_id，不参与 500 档 */
    private static final long SUPER_ADMIN_ROLE_ID = 1L;

    /**
     * 500 积分角色（总监 / 副总监 / 管理员，不含超级管理员）
     * 104=总监 106=销售副总监 108=管理员
     * 117=供应链总监 119=工厂总监 120=生产总监 121=生产供应总监
     */
    private static final Set<Long> HIGH_POINT_ROLE_IDS = Collections.unmodifiableSet(new HashSet<>(Arrays.asList(
            104L, 106L, 108L, 117L, 119L, 120L, 121L
    )));

    private RolePointsUtils() {
    }

    public static int calcMonthlyPoints(List<RuoyiSysRole> roles) {
        if (roles == null || roles.isEmpty()) {
            return NORMAL_POINTS;
        }
        int max = NORMAL_POINTS;
        for (RuoyiSysRole role : roles) {
            max = Math.max(max, calcRolePoints(role));
        }
        return max;
    }

    public static RuoyiSysRole getHighestRole(List<RuoyiSysRole> roles) {
        if (roles == null || roles.isEmpty()) {
            return null;
        }
        return Collections.max(roles, Comparator.comparingInt(RolePointsUtils::calcRolePoints));
    }

    public static int calcRolePoints(RuoyiSysRole role) {
        if (role == null) {
            return NORMAL_POINTS;
        }
        if (isSuperAdmin(role)) {
            return NORMAL_POINTS;
        }
        if (role.getRoleId() != null && HIGH_POINT_ROLE_IDS.contains(role.getRoleId())) {
            return HIGH_POINTS;
        }
        // 兜底：新增角色尚未加入白名单时，按角色名匹配
        String roleName = role.getRoleName();
        if (roleName == null || roleName.isEmpty()) {
            return NORMAL_POINTS;
        }
        if (roleName.contains("副总监")) {
            return HIGH_POINTS;
        }
        if (roleName.contains("总监")) {
            return HIGH_POINTS;
        }
        if ("管理员".equals(roleName)) {
            return HIGH_POINTS;
        }
        return NORMAL_POINTS;
    }

    public static boolean isSuperAdmin(RuoyiSysRole role) {
        if (role == null) {
            return false;
        }
        if (role.getRoleId() != null && role.getRoleId() == SUPER_ADMIN_ROLE_ID) {
            return true;
        }
        return "admin".equals(role.getRoleKey()) || "超级管理员".equals(role.getRoleName());
    }
}
