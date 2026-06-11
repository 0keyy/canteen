-- 认证与积分管理菜单（单页：认证管理 + 积分发放明细）
USE like_admin;

INSERT INTO `la_system_auth_menu`
    (`pid`, `menu_type`, `menu_name`, `menu_icon`, `menu_sort`, `perms`, `paths`, `component`, `selected`, `params`, `is_cache`, `is_show`, `is_disable`, `create_time`, `update_time`)
SELECT 0, 'C', '认证与积分', 'el-icon-UserFilled', 46, 'company:manage', 'company', 'company/index', '', '', 0, 1, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM `la_system_auth_menu`
    WHERE `paths` = 'company' AND `component` = 'company/index'
);

-- 执行后请到「系统管理 → 角色管理」为对应角色勾选「认证与积分」菜单权限
