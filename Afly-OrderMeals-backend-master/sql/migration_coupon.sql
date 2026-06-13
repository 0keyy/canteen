-- 优惠券系统数据库迁移
-- 执行前请备份数据库

USE like_admin;

-- ============================================
-- 1. 优惠券模板表
-- ============================================
CREATE TABLE IF NOT EXISTS `la_coupon_template` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID（admin_id，租户隔离）',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '券名称，如"新客10元无门槛券"',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '券类型: 1=无门槛券 2=满减券 3=兑换券 4=套餐券 5=夜间券',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '优惠金额（元）',
  `min_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '使用门槛金额（满减券用，无门槛券为0）',
  `night_start_time` varchar(5) NOT NULL DEFAULT '' COMMENT '夜间券可用开始时间 HH:mm，如"21:00"',
  `night_end_time` varchar(5) NOT NULL DEFAULT '' COMMENT '夜间券可用结束时间 HH:mm，如"06:00"（跨午夜）',
  `valid_days` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '领取后有效天数（0=不限制，按固定时间段计算）',
  `use_start_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '固定使用开始时间（Unix秒）',
  `use_end_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '固定使用结束时间（Unix秒）',
  `claim_start_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '领取开始时间（Unix秒）',
  `claim_end_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '领取结束时间（Unix秒）',
  `total_stock` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '库存总量（0=不限量）',
  `claimed_count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序号',
  `is_show` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否显示: [0=否, 1=是]',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: [0=否, 1=是]',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_aid` (`aid`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_claim_time` (`claim_start_time`, `claim_end_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券模板' ROW_FORMAT = DYNAMIC;

-- ============================================
-- 2. 用户优惠券表
-- ============================================
CREATE TABLE IF NOT EXISTS `la_user_coupon` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `template_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '优惠券模板ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `verify_code` varchar(32) NOT NULL DEFAULT '' COMMENT '核销码（兑换券/套餐券用，唯一）',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态: 1=已领取 2=已使用 3=已过期',
  `use_start_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '券生效时间（Unix秒）',
  `use_end_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '券失效时间（Unix秒）',
  `claim_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '领取时间',
  `use_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用时间',
  `order_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用订单ID',
  `verify_admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '核销操作人（管理员ID）',
  `verify_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '核销时间',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: [0=否, 1=是]',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_verify_code` (`verify_code`) USING BTREE,
  KEY `idx_user_status` (`user_id`, `status`) USING BTREE,
  KEY `idx_template` (`template_id`) USING BTREE,
  KEY `idx_order` (`order_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户优惠券' ROW_FORMAT = DYNAMIC;

-- ============================================
-- 3. 优惠券核销记录表
-- ============================================
CREATE TABLE IF NOT EXISTS `la_coupon_verify_log` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_coupon_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户优惠券ID',
  `verify_code` varchar(32) NOT NULL DEFAULT '' COMMENT '核销码',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '核销管理员ID',
  `verify_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '核销时间',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_coupon` (`user_coupon_id`) USING BTREE,
  KEY `idx_admin_time` (`admin_id`, `verify_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券核销记录' ROW_FORMAT = DYNAMIC;

-- ============================================
-- 4. 订单表扩展（优惠券字段）
-- ============================================
ALTER TABLE `la_orders`
    ADD COLUMN `coupon_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用的用户优惠券ID' AFTER `pay_amount`,
    ADD COLUMN `coupon_discount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '优惠券抵扣金额' AFTER `coupon_id`;

ALTER TABLE `la_orders` ADD INDEX `idx_coupon` (`coupon_id`);

-- ============================================
-- 5. 后台菜单（优惠券管理）
-- ============================================

-- 父菜单：优惠券管理（M=目录）
INSERT INTO `la_system_auth_menu`
  (`pid`, `menu_type`, `menu_name`, `menu_icon`, `menu_sort`, `perms`, `paths`, `component`, `selected`, `params`, `is_cache`, `is_show`, `is_disable`, `create_time`, `update_time`)
SELECT 0, 'M', '优惠券管理', 'el-icon-Tickets', 50, 'coupon:manage', 'coupon', '', '', '', 0, 1, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_system_auth_menu` WHERE `perms` = 'coupon:manage' AND `is_disable` = 0);

-- 子菜单：模板列表（C=菜单）
INSERT INTO `la_system_auth_menu`
  (`pid`, `menu_type`, `menu_name`, `menu_icon`, `menu_sort`, `perms`, `paths`, `component`, `selected`, `params`, `is_cache`, `is_show`, `is_disable`, `create_time`, `update_time`)
SELECT (SELECT id FROM `la_system_auth_menu` WHERE `perms` = 'coupon:manage' AND `is_disable` = 0), 'C', '模板列表', '', 1, 'coupon:template:list', 'list', 'coupon/index', '', '', 0, 1, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_system_auth_menu` WHERE `perms` = 'coupon:template:list' AND `is_disable` = 0);

-- 子菜单：核销验证（C=菜单）
INSERT INTO `la_system_auth_menu`
  (`pid`, `menu_type`, `menu_name`, `menu_icon`, `menu_sort`, `perms`, `paths`, `component`, `selected`, `params`, `is_cache`, `is_show`, `is_disable`, `create_time`, `update_time`)
SELECT (SELECT id FROM `la_system_auth_menu` WHERE `perms` = 'coupon:manage' AND `is_disable` = 0), 'C', '核销验证', '', 2, 'coupon:verify', 'verify', 'coupon/verify', '', '', 0, 1, 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_system_auth_menu` WHERE `perms` = 'coupon:verify' AND `is_disable` = 0);
