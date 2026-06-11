-- 小程序用户公司认证表
CREATE TABLE IF NOT EXISTS `la_user_company` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '小程序用户ID',
  `ruoyi_user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '若依用户ID',
  `dept_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '部门ID',
  `dept_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '部门名称',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '若依用户名',
  `nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '若依昵称',
  `auth_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '认证时间',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_id` (`user_id`) USING BTREE,
  UNIQUE KEY `uk_ruoyi_user_id` (`ruoyi_user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户公司认证' ROW_FORMAT = DYNAMIC;
