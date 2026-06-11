-- 小程序订单叫号时间 + 后台菜单（可重复执行）
USE like_admin;

-- 1. called_time：已存在则跳过
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'la_orders'
      AND COLUMN_NAME = 'called_time'
);
SET @add_col_sql = IF(
    @col_exists = 0,
    'ALTER TABLE `la_orders` ADD COLUMN `called_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT ''叫号时间，0表示未叫号'' AFTER `checkout_time`',
    'SELECT ''called_time already exists, skip'' AS msg'
);
PREPARE stmt FROM @add_col_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 小程序订单菜单：不指定 id（796 已被「店铺设置」占用），挂到订单管理(794) 下
INSERT INTO `la_system_auth_menu`
    (`pid`, `menu_type`, `menu_name`, `menu_icon`, `menu_sort`, `perms`, `paths`, `component`, `selected`, `params`, `is_cache`, `is_show`, `is_disable`, `create_time`, `update_time`)
SELECT 794, 'C', '小程序订单', 'el-icon-Iphone', 1, 'orders:miniapp', 'miniapp', 'orders/miniapp', '', '', 0, 1, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM `la_system_auth_menu`
    WHERE `paths` = 'miniapp' AND `component` = 'orders/miniapp'
);

-- 3. 执行后请到「系统管理 → 角色管理」为对应角色勾选「小程序订单」菜单权限
