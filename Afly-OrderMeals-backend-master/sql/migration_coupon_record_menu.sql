-- 用户核销领取记录 — 菜单注册
-- 执行前确保「优惠券管理」父菜单已存在（由 migration_coupon.sql 创建）

USE like_admin;

-- 子菜单：核销领取记录（C=菜单），挂载在「优惠券管理」父菜单下
INSERT INTO `la_system_auth_menu`
  (`pid`, `menu_type`, `menu_name`, `menu_icon`, `menu_sort`, `perms`, `paths`, `component`, `selected`, `params`, `is_cache`, `is_show`, `is_disable`, `create_time`, `update_time`)
SELECT (SELECT id FROM `la_system_auth_menu` WHERE `perms` = 'coupon:manage' AND `is_disable` = 0),
       'C', '核销领取记录', '', 3, 'coupon:record:list', 'record', 'coupon/record', '', '', 0, 1, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `la_system_auth_menu` WHERE `perms` = 'coupon:record:list' AND `is_disable` = 0);

-- 注意：执行后请到「系统管理 → 角色管理」为对应角色勾选「核销领取记录」菜单权限
