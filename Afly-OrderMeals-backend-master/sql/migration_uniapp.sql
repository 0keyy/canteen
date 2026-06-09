-- UniApp 点餐系统数据库迁移
-- 执行前请备份数据库

USE like_admin;

-- 扩展订单表
ALTER TABLE `la_orders`
    ADD COLUMN `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'C端用户ID' AFTER `user_num`,
    ADD COLUMN `dining_mode` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '就餐方式:1堂食2外带3外卖' AFTER `type`,
    ADD COLUMN `source` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '来源:0收银台1H5扫码2微信小程序3支付宝小程序4App' AFTER `dining_mode`,
    ADD COLUMN `pay_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付状态:0待支付1已支付2退款中3已退款4已关闭' AFTER `status`,
    ADD COLUMN `pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式:wxpay/alipay' AFTER `pay_status`,
    ADD COLUMN `pay_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '实付金额' AFTER `pay_type`,
    ADD COLUMN `pay_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付时间' AFTER `pay_amount`,
    ADD COLUMN `delivery_fee` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '配送费' AFTER `pay_time`,
    ADD COLUMN `contact_name` varchar(32) NOT NULL DEFAULT '' COMMENT '联系人' AFTER `delivery_fee`,
    ADD COLUMN `contact_mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话' AFTER `contact_name`,
    ADD COLUMN `address_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '外卖地址ID' AFTER `contact_mobile`,
    ADD COLUMN `address_snapshot` varchar(500) NOT NULL DEFAULT '' COMMENT '地址快照JSON' AFTER `address_id`,
    ADD COLUMN `pickup_code` varchar(10) NOT NULL DEFAULT '' COMMENT '外带取餐码' AFTER `address_snapshot`,
    ADD COLUMN `submit_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提交时间' AFTER `pickup_code`,
    ADD COLUMN `cancel_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '取消时间' AFTER `submit_time`,
    ADD COLUMN `cancel_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '取消原因' AFTER `cancel_time`;

ALTER TABLE `la_orders` ADD INDEX `idx_user_create` (`user_id`, `create_time`);
ALTER TABLE `la_orders` ADD INDEX `idx_aid_pay_status` (`aid`, `pay_status`, `status`);

-- 扩展订单菜品表
ALTER TABLE `la_orders_dish`
    ADD COLUMN `dish_name` varchar(100) NOT NULL DEFAULT '' COMMENT '菜品名快照' AFTER `amount`,
    ADD COLUMN `dish_image` varchar(200) NOT NULL DEFAULT '' COMMENT '菜品图快照' AFTER `dish_name`,
    ADD COLUMN `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '单品备注' AFTER `dish_image`;

-- 扩展店铺配置
ALTER TABLE `la_shop_config`
    ADD COLUMN `takeout_enable` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否开启外带' AFTER `pre_pay`,
    ADD COLUMN `delivery_enable` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否开启外卖' AFTER `takeout_enable`,
    ADD COLUMN `delivery_fee` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '基础配送费' AFTER `delivery_enable`,
    ADD COLUMN `min_order_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '起送价' AFTER `delivery_fee`,
    ADD COLUMN `delivery_radius` decimal(5,2) NOT NULL DEFAULT 5.00 COMMENT '配送半径km' AFTER `min_order_amount`;

-- 用户收货地址
CREATE TABLE IF NOT EXISTS `la_user_address` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
    `contact_name` varchar(32) NOT NULL DEFAULT '' COMMENT '联系人',
    `contact_mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
    `province` varchar(32) NOT NULL DEFAULT '' COMMENT '省',
    `city` varchar(32) NOT NULL DEFAULT '' COMMENT '市',
    `district` varchar(32) NOT NULL DEFAULT '' COMMENT '区',
    `detail` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
    `lat` varchar(20) NOT NULL DEFAULT '' COMMENT '纬度',
    `lng` varchar(20) NOT NULL DEFAULT '' COMMENT '经度',
    `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否默认:0否1是',
    `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
    `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
    `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户收货地址';

-- 支付流水
CREATE TABLE IF NOT EXISTS `la_order_pay` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
    `order_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
    `order_number` varchar(100) NOT NULL DEFAULT '' COMMENT '订单号',
    `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
    `aid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID',
    `pay_channel` varchar(20) NOT NULL DEFAULT '' COMMENT '支付渠道:wxpay/alipay',
    `pay_scene` varchar(20) NOT NULL DEFAULT '' COMMENT '支付场景:mp/app/h5',
    `out_trade_no` varchar(64) NOT NULL DEFAULT '' COMMENT '商户支付单号',
    `transaction_id` varchar(64) NOT NULL DEFAULT '' COMMENT '第三方流水号',
    `pay_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
    `pay_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0待支付1成功2失败3退款',
    `notify_data` text COMMENT '回调原文',
    `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
    `pay_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_out_trade_no` (`out_trade_no`),
    INDEX `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单支付流水';

-- 用户会话（微信session_key等）
CREATE TABLE IF NOT EXISTS `la_user_session` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
    `openid` varchar(200) NOT NULL DEFAULT '' COMMENT 'Openid',
    `session_key` varchar(200) NOT NULL DEFAULT '' COMMENT 'SessionKey',
    `client` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '客户端类型',
    `expire_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '过期时间',
    `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
    `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_openid` (`openid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户授权会话';

-- 点餐小程序底部导航默认值（对接后台「底部导航」配置）
DELETE FROM `la_decorate_tabbar`;
INSERT INTO `la_decorate_tabbar` (`name`, `selected`, `unselected`, `link`, `create_time`, `update_time`) VALUES
('首页', '/api/static/tabbar_home_sel.png', '/api/static/tabbar_home.png', '{"path":"/pages/index/index","name":"首页","type":"shop"}', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('订单', '/api/static/tabbar_text_sel.png', '/api/static/tabbar_text.png', '{"path":"/pages/order/list","name":"我的订单","type":"shop"}', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('我的', '/api/static/tabbar_me_sel.png', '/api/static/tabbar_me.png', '{"path":"/pages/mine/index","name":"个人中心","type":"shop"}', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

UPDATE `la_system_config`
SET `value` = '{"defaultColor":"#999999","selectedColor":"#ff6b35"}'
WHERE `type` = 'tabbar' AND `name` = 'style';
