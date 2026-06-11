-- 若依用户唯一认证约束（已建表环境执行）
ALTER TABLE `la_user_company`
  ADD UNIQUE KEY `uk_ruoyi_user_id` (`ruoyi_user_id`);
