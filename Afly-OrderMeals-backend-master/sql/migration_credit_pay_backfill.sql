-- 挂账明细补写：从已成功的挂账支付单同步到 la_credit_log
-- 若已执行过 migration_credit_pay.sql，可单独运行本脚本
USE like_admin;

UPDATE `la_credit_config` SET `credit_enable` = 1, `update_time` = UNIX_TIMESTAMP() WHERE `id` = 1;

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
