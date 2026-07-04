-- ============================================
-- 优惠券并发安全修复
-- 修复内容:
--   1. 去掉 verify_code 唯一键（空字符串导致误报"数据已存在"）
--   2. 添加 (user_id, template_id) 唯一约束防止重复领取
--   3. verify_code 改为允许 NULL（无核销码的券用 NULL 代替空字符串）
-- 执行前请备份数据库
-- ============================================

USE like_admin;

-- 1. 删除 verify_code 唯一键（空字符串冲突导致"数据已存在"误报）
ALTER TABLE `la_user_coupon` DROP INDEX `uk_verify_code`;

-- 2. verify_code 改为允许 NULL，默认值改为 NULL
ALTER TABLE `la_user_coupon` MODIFY COLUMN `verify_code` varchar(32) DEFAULT NULL COMMENT '核销码（兑换券/套餐券用）';

-- 3. 将已有的空字符串 verify_code 更新为 NULL
UPDATE `la_user_coupon` SET `verify_code` = NULL WHERE `verify_code` = '';

-- 4. 添加普通索引替代原唯一键（核销码查询仍需索引）
ALTER TABLE `la_user_coupon` ADD INDEX `idx_verify_code` (`verify_code`);

-- 5. 添加用户+模板唯一约束，数据库层面防止重复领取
-- 先清理可能存在的重复数据（保留最早领取的那条）
DELETE t1 FROM `la_user_coupon` t1
INNER JOIN `la_user_coupon` t2
WHERE t1.`id` > t2.`id`
  AND t1.`user_id` = t2.`user_id`
  AND t1.`template_id` = t2.`template_id`;

ALTER TABLE `la_user_coupon` ADD UNIQUE KEY `uk_user_template` (`user_id`, `template_id`);
