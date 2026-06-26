-- UniApp 点餐系统数据库迁移
-- 执行前请备份数据库

use zhongtang;

-- 扩展订单表
alter table `la_orders`
    add column `user_id` int(10) unsigned not null default 0 comment 'C端用户ID' after `user_num`,
    add column `dining_mode` tinyint(1) unsigned not null default 1 comment '就餐方式:1堂食2外带3外卖' after `type`,
    add column `source` tinyint(1) unsigned not null default 0 comment '来源:0收银台1H5扫码2微信小程序3支付宝小程序4App' after `dining_mode`,
    add column `pay_status` tinyint(1) unsigned not null default 0 comment '支付状态:0待支付1已支付2退款中3已退款4已关闭' after `status`,
    add column `pay_type` varchar(20) not null default '' comment '支付方式:wxpay/alipay' after `pay_status`,
    add column `pay_amount` decimal(10,2) not null default 0.00 comment '实付金额' after `pay_type`,
    add column `pay_time` int(10) unsigned not null default 0 comment '支付时间' after `pay_amount`,
    add column `delivery_fee` decimal(10,2) not null default 0.00 comment '配送费' after `pay_time`,
    add column `contact_name` varchar(32) not null default '' comment '联系人' after `delivery_fee`,
    add column `contact_mobile` varchar(20) not null default '' comment '联系电话' after `contact_name`,
    add column `address_id` int(10) unsigned not null default 0 comment '外卖地址ID' after `contact_mobile`,
    add column `address_snapshot` varchar(500) not null default '' comment '地址快照JSON' after `address_id`,
    add column `pickup_code` varchar(10) not null default '' comment '外带取餐码' after `address_snapshot`,
    add column `submit_time` int(10) unsigned not null default 0 comment '提交时间' after `pickup_code`,
    add column `cancel_time` int(10) unsigned not null default 0 comment '取消时间' after `submit_time`,
    add column `cancel_reason` varchar(255) not null default '' comment '取消原因' after `cancel_time`;

alter table `la_orders` add index `idx_user_create` (`user_id`, `create_time`);
alter table `la_orders` add index `idx_aid_pay_status` (`aid`, `pay_status`, `status`);

-- 扩展订单菜品表
alter table `la_orders_dish`
    add column `dish_name` varchar(100) not null default '' comment '菜品名快照' after `amount`,
    add column `dish_image` varchar(200) not null default '' comment '菜品图快照' after `dish_name`,
    add column `remark` varchar(255) not null default '' comment '单品备注' after `dish_image`;

-- 扩展店铺配置
alter table `la_shop_config`
    add column `takeout_enable` tinyint(1) unsigned not null default 1 comment '是否开启外带' after `pre_pay`,
    add column `delivery_enable` tinyint(1) unsigned not null default 0 comment '是否开启外卖' after `takeout_enable`,
    add column `delivery_fee` decimal(10,2) not null default 0.00 comment '基础配送费' after `delivery_enable`,
    add column `min_order_amount` decimal(10,2) not null default 0.00 comment '起送价' after `delivery_fee`,
    add column `delivery_radius` decimal(5,2) not null default 5.00 comment '配送半径km' after `min_order_amount`;

-- 用户收货地址
create table if not exists `la_user_address` (
    `id` int(10) unsigned not null auto_increment comment '主键',
    `user_id` int(10) unsigned not null default 0 comment '用户ID',
    `contact_name` varchar(32) not null default '' comment '联系人',
    `contact_mobile` varchar(20) not null default '' comment '联系电话',
    `province` varchar(32) not null default '' comment '省',
    `city` varchar(32) not null default '' comment '市',
    `district` varchar(32) not null default '' comment '区',
    `detail` varchar(255) not null default '' comment '详细地址',
    `lat` varchar(20) not null default '' comment '纬度',
    `lng` varchar(20) not null default '' comment '经度',
    `is_default` tinyint(1) unsigned not null default 0 comment '是否默认:0否1是',
    `is_delete` tinyint(1) unsigned not null default 0 comment '是否删除',
    `create_time` int(10) unsigned not null default 0 comment '创建时间',
    `update_time` int(10) unsigned not null default 0 comment '更新时间',
    primary key (`id`) using btree,
    index `idx_user_id` (`user_id`)
) engine=innodb default charset=utf8mb4 comment='用户收货地址';

-- 支付流水
create table if not exists `la_order_pay` (
    `id` int(10) unsigned not null auto_increment comment '主键',
    `order_id` int(10) unsigned not null default 0 comment '订单ID',
    `order_number` varchar(100) not null default '' comment '订单号',
    `user_id` int(10) unsigned not null default 0 comment '用户ID',
    `aid` int(10) unsigned not null default 0 comment '商户ID',
    `pay_channel` varchar(20) not null default '' comment '支付渠道:wxpay/alipay',
    `pay_scene` varchar(20) not null default '' comment '支付场景:mp/app/h5',
    `out_trade_no` varchar(64) not null default '' comment '商户支付单号',
    `transaction_id` varchar(64) not null default '' comment '第三方流水号',
    `pay_amount` decimal(10,2) not null default 0.00 comment '支付金额',
    `pay_status` tinyint(1) unsigned not null default 0 comment '0待支付1成功2失败3退款',
    `notify_data` text comment '回调原文',
    `create_time` int(10) unsigned not null default 0 comment '创建时间',
    `pay_time` int(10) unsigned not null default 0 comment '支付时间',
    primary key (`id`) using btree,
    unique index `uk_out_trade_no` (`out_trade_no`),
    index `idx_order_id` (`order_id`)
) engine=innodb default charset=utf8mb4 comment='订单支付流水';

-- 用户会话（微信session_key等）
create table if not exists `la_user_session` (
    `id` int(10) unsigned not null auto_increment comment '主键',
    `user_id` int(10) unsigned not null default 0 comment '用户ID',
    `openid` varchar(200) not null default '' comment 'Openid',
    `session_key` varchar(200) not null default '' comment 'SessionKey',
    `client` tinyint(1) unsigned not null default 1 comment '客户端类型',
    `expire_time` int(10) unsigned not null default 0 comment '过期时间',
    `create_time` int(10) unsigned not null default 0 comment '创建时间',
    `update_time` int(10) unsigned not null default 0 comment '更新时间',
    primary key (`id`) using btree,
    index `idx_openid` (`openid`)
) engine=innodb default charset=utf8mb4 comment='用户授权会话';

-- 点餐小程序底部导航默认值（对接后台「底部导航」配置）
delete from `la_decorate_tabbar`;
insert into `la_decorate_tabbar` (`name`, `selected`, `unselected`, `link`, `create_time`, `update_time`) values
('首页', '/api/static/tabbar_home_sel.png', '/api/static/tabbar_home.png', '{"path":"/pages/index/index","name":"首页","type":"shop"}', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('订单', '/api/static/tabbar_text_sel.png', '/api/static/tabbar_text.png', '{"path":"/pages/order/list","name":"我的订单","type":"shop"}', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('我的', '/api/static/tabbar_me_sel.png', '/api/static/tabbar_me.png', '{"path":"/pages/mine/index","name":"个人中心","type":"shop"}', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

update `la_system_config`
set `value` = '{"defaultColor":"#999999","selectedColor":"#ff6b35"}'
where `type` = 'tabbar' and `name` = 'style';
-- 余额支付扣减：积分日志表增加 order_id，调整唯一索引
alter table `la_user_points_log`
  add column `order_id` int(10) unsigned not null default 0 comment '关联订单ID，余额支付扣减时使用' after `grant_month`;

alter table `la_user_points_log` drop index `uk_user_grant_month`;

alter table `la_user_points_log`
  add unique key `uk_user_grant_month_order` (`user_id`, `grant_month`, `order_id`) using btree;
