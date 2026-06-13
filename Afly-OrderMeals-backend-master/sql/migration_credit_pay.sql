-- 挂账支付：全局开关、职级上限配置、挂账明细
USE like_admin;

-- 全局挂账配置（单行）
CREATE TABLE IF NOT EXISTS `la_credit_config` (
  `id` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '主键，固定为1',
  `credit_enable` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否开启挂账支付 0=关闭 1=开启',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '挂账全局配置' ROW_FORMAT = DYNAMIC;

INSERT INTO `la_credit_config` (`id`, `credit_enable`, `create_time`, `update_time`)
SELECT 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `la_credit_config` WHERE `id` = 1);

UPDATE `la_credit_config` SET `credit_enable` = 1, `update_time` = UNIX_TIMESTAMP() WHERE `id` = 1;

-- 按若依职级(role_id)设置月挂账上限
CREATE TABLE IF NOT EXISTS `la_credit_role_config` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '若依角色ID',
  `role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  `monthly_limit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '月挂账上限（元）',
  `is_enable` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否启用 0=否 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_role_id` (`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '挂账职级上限配置' ROW_FORMAT = DYNAMIC;

-- 挂账支付明细
CREATE TABLE IF NOT EXISTS `la_credit_log` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '小程序用户ID',
  `order_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `out_trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付单号',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '挂账金额（元）',
  `credit_month` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '挂账月份 yyyy-MM',
  `ruoyi_role_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '计额角色ID',
  `ruoyi_role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '计额角色名称',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_order` (`user_id`, `order_id`) USING BTREE,
  KEY `idx_user_month` (`user_id`, `credit_month`) USING BTREE,
  KEY `idx_credit_month` (`credit_month`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '挂账支付明细' ROW_FORMAT = DYNAMIC;

-- 默认职级挂账上限（按 sys_role.role_id，可按需在后台调整）
INSERT INTO `la_credit_role_config` (`role_id`, `role_name`, `monthly_limit`, `is_enable`, `create_time`, `update_time`)
SELECT 104, '总监', 3000.00, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_credit_role_config` WHERE `role_id` = 104);

INSERT INTO `la_credit_role_config` (`role_id`, `role_name`, `monthly_limit`, `is_enable`, `create_time`, `update_time`)
SELECT 106, '销售副总监', 3000.00, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_credit_role_config` WHERE `role_id` = 106);

INSERT INTO `la_credit_role_config` (`role_id`, `role_name`, `monthly_limit`, `is_enable`, `create_time`, `update_time`)
SELECT 102, '经理', 1500.00, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_credit_role_config` WHERE `role_id` = 102);

INSERT INTO `la_credit_role_config` (`role_id`, `role_name`, `monthly_limit`, `is_enable`, `create_time`, `update_time`)
SELECT 105, '主管', 1000.00, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_credit_role_config` WHERE `role_id` = 105);

INSERT INTO `la_credit_role_config` (`role_id`, `role_name`, `monthly_limit`, `is_enable`, `create_time`, `update_time`)
SELECT 2, '业务员', 500.00, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `la_credit_role_config` WHERE `role_id` = 2);

-- 从历史挂账支付单补写明细（la_order_pay.pay_channel = credit）
INSERT INTO `la_credit_log` (`user_id`, `order_id`, `out_trade_no`, `amount`, `credit_month`, `ruoyi_role_id`, `ruoyi_role_name`, `create_time`)
SELECT
    op.`user_id`,
    op.`order_id`,
    IFNULL(op.`out_trade_no`, ''),
    IFNULL(op.`pay_amount`, 0),
    DATE_FORMAT(FROM_UNIXTIME(IF(op.`pay_time` > 0, op.`pay_time`, op.`create_time`)), '%Y-%m'),
    0,
    '',
    IF(op.`pay_time` > 0, op.`pay_time`, op.`create_time`)
FROM `la_order_pay` op
WHERE op.`pay_channel` = 'credit'
  AND op.`pay_status` = 1
  AND NOT EXISTS (
      SELECT 1 FROM `la_credit_log` cl
      WHERE cl.`user_id` = op.`user_id` AND cl.`order_id` = op.`order_id`
  );
