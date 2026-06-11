-- 用户积分账户
CREATE TABLE IF NOT EXISTS `la_user_points` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '小程序用户ID',
  `points` int(11) NOT NULL DEFAULT 0 COMMENT '积分余额',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_id` (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户积分账户' ROW_FORMAT = DYNAMIC;

-- 积分发放记录（按用户+月份去重）
CREATE TABLE IF NOT EXISTS `la_user_points_log` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '小程序用户ID',
  `change_amount` int(11) NOT NULL DEFAULT 0 COMMENT '变动积分',
  `balance_after` int(11) NOT NULL DEFAULT 0 COMMENT '变动后余额',
  `grant_month` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发放月份 yyyy-MM',
  `order_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联订单ID，余额支付扣减时使用',
  `ruoyi_role_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '计分角色ID',
  `ruoyi_role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '计分角色名称',
  `source` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '来源: 1=首次认证 2=月度发放 3=订单支付',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_grant_month_order` (`user_id`, `grant_month`, `order_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户积分发放记录' ROW_FORMAT = DYNAMIC;
