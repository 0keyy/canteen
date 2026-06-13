-- 用户月挂账账户 + 挂账扣减明细扩展（对标 la_user_points / la_user_points_log）
USE like_admin;

CREATE TABLE IF NOT EXISTS `la_user_credit_monthly` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '小程序用户ID',
  `credit_month` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '挂账月份 yyyy-MM',
  `monthly_limit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '当月挂账上限（元）',
  `used_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '当月已挂账（元）',
  `ruoyi_role_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '计额角色ID',
  `ruoyi_role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '计额角色名称',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_month` (`user_id`, `credit_month`) USING BTREE,
  KEY `idx_credit_month` (`credit_month`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户月挂账账户' ROW_FORMAT = DYNAMIC;

-- 以下字段若已存在会报错，可忽略后一条继续执行
ALTER TABLE `la_credit_log`
    ADD COLUMN `change_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变动金额，扣减为负' AFTER `amount`;

ALTER TABLE `la_credit_log`
    ADD COLUMN `monthly_limit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变动后当月上限快照' AFTER `change_amount`;

ALTER TABLE `la_credit_log`
    ADD COLUMN `used_after` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变动后当月已用' AFTER `monthly_limit`;

ALTER TABLE `la_credit_log`
    ADD COLUMN `remain_after` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变动后当月剩余' AFTER `used_after`;

UPDATE `la_credit_log`
SET `change_amount` = -ABS(`amount`)
WHERE (`change_amount` IS NULL OR `change_amount` = 0) AND `amount` > 0;
