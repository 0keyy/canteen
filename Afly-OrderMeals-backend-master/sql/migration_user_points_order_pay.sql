-- 余额支付扣减：积分日志表增加 order_id，调整唯一索引
ALTER TABLE `la_user_points_log`
  ADD COLUMN `order_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联订单ID，余额支付扣减时使用' AFTER `grant_month`;

ALTER TABLE `la_user_points_log` DROP INDEX `uk_user_grant_month`;

ALTER TABLE `la_user_points_log`
  ADD UNIQUE KEY `uk_user_grant_month_order` (`user_id`, `grant_month`, `order_id`) USING BTREE;
