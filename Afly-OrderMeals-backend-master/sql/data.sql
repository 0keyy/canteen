/*
 Navicat Premium Data Transfer

 Source Server         : 127.0.0.1
 Source Server Type    : MySQL
 Source Server Version : 80012
 Source Host           : localhost:3306
 Source Schema         : like_admin

 Target Server Type    : MySQL
 Target Server Version : 80012
 File Encoding         : 65001

 Date: 21/04/2024 13:24:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for la_album
-- ----------------------------
DROP TABLE IF EXISTS `la_album`;
CREATE TABLE `la_album`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `cid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '类目ID',
  `aid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `type` tinyint(2) UNSIGNED NOT NULL DEFAULT 10 COMMENT '文件类型: [10=图片, 20=视频]',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名称',
  `uri` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `ext` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件扩展',
  `size` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文件大小',
  `is_delete` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cid`(`cid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '相册管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_album
-- ----------------------------
INSERT INTO `la_album` VALUES (1, 0, 1, 0, 10, 'ba.png', 'image/20230314/cc2bba00-11aa-4b51-ad83-1aba2b5f5f49.png', 'png', 19256, 1, 1678775527, 1678775527, 1678775975);
INSERT INTO `la_album` VALUES (2, 0, 1, 0, 10, '002.png', 'image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png', 'png', 98642, 0, 1678777684, 1678777684, 0);
INSERT INTO `la_album` VALUES (3, 0, 1, 0, 10, '2[OYW7C(IG`RE9@9JOWDF6Y.jpg', 'image/20230331/0bd05fb4-bba7-4d9d-b25c-fbde32347f7b.jpg', 'jpg', 6164134, 1, 1680254559, 1680254559, 1680333316);
INSERT INTO `la_album` VALUES (4, 0, 1, 0, 10, 'ba.png', 'image/20230401/d515867b-9f34-452b-9278-d1f9cd53ae01.png', 'png', 19256, 1, 1680336301, 1680336301, 1680336313);
INSERT INTO `la_album` VALUES (5, 0, 1, 0, 10, 'ba.png', 'image/20230401/ecd183ef-2b6b-4f2a-904d-5a9ada624231.png', 'png', 1352, 1, 1680336740, 1680336740, 1680337361);
INSERT INTO `la_album` VALUES (6, 0, 1, 0, 10, '2[OYW7C(IG`RE9@9JOWDF6Y.jpg', 'image/20230401/6e6e91fa-a83a-4b6e-8f08-f8f4857de7c0.jpg', 'jpg', 1696832, 1, 1680336755, 1680336755, 1680337358);
INSERT INTO `la_album` VALUES (7, 0, 1, 0, 10, 'ba.png', 'image/20230401/b1677da1-ec79-463e-bddb-a7a4730eb310.png', 'png', 19256, 1, 1680337365, 1680337365, 1680337512);
INSERT INTO `la_album` VALUES (8, 0, 1, 0, 10, 'QQ截图20220330172216.png', 'image/20230401/92c48b0c-88db-4d99-acac-bd6fcea18701.png', 'png', 863299, 1, 1680337437, 1680337437, 1680337510);
INSERT INTO `la_album` VALUES (9, 0, 1, 0, 10, '一亿像素中国地图.jpg', 'image/20230401/8c2e6e3f-0311-498a-9190-4307fb39fe3e.jpg', 'jpg', 5291134, 1, 1680337477, 1680337477, 1680337507);
INSERT INTO `la_album` VALUES (10, 0, 1, 0, 10, 'QQ截图20220330172216.png', 'image/20230403/9808920f-73a0-4218-bd13-0ed4e8376772.png', 'png', 863299, 1, 1680529279, 1680529279, 1685608859);
INSERT INTO `la_album` VALUES (11, 0, 1, 0, 10, '017be761222ef211013eaf70aab03c.jpg', 'image/20230404/1cbb9b93-22be-4fbd-9758-ccd0198f760c.jpg', 'jpg', 422478, 0, 1680621801, 1680621801, 0);
INSERT INTO `la_album` VALUES (12, 0, 1, 0, 10, '01743b5c2db88aa8012029ac7d92b2.jpg@1280w_1l_2o_100sh.jpg', 'image/20230404/3c3675e9-1df6-4bc0-89b6-0a233770afe3.jpg', 'jpg', 780147, 0, 1680621823, 1680621823, 0);
INSERT INTO `la_album` VALUES (13, 0, 1, 0, 10, 'a85fddc2519f4ab785e55fbd791dd90a_1125w_1455h.jpg', 'image/20230404/da5235ff-ea93-4b6e-969a-2c43d9eb4c91.jpg', 'jpg', 15684, 0, 1680622187, 1680622187, 0);
INSERT INTO `la_album` VALUES (14, 0, 1, 0, 10, 'u=3794021449,3553549761&fm=253&fmt=auto&app=138&f=JPEG.jpeg', 'image/20230406/be5490cf-72b6-4dd8-9b10-88fa39e11b0e.jpeg', 'jpeg', 60578, 0, 1680763969, 1680763969, 0);
INSERT INTO `la_album` VALUES (15, 0, 1, 0, 10, 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (6).jpeg', 'image/20230406/69d2d96e-f023-4806-aa22-56994f43cb64.jpeg', 'jpeg', 22912, 0, 1680764081, 1680764081, 0);
INSERT INTO `la_album` VALUES (16, 0, 1, 0, 10, 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (2).jpeg', 'image/20230406/60b7fb06-c7a2-40cc-ba4e-debcfb9cc25e.jpeg', 'jpeg', 30062, 0, 1680764100, 1680764100, 0);
INSERT INTO `la_album` VALUES (17, 0, 1, 0, 10, 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (3).jpeg', 'image/20230406/e835893b-3f60-41f2-aaa7-a5a79104946c.jpeg', 'jpeg', 34744, 0, 1680764196, 1680764196, 0);
INSERT INTO `la_album` VALUES (18, 0, 1, 0, 10, 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (1).jpeg', 'image/20230408/27d0bc3d-05b2-42dc-a9b3-79b97d9ebda8.jpeg', 'jpeg', 37428, 0, 1680948093, 1680948093, 0);
INSERT INTO `la_album` VALUES (19, 0, 1, 0, 10, 'backend_backdrop.png', 'image/20230515/e757b7d5-e4c1-42e0-aad0-9b7ae82e0a9e.png', 'png', 63332, 0, 1684138999, 1684138999, 0);
INSERT INTO `la_album` VALUES (20, 0, 1, 0, 10, '表情.gif', 'image/20230528/0610fcf3-d20d-4070-86cd-9732c2da4ee3.gif', 'gif', 211902, 0, 1685255865, 1685255865, 0);
INSERT INTO `la_album` VALUES (21, 0, 1, 0, 10, '干烧排骨.jpeg', 'image/20230604/427c32bf-2838-4f65-95a6-60f1152afb98.jpeg', 'jpeg', 54637, 0, 1685860776, 1685860776, 0);
INSERT INTO `la_album` VALUES (22, 0, 1, 0, 10, '蒙古烤羊排.jpeg', 'image/20230604/5d2b0a56-e661-4b59-bf21-4b81d63ac734.jpeg', 'jpeg', 74648, 0, 1685860776, 1685860776, 0);
INSERT INTO `la_album` VALUES (23, 0, 1, 0, 10, '干锅肥肠.jpeg', 'image/20230604/503d0c8d-4909-4ef1-a794-22bba366fe5c.jpeg', 'jpeg', 51740, 0, 1685860776, 1685860776, 0);
INSERT INTO `la_album` VALUES (24, 0, 1, 0, 10, '三人套餐.jpg', 'image/20230604/d0ff35e6-91f6-4377-bc1c-cc95509ed185.jpg', 'jpg', 97637, 0, 1685861483, 1685861483, 0);
INSERT INTO `la_album` VALUES (25, 0, 1, 0, 10, '开胃大虾.jpg', 'image/20230604/af4735e4-1d0a-42bb-93e5-842c2111d3f6.jpg', 'jpg', 138889, 0, 1685861483, 1685861483, 0);
INSERT INTO `la_album` VALUES (26, 0, 1, 0, 10, '蒜香小龙虾.jpg', 'image/20230604/9f862c45-0958-41e0-ac00-0d96998a6b66.jpg', 'jpg', 257450, 0, 1685861483, 1685861483, 0);
INSERT INTO `la_album` VALUES (27, 0, 1, 0, 10, '可乐.jpeg', 'image/20230604/768a00c7-8d9f-4062-b44d-f3f3b367992e.jpeg', 'jpeg', 28751, 0, 1685861802, 1685861802, 0);
INSERT INTO `la_album` VALUES (28, 0, 1, 0, 10, '青岛崂山啤酒.jpeg', 'image/20230604/e589574e-cf31-41ac-a5fa-8916e08da816.jpeg', 'jpeg', 13071, 0, 1685861802, 1685861802, 0);
INSERT INTO `la_album` VALUES (29, 0, 1, 0, 10, '河南烩面.jpg', 'image/20230604/94db5aba-3dd7-4573-b8c4-547dabb44c75.jpg', 'jpg', 131860, 0, 1685861877, 1685861877, 0);
INSERT INTO `la_album` VALUES (30, 0, 1, 0, 10, '灌汤包.jpeg', 'image/20230604/f1b6112c-7b87-43b5-8113-212a590325be.jpeg', 'jpeg', 40184, 0, 1685861969, 1685861969, 0);
INSERT INTO `la_album` VALUES (31, 0, 1, 0, 10, '胡辣汤.jpeg', 'image/20230604/08de6cc7-3ac8-41ea-9de5-18912f19c1b3.jpeg', 'jpeg', 196374, 0, 1685862029, 1685862029, 0);
INSERT INTO `la_album` VALUES (32, 0, 1, 0, 10, '卷煎.jpeg', 'image/20230604/d0bb39f6-70be-4aa1-99ad-84dd50b30f2d.jpeg', 'jpeg', 185743, 0, 1685862125, 1685862125, 0);
INSERT INTO `la_album` VALUES (33, 0, 1, 0, 10, '开封高炉烧饼.jpeg', 'image/20230604/50d62e5f-c32b-41d8-a42a-eba705973666.jpeg', 'jpeg', 487988, 0, 1685862170, 1685862170, 0);
INSERT INTO `la_album` VALUES (34, 0, 1, 0, 10, '蒸米.jpeg', 'image/20230604/05a6b94c-dfbf-4c46-a3a4-8f03e1ec5545.jpeg', 'jpeg', 188949, 0, 1685862272, 1685862272, 0);
INSERT INTO `la_album` VALUES (35, 0, 1, 0, 10, '凉拌金针菇.jpeg', 'image/20230604/06bbacc6-c6be-4030-ae94-a9fd72f573e3.jpeg', 'jpeg', 296451, 0, 1685862378, 1685862378, 0);

-- ----------------------------
-- Table structure for la_album_cate
-- ----------------------------
DROP TABLE IF EXISTS `la_album_cate`;
CREATE TABLE `la_album_cate`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `aid` int(10) NOT NULL,
  `type` tinyint(2) UNSIGNED NOT NULL DEFAULT 10 COMMENT '类型: [10=图片, 20=视频]',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: [0=否, 1=是]',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '相册分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_album_cate
-- ----------------------------

-- ----------------------------
-- Table structure for la_article
-- ----------------------------
DROP TABLE IF EXISTS `la_article`;
CREATE TABLE `la_article`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cid` int(10) UNSIGNED NOT NULL COMMENT '分类',
  `aid` int(10) NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `intro` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '简介',
  `summary` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '摘要',
  `image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容',
  `author` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `visit` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 50 COMMENT '排序',
  `is_show` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否显示: 0=否, 1=是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cid_idx`(`cid`) USING BTREE COMMENT '分类索引'
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章资讯表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_article
-- ----------------------------
INSERT INTO `la_article` VALUES (1, 1, 0, '让生活更精致！五款居家好物推荐，实用性超高', '##好物推荐🔥', '随着当代生活节奏的忙碌，很多人在闲暇之余都想好好的享受生活。随着科技的发展，也出现了越来越多可以帮助我们提升幸福感，让生活变得更精致的产品，下面周周就给大家盘点五款居家必备的好物，都是实用性很高的产品，周周可以保证大家买了肯定会喜欢。', '/api/static/article01.png', '<p><img src=\"https://likeadmin-java.yixiangonline.com/api/uploads/image/20220916/46d29489-4260-4917-8eca-d0f6cba6af23.png\" alt=\"\" data-href=\"\" style=\"\"/></p><p>拥有一台投影仪，闲暇时可以在家里直接看影院级别的大片，光是想想都觉得超级爽。市面上很多投影仪大几千，其实周周觉得没必要，选泰捷这款一千多的足够了，性价比非常高。</p><p>泰捷的专业度很高，在电视TV领域研发已经十年，有诸多专利和技术创新，荣获国内外多项技术奖项，拿下了腾讯创新工场投资，打造的泰捷视频TV端和泰捷电视盒子都获得了极高评价。</p><p>这款投影仪的分辨率在3000元内无敌，做到了真1080P高分辨率，也就是跟市场售价三千DLP投影仪一样的分辨率，真正做到了分毫毕现，像桌布的花纹、天空的云彩等，这些细节都清晰可见。</p><p>亮度方面，泰捷达到了850ANSI流明，同价位一般是200ANSI。这是因为泰捷为了提升亮度和LCD技术透射率低的问题，首创高功率LED灯源，让其亮度做到同价位最好。专业媒体也进行了多次对比，效果与3000元价位投影仪相当。</p><p>操作系统周周也很喜欢，完全不卡。泰捷作为资深音视频品牌，在系统优化方面有十年的研发经验，打造出的“零极”系统是业内公认效率最高、速度最快的系统，用户也评价它流畅度能一台顶三台，而且为了解决行业广告多这一痛点，系统内不植入任何广告。</p>', '红花', 9, 0, 1, 0, 1663317759, 1663322726, 0);
INSERT INTO `la_article` VALUES (2, 1, 0, '埋葬UI设计师的坟墓不是内卷，而是免费模式', '', '本文从另外一个角度，聊聊作者对UI设计师职业发展前景的担忧，欢迎从事UI设计的同学来参与讨论，会有赠书哦', '/api/static/article02.jpeg', '<p><br></p><p style=\"text-align: justify;\">一个职业，卷，根本就没什么大不了的，尤其是成熟且收入高的职业，不卷才不符合事物发展的规律。何况 UI 设计师的人力市场到今天也和 5 年前一样，还是停留在大型菜鸡互啄的场面。远不能和医疗、证券、教师或者演艺练习生相提并论。</p><p style=\"text-align: justify;\">真正会让我对 <a href=\"https://www.uisdc.com/tag/ui\" target=\"_blank\">UI</a> 设计师发展前景觉得悲观的事情就只有一件 —— 国内的互联网产品免费机制。这也是一个我一直以来想讨论的话题，就在这次写一写。</p><p style=\"text-align: justify;\">国内互联网市场的发展，是一部浩瀚的 “免费经济” 发展史。虽然今天免费已经是深入国内民众骨髓的认知，但最早的中文互联网也是需要付费的，网游也都是要花钱的。</p><p style=\"text-align: justify;\">只是自有国情在此，付费确实阻碍了互联网行业的扩张和普及，一批创业家就开始通过免费的模式为用户提供服务，从而扩大了自己的产品覆盖面和普及程度。</p><p style=\"text-align: justify;\">印象最深的就是免费急先锋周鸿祎，和现在鲜少出现在公众视野不同，一零年前他是当之无愧的互联网教主，因为他开发出了符合中国国情的互联网产品 “打法”，让 360 的发展如日中天。</p><p style=\"text-align: justify;\">就是他在自传中提到：</p><p style=\"text-align: justify;\">只要是在互联网上每个人都需要的服务，我们就认为它是基础服务，基础服务一定是免费的，这样的话不会形成价值歧视。就是说，只要这种服务是每个人都一定要用的，我一定免费提供，而且是无条件免费。增值服务不是所有人都需要的，这个比例可能会相当低，它只是百分之几甚至更少比例的人需要，所以这种服务一定要收费……</p><p style=\"text-align: justify;\">这就是互联网的游戏规则，它决定了要想建立一个有效的商业模式，就一定要有海量的用户基数……</p>', '一一', 23, 0, 1, 0, 1663320938, 1663322854, 0);
INSERT INTO `la_article` VALUES (3, 2, 0, '金山电池公布“沪广深市民绿色生活方式”调查结果', '', '60%以上受访者认为高质量的10分钟足以完成“自我充电”', '/api/static/article03.png', '<p style=\"text-align: left;\"><strong>深圳，2021年10月22日）</strong>生活在一线城市的沪广深市民一向以效率见称，工作繁忙和快节奏的生活容易缺乏充足的休息。近日，一项针对沪广深市民绿色生活方式而展开的网络问卷调查引起了大家的注意。问卷的问题设定集中于市民对休息时间的看法，以及从对循环充电电池的使用方面了解其对绿色生活方式的态度。该调查采用随机抽样的模式，并对最终收集的1,500份有效问卷进行专业分析后发现，超过60%的受访者表示，在每天的工作时段能拥有10分钟高质量的休息时间，就可以高效“自我充电”。该调查结果反映出，在快节奏时代下，人们需要高质量的休息时间，也要学会利用高效率的休息方式和工具来应对快节奏的生活，以时刻保持“满电”状态。</p><p style=\"text-align: left;\">　　<strong>60%以上受访者认为高质量的10分钟足以完成“自我充电”</strong></p><p style=\"text-align: left;\">　　这次调查超过1,500人，主要聚焦18至85岁的沪广深市民，了解他们对于休息时间的观念及使用充电电池的习惯，结果发现：</p><p style=\"text-align: left;\">　　· 90%以上有工作受访者每天工作时间在7小时以上，平均工作时间为8小时，其中43%以上的受访者工作时间超过9小时</p><p style=\"text-align: left;\">　　· 70%受访者认为在工作期间拥有10分钟“自我充电”时间不是一件困难的事情</p><p style=\"text-align: left;\">　　· 60%受访者认为在工作期间有10分钟休息时间足以为自己快速充电</p><p style=\"text-align: left;\">　　临床心理学家黄咏诗女士在发布会上分享为自己快速充电的实用技巧，她表示：“事实上，只要选择正确的休息方法，10分钟也足以为自己充电。以喝咖啡为例，我们可以使用心灵休息法 ── 静观呼吸，慢慢感受咖啡的温度和气味，如果能配合着聆听流水或海洋的声音，能够有效放松大脑及心灵。”</p><p style=\"text-align: left;\">　　这次调查结果反映出沪广深市民的希望在繁忙的工作中适时停下来，抽出10分钟喝杯咖啡、聆听音乐或小睡片刻，为自己充电。金山电池全新推出的“绿再十分充”超快速充电器仅需10分钟就能充好电，喝一杯咖啡的时间既能完成“自我充电”，也满足设备使用的用电需求，为提升工作效率和放松身心注入新能量。</p><p style=\"text-align: left;\">　　<strong>金山电池推出10分钟超快电池充电器*绿再十分充，以创新科技为市场带来革新体验</strong></p><p style=\"text-align: left;\">　　该问卷同时从沪广深市民对循环充电电池的使用方面进行了调查，以了解其对绿色生活方式的态度：</p><p style=\"text-align: left;\">　　· 87%受访者目前没有使用充电电池，其中61%表示会考虑使用充电电池</p><p style=\"text-align: left;\">　　· 58%受访者过往曾使用过充电电池，却只有20%左右市民仍在使用</p><p style=\"text-align: left;\">　　· 60%左右受访者认为充电电池尚未被广泛使用，主要障碍来自于充电时间过长、缺乏相关教育</p><p style=\"text-align: left;\">　　· 90%以上受访者认为充电电池充满电需要1小时或更长的时间</p><p style=\"text-align: left;\">　　金山电池一直致力于为大众提供安全可靠的充电电池，并与消费者的需求和生活方式一起演变及进步。今天，金山电池宣布推出10分钟超快电池充电器*绿再十分充，只需10分钟*即可将4粒绿再十分充充电电池充好电，充电速度比其他品牌提升3倍**。充电器的LED灯可以显示每粒电池的充电状态和模式，并提示用户是否错误插入已损坏电池或一次性电池。尽管其体型小巧，却具备多项创新科技 ，如拥有独特的充电算法以优化充电电流，并能根据各个电池类型、状况和温度用最短的时间为充电电池充好电;绿再十分充内置横流扇，有效防止电池温度过热和提供低噪音的充电环境等。<br></p>', '中网资讯科技', 3, 0, 1, 0, 1663322665, 1663322665, 0);
INSERT INTO `la_article` VALUES (4, 1, 0, '测试测试测试', '这是简介测试测试', '100', 'image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png', '测试测试', '123', 122, 0, 1, 0, 1679548943, 1684307756, 1679562938);
INSERT INTO `la_article` VALUES (5, 6, 1, '黄瓜炒鸡蛋', '这是一个黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋', '666', '/image/20230406/69d2d96e-f023-4806-aa22-56994f43cb64.jpeg', '', '', 0, 0, 1, 0, 1680420146, 1680764089, 0);
INSERT INTO `la_article` VALUES (6, 4, 1, '西红柿炒鸡蛋', '就是西红柿炒鸡蛋', '999', '/image/20230406/be5490cf-72b6-4dd8-9b10-88fa39e11b0e.jpeg', '', '', 0, 0, 1, 0, 1680529284, 1680763976, 0);
INSERT INTO `la_article` VALUES (7, 3, 1, '清香凉菜', '好吃的凉菜', '100', '/image/20230404/3c3675e9-1df6-4bc0-89b6-0a233770afe3.jpg', '', '', 0, 0, 1, 0, 1680621860, 1680621860, 0);
INSERT INTO `la_article` VALUES (8, 4, 1, '红烧肉', '红烧肉啊', '688', '/image/20230404/1cbb9b93-22be-4fbd-9758-ccd0198f760c.jpg', '', '', 0, 0, 1, 0, 1680621961, 1680621961, 0);
INSERT INTO `la_article` VALUES (9, 4, 1, '爆炒鱿鱼', '这是个爆炒鱿鱼', '222', '/image/20230404/da5235ff-ea93-4b6e-969a-2c43d9eb4c91.jpg', '', '', 0, 0, 1, 0, 1680622210, 1680622210, 0);
INSERT INTO `la_article` VALUES (10, 4, 1, '油闷大虾', '这是个油闷大虾', '20', '/image/20230406/60b7fb06-c7a2-40cc-ba4e-debcfb9cc25e.jpeg', '', '', 0, 0, 1, 0, 1680764150, 1680764150, 0);
INSERT INTO `la_article` VALUES (11, 4, 1, '春卷', '这是个春卷', '50', '/image/20230406/e835893b-3f60-41f2-aaa7-a5a79104946c.jpeg', '', '', 0, 0, 1, 0, 1680764201, 1680764201, 0);
INSERT INTO `la_article` VALUES (12, 5, 1, '肘子', '大肘子大肘子', '500', '/image/20230408/27d0bc3d-05b2-42dc-a9b3-79b97d9ebda8.jpeg', '', '', 0, 0, 1, 0, 1680948098, 1680948098, 0);
INSERT INTO `la_article` VALUES (13, 5, 1, '干锅肥肠', '好吃的干锅大肥肠', '59', '/image/20230604/503d0c8d-4909-4ef1-a794-22bba366fe5c.jpeg', '', '', 0, 0, 1, 0, 1685860832, 1685860832, 0);
INSERT INTO `la_article` VALUES (14, 6, 1, '蒙古烤羊排', '香喷喷的蒙古烤羊排', '99', '/image/20230604/5d2b0a56-e661-4b59-bf21-4b81d63ac734.jpeg', '', '', 0, 0, 1, 0, 1685861420, 1685861420, 0);
INSERT INTO `la_article` VALUES (15, 5, 1, '干烧排骨', '超好吃的干烧排骨', '150', '/image/20230604/427c32bf-2838-4f65-95a6-60f1152afb98.jpeg', '', '', 0, 0, 1, 0, 1685861462, 1685861462, 0);
INSERT INTO `la_article` VALUES (16, 8, 1, '蒜香小龙虾', '蒜香小龙虾好吃的很', '210', '/image/20230604/9f862c45-0958-41e0-ac00-0d96998a6b66.jpg', '', '', 0, 0, 1, 0, 1685861508, 1685861508, 0);
INSERT INTO `la_article` VALUES (17, 8, 1, '开胃大虾', '开胃大虾，好吃不腻！', '996', '/image/20230604/af4735e4-1d0a-42bb-93e5-842c2111d3f6.jpg', '', '', 0, 0, 1, 0, 1685861555, 1685861555, 0);
INSERT INTO `la_article` VALUES (18, 7, 1, '三人套餐（三荤一素）', '三人套餐，三荤一素。实惠多多', '599', '/image/20230604/d0ff35e6-91f6-4377-bc1c-cc95509ed185.jpg', '', '', 0, 0, 1, 0, 1685861618, 1685861618, 0);
INSERT INTO `la_article` VALUES (19, 9, 1, '崂山啤酒500ml', '喝啤酒就喝崂山啤酒', '5', '/image/20230604/e589574e-cf31-41ac-a5fa-8916e08da816.jpeg', '', '', 0, 0, 1, 0, 1685861835, 1685861835, 0);
INSERT INTO `la_article` VALUES (20, 9, 1, '可口可乐300ml', '可乐清凉爽口', '3', '/image/20230604/768a00c7-8d9f-4062-b44d-f3f3b367992e.jpeg', '', '', 0, 0, 1, 0, 1685861861, 1685861861, 0);
INSERT INTO `la_article` VALUES (21, 10, 1, '河南烩面', '河南烩面', '20', '/image/20230604/94db5aba-3dd7-4573-b8c4-547dabb44c75.jpg', '', '', 0, 0, 1, 0, 1685861895, 1685861895, 0);
INSERT INTO `la_article` VALUES (22, 11, 1, '灌汤包 / 笼', '', '30', '/image/20230604/f1b6112c-7b87-43b5-8113-212a590325be.jpeg', '', '', 0, 0, 1, 0, 1685862000, 1685862000, 0);
INSERT INTO `la_article` VALUES (23, 11, 1, '河南正宗胡辣汤', '河南胡辣汤正宗的很', '19.9', '/image/20230604/08de6cc7-3ac8-41ea-9de5-18912f19c1b3.jpeg', '', '', 0, 0, 1, 0, 1685862061, 1685862061, 0);
INSERT INTO `la_article` VALUES (24, 11, 1, '卷煎', '', '60', '/image/20230604/d0bb39f6-70be-4aa1-99ad-84dd50b30f2d.jpeg', '', '', 0, 0, 1, 0, 1685862141, 1685862141, 0);
INSERT INTO `la_article` VALUES (25, 11, 1, '开封高炉烧饼 / 个', '', '2', '/image/20230604/50d62e5f-c32b-41d8-a42a-eba705973666.jpeg', '', '', 0, 0, 1, 0, 1685862195, 1685862195, 0);
INSERT INTO `la_article` VALUES (26, 10, 1, '蒸米一份', '', '5', '/image/20230604/05a6b94c-dfbf-4c46-a3a4-8f03e1ec5545.jpeg', '', '', 0, 0, 1, 0, 1685862283, 1685862289, 0);
INSERT INTO `la_article` VALUES (27, 3, 1, '凉拌金针菇', '', '10', '/image/20230604/06bbacc6-c6be-4030-ae94-a9fd72f573e3.jpeg', '', '', 0, 0, 1, 0, 1685862397, 1685862397, 0);

-- ----------------------------
-- Table structure for la_article_category
-- ----------------------------
DROP TABLE IF EXISTS `la_article_category`;
CREATE TABLE `la_article_category`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aid` int(10) NOT NULL,
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 50 COMMENT '排序',
  `is_show` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否显示: 0=否, 1=是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_article_category
-- ----------------------------
INSERT INTO `la_article_category` VALUES (1, 0, '招牌菜', 0, 1, 0, 1663317280, 1663317282, 0);
INSERT INTO `la_article_category` VALUES (2, 0, '凉菜', 0, 1, 0, 1663321464, 1680081545, 0);
INSERT INTO `la_article_category` VALUES (3, 1, '精品凉菜', 2, 1, 0, 1680420017, 1685861256, 0);
INSERT INTO `la_article_category` VALUES (4, 1, '热菜', 5, 1, 0, 1680420022, 1685861263, 0);
INSERT INTO `la_article_category` VALUES (5, 1, '肉菜', 3, 1, 0, 1680420026, 1685861243, 0);
INSERT INTO `la_article_category` VALUES (6, 1, '烧烤系列', 9, 1, 0, 1680420032, 1685861231, 0);
INSERT INTO `la_article_category` VALUES (7, 1, '多人优惠套餐', 10, 1, 0, 1685860873, 1685861162, 0);
INSERT INTO `la_article_category` VALUES (8, 1, '海鲜系列', 4, 1, 0, 1685860897, 1685861225, 0);
INSERT INTO `la_article_category` VALUES (9, 1, '饮品', 0, 1, 0, 1685860907, 1685860907, 0);
INSERT INTO `la_article_category` VALUES (10, 1, '主食', 0, 1, 0, 1685860913, 1685860913, 0);
INSERT INTO `la_article_category` VALUES (11, 1, '河南名吃', 7, 1, 0, 1685861665, 1685861665, 0);

-- ----------------------------
-- Table structure for la_article_collect
-- ----------------------------
DROP TABLE IF EXISTS `la_article_collect`;
CREATE TABLE `la_article_collect`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `article_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文章ID',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_article_collect
-- ----------------------------

-- ----------------------------
-- Table structure for la_crontab
-- ----------------------------
DROP TABLE IF EXISTS `la_crontab`;
CREATE TABLE `la_crontab`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `types` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务分组',
  `command` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务命令',
  `rules` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务贵州',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注信息',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 2 COMMENT '执行状态: 1=正在运行, 2=任务停止, 3=发生错误',
  `strategy` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '执行策略: 1=立即执行, 2=执行一次, 3=放弃执行',
  `concurrent` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '并发执行: 0=否, 1=是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `start_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始时间',
  `end_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  `task_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务耗时',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '计划任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_crontab
-- ----------------------------
INSERT INTO `la_crontab` VALUES (1, '有参数任务', 'default', 'myJob.handle(\"参数\")', '* * * * * ?', '', '', 2, 1, 0, 0, 1670377612, 1670377612, 0, 1669970830, 1670289651, 0);

-- ----------------------------
-- Table structure for la_decorate_page
-- ----------------------------
DROP TABLE IF EXISTS `la_decorate_page`;
CREATE TABLE `la_decorate_page`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `page_type` tinyint(2) UNSIGNED NOT NULL DEFAULT 10 COMMENT '页面类型',
  `page_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '页面名称',
  `page_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '页面数据',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '页面装修表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_decorate_page
-- ----------------------------
INSERT INTO `la_decorate_page` VALUES (1, 1, '商城首页', '[{\"title\":\"搜索\",\"name\":\"search\",\"disabled\":1,\"content\":{},\"styles\":{}},{\"title\":\"首页轮播图\",\"name\":\"banner\",\"content\":{\"enabled\":1,\"data\":[{\"image\":\"/api/static/banner01.png\",\"name\":\"\",\"link\":{\"path\":\"/pages/index/index\",\"name\":\"商城首页\",\"type\":\"shop\"}},{\"image\":\"/api/static/banner02.png\",\"name\":\"\",\"link\":{}}]},\"styles\":{}},{\"title\":\"导航菜单\",\"name\":\"nav\",\"content\":{\"enabled\":1,\"data\":[{\"image\":\"/api/static/nav01.png\",\"name\":\"资讯中心\",\"link\":{\"path\":\"/pages/news/news\",\"name\":\"文章资讯\",\"type\":\"shop\"}},{\"image\":\"/api/static/nav02.png\",\"name\":\"我的收藏\",\"link\":{\"path\":\"/pages/collection/collection\",\"name\":\"我的收藏\",\"type\":\"shop\"}},{\"image\":\"/api/static/nav03.png\",\"name\":\"个人设置\",\"link\":{\"path\":\"/pages/user_set/user_set\",\"name\":\"个人设置\",\"type\":\"shop\"}},{\"image\":\"/api/static/nav04.png\",\"name\":\"联系客服\",\"link\":{\"path\":\"/pages/customer_service/customer_service\",\"name\":\"联系客服\",\"type\":\"shop\"}},{\"image\":\"/api/static/nav05.png\",\"name\":\"关于我们\",\"link\":{\"path\":\"/pages/as_us/as_us\",\"name\":\"关于我们\",\"type\":\"shop\"}}]},\"styles\":{}},{\"id\":\"l84almsk2uhyf\",\"title\":\"资讯\",\"name\":\"news\",\"disabled\":1,\"content\":{},\"styles\":{}}]', 1661757188, 1663321380);
INSERT INTO `la_decorate_page` VALUES (2, 2, '个人中心', '[{\"title\":\"用户信息\",\"name\":\"user-info\",\"disabled\":1,\"content\":{},\"styles\":{}},{\"title\":\"我的服务\",\"name\":\"my-service\",\"content\":{\"style\":2,\"title\":\"服务中心\",\"data\":[{\"image\":\"/api/static/user_collect.png\",\"name\":\"我的收藏\",\"link\":{\"path\":\"/pages/collection/collection\",\"name\":\"我的收藏\",\"type\":\"shop\"}},{\"image\":\"/api/static/user_setting.png\",\"name\":\"个人设置\",\"link\":{\"path\":\"/pages/user_set/user_set\",\"name\":\"个人设置\",\"type\":\"shop\"}},{\"image\":\"/api/static/user_kefu.png\",\"name\":\"联系客服\",\"link\":{\"path\":\"/pages/customer_service/customer_service\",\"name\":\"联系客服\",\"type\":\"shop\"}}]},\"styles\":{}},{\"title\":\"个人中心广告图\",\"name\":\"user-banner\",\"content\":{\"enabled\":1,\"data\":[{\"image\":\"/api/static/ad01.jpg\",\"name\":\"\",\"link\":{}}]},\"styles\":{}}]', 1661757188, 1663320728);
INSERT INTO `la_decorate_page` VALUES (3, 3, '客服设置', '[{\"title\":\"客服设置\",\"name\":\"customer-service\",\"content\":{\"title\":\"添加客服二维码\",\"time\":\"早上 9:00 - 22:00\",\"mobile\":\"13800138000\",\"qrcode\":\"\"},\"styles\":{}}]', 1661757188, 1662689155);
INSERT INTO `la_decorate_page` VALUES (4, 4, 'PC首页装修', '[{\"id\":\"lajcn8d0hzhed\",\"title\":\"首页轮播图\",\"name\":\"banner\",\"content\":{\"enabled\":1,\"data\":[{\"image\":\"/api/static/banner01.png\",\"name\":\"\",\"link\":{}}]},\"styles\":{\"position\":\"absolute\",\"left\":\"42px\",\"top\":\"27px\",\"width\":\"234px\",\"height\":\"114px\"}}]', 1662689155, 1673251983);

-- ----------------------------
-- Table structure for la_decorate_tabbar
-- ----------------------------
DROP TABLE IF EXISTS `la_decorate_tabbar`;
CREATE TABLE `la_decorate_tabbar`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '导航名称',
  `selected` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '未选图标',
  `unselected` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '已选图标',
  `link` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '链接地址',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '底部装修表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_decorate_tabbar
-- ----------------------------
INSERT INTO `la_decorate_tabbar` VALUES (13, '首页', '/api/static/tabbar_home_sel.png', '/api/static/tabbar_home.png', '{\"path\":\"/pages/index/index\",\"name\":\"商城首页\",\"type\":\"shop\"}', 1662688157, 1662688157);
INSERT INTO `la_decorate_tabbar` VALUES (14, '资讯', '/api/static/tabbar_text_sel.png', '/api/static/tabbar_text.png', '{\"path\":\"/pages/news/news\",\"name\":\"文章资讯\",\"type\":\"shop\"}', 1662688157, 1662688157);
INSERT INTO `la_decorate_tabbar` VALUES (15, '我的', '/api/static/tabbar_me_sel.png', '/api/static/tabbar_me.png', '{\"path\":\"/pages/user/user\",\"name\":\"个人中心\",\"type\":\"shop\"}', 1662688157, 1662688157);

-- ----------------------------
-- Table structure for la_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `la_dict_data`;
CREATE TABLE `la_dict_data`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '类型',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '键名',
  `value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数值',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '备注',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NOT NULL COMMENT '状态: 0=停用, 1=正常',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_dict_data
-- ----------------------------

-- ----------------------------
-- Table structure for la_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `la_dict_type`;
CREATE TABLE `la_dict_type`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字典类型',
  `dict_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字典备注',
  `dict_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '字典状态: 0=停用, 1=正常',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_dict_type
-- ----------------------------

-- ----------------------------
-- Table structure for la_gen_table
-- ----------------------------
DROP TABLE IF EXISTS `la_gen_table`;
CREATE TABLE `la_gen_table`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联表名称',
  `sub_table_fk` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联表外键',
  `sub_table_fr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联表主键',
  `author_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '作者的名称',
  `entity_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '实体的名称',
  `module_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '生成模块名',
  `function_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '生成功能名',
  `tree_primary` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '树主键字段',
  `tree_parent` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '树父级字段',
  `tree_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '树显示字段',
  `gen_tpl` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'crud' COMMENT '生成模板方式: [crud=单表, tree=树表]',
  `gen_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '生成代码方式: [0=zip压缩包, 1=自定义路径]',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '/' COMMENT '生成代码路径: [不填默认项目路径]',
  `menu_status` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单状态: [1=自动构建, 2=手动添加]',
  `menu_pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单父级',
  `menu_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单名称',
  `remarks` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注信息',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_gen_table
-- ----------------------------
INSERT INTO `la_gen_table` VALUES (1, 'la_orders', '', '', '', '', '', 'Orders', 'orders', '', '', '', '', 'crud', 0, '/', 0, 0, '', '', 1681629852, 1681629852);

-- ----------------------------
-- Table structure for la_gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `la_gen_table_column`;
CREATE TABLE `la_gen_table_column`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '列主键',
  `table_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '表外键',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '列名称',
  `column_comment` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '列描述',
  `column_length` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '列长度',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '列类型 ',
  `java_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'JAVA类型',
  `java_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'JAVA字段',
  `is_pk` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否主键: [1=是, 0=否]',
  `is_increment` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否自增: [1=是, 0=否]',
  `is_required` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否必填: [1=是, 0=否]',
  `is_insert` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否插入字段: [1=是, 0=否]',
  `is_edit` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否编辑字段: [1=是, 0=否]',
  `is_list` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否列表字段: [1=是, 0=否]',
  `is_query` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否查询字段: [1=是, 0=否]',
  `query_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'EQ' COMMENT '查询方式: [等于、不等于、大于、小于、范围]',
  `html_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '显示类型: [文本框、文本域、下拉框、复选框、单选框、日期控件]',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字典类型',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序编号',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成字段表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_gen_table_column
-- ----------------------------
INSERT INTO `la_gen_table_column` VALUES (1, 1, 'id', '主键', '10', 'int(10)', 'Integer', 'id', 1, 1, 1, 0, 1, 0, 0, '=', 'input', '', 1, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (2, 1, 'number', '订单号', '100', 'varchar(100)', 'String', 'number', 0, 0, 1, 1, 1, 1, 1, '=', 'input', '', 2, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (3, 1, 'desk_id', '', '10', 'int(10)', 'Integer', 'deskId', 0, 0, 1, 1, 1, 1, 1, '=', 'input', '', 3, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (4, 1, 'user_id', '', '10', 'int(10)', 'Integer', 'userId', 0, 0, 1, 1, 1, 1, 1, '=', 'input', '', 4, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (5, 1, 'type', '订单类型 0:后台点单1:扫码点单', '1', 'tinyint(1)', 'Integer', 'type', 0, 0, 1, 1, 1, 1, 1, '=', 'select', '', 5, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (6, 1, 'status', '订单状态0:待下单1:待结帐2:已完成', '1', 'tinyint(1)', 'Integer', 'status', 0, 0, 1, 1, 1, 1, 1, '=', 'radio', '', 6, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (7, 1, 'remark', '', '255', 'varchar(255)', 'String', 'remark', 0, 0, 1, 1, 1, 1, 1, '=', 'input', '', 7, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (8, 1, 'amount', '', '255', 'varchar(255)', 'String', 'amount', 0, 0, 1, 1, 1, 1, 1, '=', 'input', '', 8, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (9, 1, 'create_time', '', '10', 'int(10)', 'Long', 'createTime', 0, 0, 0, 0, 0, 1, 0, '=', 'datetime', '', 9, 1681629852, 1681629852);
INSERT INTO `la_gen_table_column` VALUES (10, 1, 'checkout_time', '结账时间', '10', 'int(10)', 'Integer', 'checkoutTime', 0, 0, 1, 1, 1, 1, 1, '=', 'input', '', 10, 1681629852, 1681629852);

-- ----------------------------
-- Table structure for la_hot_search
-- ----------------------------
DROP TABLE IF EXISTS `la_hot_search`;
CREATE TABLE `la_hot_search`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '热门搜索配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_hot_search
-- ----------------------------

-- ----------------------------
-- Table structure for la_notice_setting
-- ----------------------------
DROP TABLE IF EXISTS `la_notice_setting`;
CREATE TABLE `la_notice_setting`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `scene` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '场景编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '场景名称',
  `remarks` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '场景描述',
  `recipient` tinyint(1) NOT NULL DEFAULT 1 COMMENT '接收人员: [1=用户, 2=平台]',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '通知类型: [1=业务, 2=验证]',
  `system_notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '系统的通知设置',
  `sms_notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '短信的通知设置',
  `oa_notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '公众号通知设置',
  `mnp_notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '小程序通知设置',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息通知设置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_notice_setting
-- ----------------------------
INSERT INTO `la_notice_setting` VALUES (1, 101, '登录验证码', '用户手机号码登录时发送', 1, 2, '{}', '{\"type\":\"sms\",\"templateId\":\"SMS_222458159\",\"content\":\"您正在登录，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"tips\":[\"可选变量 验证码:code\",\"示例：您正在登录，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"生效条件：1、管理后台完成短信设置。2、第三方短信平台申请模板。\"],\"status\":\"1\"}', '{}', '{}', 0, 1648696695, 1648696695, 0);
INSERT INTO `la_notice_setting` VALUES (2, 102, '绑定手机验证码', '用户绑定手机号码时发送', 1, 2, '{}', '{\"type\":\"sms\",\"templateId\":\"SMS_175615069\",\"content\":\"您正在绑定手机号，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"tips\":[\"可选变量 验证码:code\",\"示例：您正在绑定手机号，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"生效条件：1、管理后台完成短信设置。2、第三方短信平台申请模板。\"],\"status\":\"1\"}', '{}', '{}', 0, 1648696695, 1648696695, 0);
INSERT INTO `la_notice_setting` VALUES (3, 103, '变更手机验证码', '用户变更手机号码时发送', 1, 2, '{}', '{\"type\":\"sms\",\"templateId\":\"SMS_207952628\",\"content\":\"您正在变更手机号，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"tips\":[\"可选变量 验证码:code\",\"示例：您正在变更手机号，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"生效条件：1、管理后台完成短信设置。2、第三方短信平台申请模板。\"],\"status\":\"1\"}', '{}', '{}', 0, 1648696695, 1648696695, 0);
INSERT INTO `la_notice_setting` VALUES (4, 104, '找回登录密码验证码', '用户找回登录密码号码时发送', 1, 2, '{}', '{\"type\":\"sms\",\"templateId\":\"SMS_175615069\",\"content\":\"您正在找回登录密码，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"tips\":[\"可选变量 验证码:code\",\"示例：您正在找回登录密码，验证码${code}，切勿将验证码泄露于他人，本条验证码有效期5分钟。\",\"条验证码有效期5分钟。\"],\"status\":\"1\"}', '{}', '{}', 0, 1648696695, 1648696695, 0);

-- ----------------------------
-- Table structure for la_official_reply
-- ----------------------------
DROP TABLE IF EXISTS `la_official_reply`;
CREATE TABLE `la_official_reply`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规则名',
  `keyword` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `reply_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '回复类型: [1=关注回复 2=关键字回复, 3=默认回复]',
  `matching_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '匹配方式: [1=全匹配, 2=模糊匹配]',
  `content_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '内容类型: [1=文本]',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '启动状态: [1=启动, 0=关闭]',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '回复内容',
  `sort` int(11) UNSIGNED NOT NULL DEFAULT 50 COMMENT '排序编号',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公众号的回复表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_official_reply
-- ----------------------------

-- ----------------------------
-- Table structure for la_orders
-- ----------------------------
DROP TABLE IF EXISTS `la_orders`;
CREATE TABLE `la_orders`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aid` int(10) NOT NULL COMMENT '管理员id',
  `number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `desk_id` int(10) NOT NULL,
  `user_num` int(10) NOT NULL,
  `type` tinyint(1) NOT NULL COMMENT '订单类型 0:后台点单1:扫码点单',
  `status` tinyint(1) NOT NULL COMMENT '订单状态0:待下单1:待结帐2:已完成',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `amount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` int(10) NOT NULL,
  `checkout_time` int(10) NOT NULL DEFAULT 0 COMMENT '结账时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of la_orders
-- ----------------------------
INSERT INTO `la_orders` VALUES (18, 1, '464408fe-5ac0-4039-948f-16547031df37', 10, 3, 1, 2, '要辣', '50.00', 1684825519, 1684915476);
INSERT INTO `la_orders` VALUES (17, 1, '46f67d83-26e3-4f93-af0b-5a73b45b0307', 4, 3, 1, 2, '二次', '242.00', 1684823773, 1684915476);
INSERT INTO `la_orders` VALUES (3, 1, '8ec512fa-5100-4786-bd3f-596d07bdadcb', 4, 6, 0, 2, '', '1242.00', 1682417414, 1684653598);
INSERT INTO `la_orders` VALUES (4, 1, 'f6940b39-3e19-4414-ab55-a6a4ec541ebe', 7, 2, 0, 2, '', '999.00', 1682578166, 1684653924);
INSERT INTO `la_orders` VALUES (5, 1, 'ec8fe55b-cf8e-4140-b849-3da77dc239f8', 5, 7, 0, 2, '', '1200.00', 1682583634, 1684654060);
INSERT INTO `la_orders` VALUES (6, 1, '40567d14-ba80-4b0e-8836-4b065d3df61c', 12, 1, 0, 2, NULL, '100.00', 1684654164, 1684654621);
INSERT INTO `la_orders` VALUES (7, 1, '297f710f-ef13-4961-bf72-da8f99186219', 11, 1, 0, 2, NULL, '100.00', 1684654234, 1684654624);
INSERT INTO `la_orders` VALUES (8, 1, 'd9563b0c-a6a4-4951-986c-1edf5f4b95c5', 10, 3, 0, 2, NULL, '100.00', 1684654273, 1684654627);
INSERT INTO `la_orders` VALUES (9, 1, 'effb9f12-2f34-43c8-98d4-65fe58bcd9ab', 13, 6, 0, 2, '', '600.00', 1684654588, 1684654664);
INSERT INTO `la_orders` VALUES (10, 1, '0540f29f-2747-429e-8859-19c8e5c17ca7', 5, 7, 1, 2, '111', '1687.00', 1684671235, 1684915476);
INSERT INTO `la_orders` VALUES (11, 1, '3bfdb835-3572-4f60-b6d0-8918affc4f2c', 19, 2, 1, 2, NULL, NULL, 1684744156, 1684914282);
INSERT INTO `la_orders` VALUES (12, 1, '89fb99d1-8ebe-4a1f-8186-cadcc4b986ed', 18, 1, 1, 2, NULL, NULL, 1684745288, 1684914279);
INSERT INTO `la_orders` VALUES (13, 1, '11886deb-7118-4135-bdbf-3066aeaebdb7', 17, 4, 1, 2, NULL, NULL, 1684758809, 1684914276);
INSERT INTO `la_orders` VALUES (14, 1, '94ec1546-7116-408e-9f78-ce2cd722131e', 4, 1, 1, 2, '123123', '1687.00', 1684822096, 1684915476);
INSERT INTO `la_orders` VALUES (15, 1, 'b866c895-603c-4a72-8245-b1f069ca0a9a', 7, 2, 1, 2, '333', '999.00', 1684823326, 1684915476);
INSERT INTO `la_orders` VALUES (16, 1, '7c1b80fa-f209-4486-8c69-ca747f8ebd42', 10, 2, 1, 2, '不要辣', '1707.00', 1684823436, 1684915476);
INSERT INTO `la_orders` VALUES (19, 1, 'ebeeebe1-e82c-4b6d-a682-01f6ebb6e145', 4, 1, 1, 2, NULL, NULL, 1684904292, 1684914272);
INSERT INTO `la_orders` VALUES (20, 1, '3472a475-d74b-4c71-8fbd-67ead52bcaee', 10, 2, 1, 2, '555', '1687.00', 1684904487, 1684915476);
INSERT INTO `la_orders` VALUES (21, 1, '588a5dcf-59a8-4684-9f8c-c4481b4035ca', 10, 2, 1, 2, '555', '1221.00', 1684904707, 1684915476);
INSERT INTO `la_orders` VALUES (22, 1, '2a2719bf-b879-49c0-bed1-831109286326', 10, 1, 1, 2, '5555', '910.00', 1684904908, 1684915476);
INSERT INTO `la_orders` VALUES (23, 1, 'cb3616ec-20b1-45c1-addc-8c99954a735f', 10, 1, 1, 2, '', '100.00', 1684904944, 1684915476);
INSERT INTO `la_orders` VALUES (24, 1, '34bcf734-ca43-4315-adaa-a34a91d1d4ef', 10, 2, 1, 2, '', '100.00', 1684906460, 1684915476);
INSERT INTO `la_orders` VALUES (25, 1, '699ab08f-9302-497b-82a3-1f6cb32289d6', 10, 1, 1, 2, '', '100.00', 1684906615, 1684915476);
INSERT INTO `la_orders` VALUES (26, 1, '318074ab-93b2-4e88-995b-03878cb960bf', 11, 2, 1, 2, '', '222.00', 1684906658, 1684915476);
INSERT INTO `la_orders` VALUES (27, 1, '193c9dc6-8ede-468e-9781-69655cdffebc', 11, 2, 1, 2, '', '100.00', 1684906683, 1684915476);
INSERT INTO `la_orders` VALUES (28, 1, '8362b5e4-076a-4196-ac9b-6c6ca3a7d576', 11, 1, 1, 2, '', '999.00', 1684907558, 1684915476);
INSERT INTO `la_orders` VALUES (29, 1, 'd65d3788-1a0d-4850-9700-8e1e37c9c1d9', 11, 2, 1, 2, '', '688.00', 1684907619, 1684915476);
INSERT INTO `la_orders` VALUES (30, 1, '6f6ab4ed-3e45-4f86-a6e0-ab24fbf25eb6', 11, 1, 1, 2, '', '222.00', 1684907640, 1684915476);
INSERT INTO `la_orders` VALUES (31, 1, 'b8688e60-49b1-4141-9f1f-11a8982e7b8c', 11, 2, 1, 2, '', '60.00', 1684907685, 1684915476);
INSERT INTO `la_orders` VALUES (32, 1, 'a24c97ad-3581-49b5-828e-4c21156983db', 11, 2, 1, 2, '不要辣', '2009.00', 1684909795, 1684915476);
INSERT INTO `la_orders` VALUES (33, 1, 'ee44557c-d1ac-4d0e-aa6b-c6a63fd0e15b', 11, 2, 1, 2, '', '100.00', 1684909878, 1684915476);
INSERT INTO `la_orders` VALUES (34, 1, '428a2a70-128b-4282-ac3c-80ad1a886e61', 11, 2, 1, 2, '', '100.00', 1684914385, 1684915476);
INSERT INTO `la_orders` VALUES (35, 1, '2fadfa5b-4393-4749-83a3-fdfa4c328ff8', 10, 2, 1, 2, '', '910.00', 1684914391, 1684915479);
INSERT INTO `la_orders` VALUES (36, 1, 'a7fcf211-b82f-44eb-b2fa-4296e37b3079', 4, 3, 1, 2, '', '100.00', 1684927275, 1684932548);
INSERT INTO `la_orders` VALUES (37, 1, 'fb312adc-5cb0-4a72-a478-a15aa6e9e602', 10, 3, 1, 2, '', '1099.00', 1684927531, 1684932551);
INSERT INTO `la_orders` VALUES (38, 1, '4e80e824-6230-4bc9-93b6-df52248b7969', 4, 3, 1, 2, '', '1687.00', 1684932571, 1685607906);
INSERT INTO `la_orders` VALUES (39, 1, '8265dab8-5fd4-4750-8bcf-6961091ff232', 4, 4, 1, 2, '', '688.00', 1684935354, 1685607906);
INSERT INTO `la_orders` VALUES (40, 1, 'f8ee025b-e375-44f3-a10d-e5556a567a35', 13, 5, 1, 2, '666', '708.00', 1685179267, 1685607908);
INSERT INTO `la_orders` VALUES (41, 1, '3010608e-328d-4b1e-af2b-52ed24787655', 13, 5, 1, 2, 'niubi', '1887.00', 1685179339, 1685607908);
INSERT INTO `la_orders` VALUES (42, 1, '07c708ef-8742-4db9-bdb2-268318faff5c', 18, 4, 1, 2, '111', '1787.00', 1685513336, 1685607903);
INSERT INTO `la_orders` VALUES (43, 1, 'ee502f5b-89a8-4e04-b822-5078663879a5', 19, 2, 1, 2, '', '12215.00', 1685607941, 1685949045);
INSERT INTO `la_orders` VALUES (44, 1, '0afa084c-b9c9-4ba9-ab83-6e4df0c4cc88', 16, 3, 0, 2, '', '1038.00', 1685860441, 1685948973);
INSERT INTO `la_orders` VALUES (45, 1, '064afc90-ac33-49f6-8863-0ca7c4b290ce', 31, 2, 1, 2, '', '1220.00', 1685863915, 1685949098);
INSERT INTO `la_orders` VALUES (46, 1, 'df0f988f-fb3e-4c7d-8e43-7182a99df08b', 28, 2, 0, 2, '', '1022.00', 1685944187, 1685948970);
INSERT INTO `la_orders` VALUES (47, 1, '5b4ec3c4-01ae-446d-a4f3-b413a72c4de7', 20, 2, 1, 2, '222', '610.00', 1685944296, 1685948965);
INSERT INTO `la_orders` VALUES (48, 1, '7e7b6477-776b-4d0e-8c3a-395b89bc4a35', 33, 3, 1, 2, '', '110.00', 1685949532, 1685949570);
INSERT INTO `la_orders` VALUES (49, 1, '616a3196-8f27-4654-81d6-19d22a291dfa', 33, 5, 1, 1, '', '1009.00', 1685949600, 0);
INSERT INTO `la_orders` VALUES (50, 1, '3ca03833-0ce6-43d0-9832-6fd092b36152', 11, 2, 0, 1, '', '102.00', 1685949624, 0);
INSERT INTO `la_orders` VALUES (51, 1, '966d271d-af06-458d-b7c3-b934a888f50c', 25, 3, 1, 1, '', '1697.00', 1686019754, 0);
INSERT INTO `la_orders` VALUES (52, 1, 'eb589bfb-3f1b-4e01-8110-2f31d5850014', 32, 3, 0, 0, NULL, NULL, 1686038600, 0);
INSERT INTO `la_orders` VALUES (53, 1, '86982edf-8d57-4d98-a451-846e6d614cd1', 29, 4, 1, 1, '', '110.00', 1686039002, 0);

-- ----------------------------
-- Table structure for la_orders_dish
-- ----------------------------
DROP TABLE IF EXISTS `la_orders_dish`;
CREATE TABLE `la_orders_dish`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `order_id` int(10) NOT NULL,
  `dish_id` int(10) NOT NULL,
  `quantity` int(10) NOT NULL DEFAULT 1,
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `create_time` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 155 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of la_orders_dish
-- ----------------------------
INSERT INTO `la_orders_dish` VALUES (83, 15, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (62, 18, 11, 1, 50.00, 0);
INSERT INTO `la_orders_dish` VALUES (59, 16, 10, 1, 20.00, 0);
INSERT INTO `la_orders_dish` VALUES (61, 17, 10, 1, 20.00, 0);
INSERT INTO `la_orders_dish` VALUES (60, 17, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (64, 10, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (85, 20, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (63, 10, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (86, 21, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (58, 16, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (57, 16, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (55, 14, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (56, 14, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (54, 1, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (53, 1, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (84, 20, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (87, 21, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (88, 22, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (89, 22, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (90, 23, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (92, 24, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (93, 25, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (94, 26, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (95, 27, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (96, 28, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (97, 29, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (98, 30, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (99, 31, 10, 3, 20.00, 0);
INSERT INTO `la_orders_dish` VALUES (100, 32, 6, 1, 999.00, 0);
INSERT INTO `la_orders_dish` VALUES (101, 32, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (102, 32, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (103, 32, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (104, 33, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (105, 34, 7, 1, 100.00, 0);
INSERT INTO `la_orders_dish` VALUES (106, 35, 8, 1, 688.00, 0);
INSERT INTO `la_orders_dish` VALUES (107, 35, 9, 1, 222.00, 0);
INSERT INTO `la_orders_dish` VALUES (108, 36, 7, 1, 100.00, 1684927508);
INSERT INTO `la_orders_dish` VALUES (109, 37, 6, 1, 999.00, 1684927543);
INSERT INTO `la_orders_dish` VALUES (110, 37, 7, 1, 100.00, 1684927544);
INSERT INTO `la_orders_dish` VALUES (111, 38, 6, 1, 999.00, 1684932578);
INSERT INTO `la_orders_dish` VALUES (112, 38, 8, 1, 688.00, 1684932579);
INSERT INTO `la_orders_dish` VALUES (113, 39, 8, 1, 688.00, 1684935356);
INSERT INTO `la_orders_dish` VALUES (114, 40, 8, 1, 688.00, 1685179272);
INSERT INTO `la_orders_dish` VALUES (115, 40, 10, 1, 20.00, 1685179274);
INSERT INTO `la_orders_dish` VALUES (116, 41, 7, 2, 100.00, 1685179343);
INSERT INTO `la_orders_dish` VALUES (117, 41, 6, 1, 999.00, 1685179352);
INSERT INTO `la_orders_dish` VALUES (118, 41, 8, 1, 688.00, 1685179355);
INSERT INTO `la_orders_dish` VALUES (119, 42, 7, 1, 100.00, 1685513355);
INSERT INTO `la_orders_dish` VALUES (120, 42, 6, 1, 999.00, 1685513358);
INSERT INTO `la_orders_dish` VALUES (121, 42, 8, 1, 688.00, 1685513360);
INSERT INTO `la_orders_dish` VALUES (126, 43, 9, 1, 222.00, 1685607954);
INSERT INTO `la_orders_dish` VALUES (127, 44, 5, 1, 666.00, 1685860446);
INSERT INTO `la_orders_dish` VALUES (125, 43, 6, 1, 999.00, 1685607952);
INSERT INTO `la_orders_dish` VALUES (128, 44, 9, 1, 222.00, 1685860449);
INSERT INTO `la_orders_dish` VALUES (129, 44, 11, 3, 50.00, 1685860450);
INSERT INTO `la_orders_dish` VALUES (130, 45, 25, 1, 2.00, 1685863963);
INSERT INTO `la_orders_dish` VALUES (131, 45, 24, 1, 60.00, 1685863965);
INSERT INTO `la_orders_dish` VALUES (132, 45, 7, 1, 100.00, 1685863984);
INSERT INTO `la_orders_dish` VALUES (133, 46, 6, 1, 999.00, 1685944208);
INSERT INTO `la_orders_dish` VALUES (135, 46, 20, 1, 3.00, 1685944220);
INSERT INTO `la_orders_dish` VALUES (136, 46, 21, 1, 20.00, 1685944226);
INSERT INTO `la_orders_dish` VALUES (137, 47, 12, 1, 500.00, 1685944302);
INSERT INTO `la_orders_dish` VALUES (138, 47, 7, 1, 100.00, 1685944320);
INSERT INTO `la_orders_dish` VALUES (139, 47, 27, 1, 10.00, 1685944323);
INSERT INTO `la_orders_dish` VALUES (140, 45, 6, 1, 999.00, 1685949003);
INSERT INTO `la_orders_dish` VALUES (141, 45, 13, 1, 59.00, 1685949004);
INSERT INTO `la_orders_dish` VALUES (142, 43, 26, 1, 5.00, 1685949018);
INSERT INTO `la_orders_dish` VALUES (143, 43, 6, 11, 999.00, 1685949022);
INSERT INTO `la_orders_dish` VALUES (144, 48, 7, 1, 100.00, 1685949534);
INSERT INTO `la_orders_dish` VALUES (145, 48, 27, 1, 10.00, 1685949534);
INSERT INTO `la_orders_dish` VALUES (146, 49, 27, 1, 10.00, 1685949602);
INSERT INTO `la_orders_dish` VALUES (147, 49, 6, 1, 999.00, 1685949603);
INSERT INTO `la_orders_dish` VALUES (148, 50, 20, 1, 3.00, 1685949627);
INSERT INTO `la_orders_dish` VALUES (149, 50, 14, 1, 99.00, 1685949629);
INSERT INTO `la_orders_dish` VALUES (150, 51, 27, 1, 10.00, 1686019757);
INSERT INTO `la_orders_dish` VALUES (151, 51, 8, 1, 688.00, 1686019759);
INSERT INTO `la_orders_dish` VALUES (152, 51, 6, 1, 999.00, 1686019762);
INSERT INTO `la_orders_dish` VALUES (153, 53, 27, 1, 10.00, 1686039036);
INSERT INTO `la_orders_dish` VALUES (154, 53, 7, 1, 100.00, 1686039040);

-- ----------------------------
-- Table structure for la_printer
-- ----------------------------
DROP TABLE IF EXISTS `la_printer`;
CREATE TABLE `la_printer`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aid` int(10) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '设备类型',
  `final_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `secret` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `mode` tinyint(1) NOT NULL DEFAULT 1 COMMENT '小票模板',
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `is_delete` tinyint(1) NOT NULL DEFAULT 0,
  `create_time` int(10) NOT NULL,
  `delete_time` int(10) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of la_printer
-- ----------------------------
INSERT INTO `la_printer` VALUES (1, 1, '前台', 1, '123456', 'abcd', 1, 1, 0, 1684492918, NULL);
INSERT INTO `la_printer` VALUES (2, 1, '后厨', 1, '147258', 'abcd', 1, 1, 0, 1684493599, NULL);
INSERT INTO `la_printer` VALUES (3, 1, '测试', 1, '123456', '123456', 1, 1, 0, 1685940259, NULL);

-- ----------------------------
-- Table structure for la_shop_config
-- ----------------------------
DROP TABLE IF EXISTS `la_shop_config`;
CREATE TABLE `la_shop_config`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aid` int(10) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '店铺名称',
  `intro` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '店铺简介',
  `notice` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '店铺图片',
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `pre_pay` tinyint(1) NOT NULL DEFAULT 0 COMMENT '预支付',
  `create_time` int(10) NULL DEFAULT NULL,
  `update_time` int(10) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `aid`(`aid`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of la_shop_config
-- ----------------------------
INSERT INTO `la_shop_config` VALUES (1, 1, '南街麻辣烫', '这是南街麻辣烫的介绍', '这是南街麻辣烫的公告', 'http://qiniu.52yhqw.top/image/20230515/e757b7d5-e4c1-42e0-aad0-9b7ae82e0a9e.png', 1, 0, 1684484058, 1685940269);

-- ----------------------------
-- Table structure for la_system_auth_admin
-- ----------------------------
DROP TABLE IF EXISTS `la_system_auth_admin`;
CREATE TABLE `la_system_auth_admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_ids` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色主键',
  `dept_ids` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '部门ID',
  `post_ids` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '岗位ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户账号',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户密码',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户头像',
  `salt` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '加密盐巴',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序编号',
  `is_multipoint` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '多端登录: 0=否, 1=是',
  `is_disable` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否禁用: 0=否, 1=是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `last_login_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `last_login_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登录',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统管理成员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_auth_admin
-- ----------------------------
INSERT INTO `la_system_auth_admin` VALUES (1, '0', '1', '', 'admin', 'admin', '4919832b10f1d2133c0f24a7dbe8330e', '/image/20230528/0610fcf3-d20d-4070-86cd-9732c2da4ee3.gif', 'Huku0', 0, 1, 0, 0, '127.0.0.1', 1686038510, 1642321599, 1685255873, 0);
INSERT INTO `la_system_auth_admin` VALUES (2, '2', '', '', 'ceshi', '测试号', '016a4661a3bfcda88f264b5e2e1a933c', '/image/20230515/e757b7d5-e4c1-42e0-aad0-9b7ae82e0a9e.png', 'KcHJ4', 0, 1, 0, 0, '127.0.0.1', 1680340640, 1678324916, 1685255697, 0);
INSERT INTO `la_system_auth_admin` VALUES (3, '2', '', '', '123', '张亮麻辣烫', '7c78878aefe95991bb7e661f29a45995', '/api/static/backend_avatar.png', 'xG79h', 0, 1, 0, 0, '127.0.0.1', 1686016023, 1685255767, 1685255767, 0);

-- ----------------------------
-- Table structure for la_system_auth_dept
-- ----------------------------
DROP TABLE IF EXISTS `la_system_auth_dept`;
CREATE TABLE `la_system_auth_dept`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aid` int(10) NOT NULL,
  `area_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '部门名称',
  `num` int(10) NOT NULL DEFAULT 1 COMMENT '餐桌最大承载人数',
  `status` tinyint(1) NOT NULL DEFAULT 2 COMMENT '餐桌状态',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序编号',
  `is_stop` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否禁用: 0=否, 1=是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统部门管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_auth_dept
-- ----------------------------
INSERT INTO `la_system_auth_dept` VALUES (1, 0, 0, '默认部门', 1, 2, 10, 0, 0, 1649841995, 1660190949, 0);
INSERT INTO `la_system_auth_dept` VALUES (2, 0, 1, '二级部门', 1, 2, 0, 1, 1, 1679404060, 1680175300, 0);
INSERT INTO `la_system_auth_dept` VALUES (3, 1, 0, '01', 8, 2, 0, 0, 0, 1680444849, 1680444849, 0);
INSERT INTO `la_system_auth_dept` VALUES (4, 1, 2, '2号桌', 8, 2, 0, 0, 0, 1680522276, 1680768746, 0);
INSERT INTO `la_system_auth_dept` VALUES (5, 1, 1, '1号桌', 10, 2, 0, 0, 0, 1680522907, 1680768674, 0);
INSERT INTO `la_system_auth_dept` VALUES (6, 1, 3, '3号桌', 8, 2, 0, 0, 0, 1680523053, 1680523053, 0);
INSERT INTO `la_system_auth_dept` VALUES (7, 1, 2, '4号桌', 2, 2, 0, 0, 0, 1680596101, 1680768713, 0);
INSERT INTO `la_system_auth_dept` VALUES (8, 1, 3, '5号桌', 8, 2, 0, 0, 0, 1680768494, 1680768726, 0);
INSERT INTO `la_system_auth_dept` VALUES (9, 1, 2, '6号桌', 4, 2, 0, 0, 0, 1680768754, 1680768754, 0);
INSERT INTO `la_system_auth_dept` VALUES (10, 1, 2, '7号桌', 4, 2, 0, 0, 0, 1680768764, 1680768764, 0);
INSERT INTO `la_system_auth_dept` VALUES (11, 1, 4, '8号桌', 2, 2, 0, 0, 0, 1680768811, 1680768811, 0);
INSERT INTO `la_system_auth_dept` VALUES (12, 1, 4, '9号桌', 2, 2, 0, 0, 0, 1680768823, 1680768823, 0);
INSERT INTO `la_system_auth_dept` VALUES (13, 1, 3, '101', 8, 2, 0, 0, 0, 1680769074, 1680769074, 0);
INSERT INTO `la_system_auth_dept` VALUES (14, 1, 3, '102', 8, 2, 0, 0, 0, 1680769079, 1680769079, 0);
INSERT INTO `la_system_auth_dept` VALUES (15, 1, 3, '103', 8, 2, 0, 0, 0, 1680769084, 1680769084, 0);
INSERT INTO `la_system_auth_dept` VALUES (16, 1, 5, '1001', 8, 2, 0, 0, 0, 1680769170, 1680769170, 0);
INSERT INTO `la_system_auth_dept` VALUES (17, 1, 5, '1002', 6, 2, 0, 0, 0, 1680769176, 1680769176, 0);
INSERT INTO `la_system_auth_dept` VALUES (18, 1, 5, '1003', 10, 2, 0, 0, 0, 1680769182, 1680769182, 0);
INSERT INTO `la_system_auth_dept` VALUES (19, 1, 4, '9001', 6, 2, 0, 0, 0, 1680790040, 1681974598, 0);
INSERT INTO `la_system_auth_dept` VALUES (20, 1, 1, '10号桌', 6, 2, 0, 0, 0, 1685862892, 1685862892, 0);
INSERT INTO `la_system_auth_dept` VALUES (21, 1, 6, '2001', 8, 2, 0, 0, 0, 1685862999, 1685863042, 0);
INSERT INTO `la_system_auth_dept` VALUES (22, 1, 6, '2002', 8, 2, 0, 0, 0, 1685863008, 1685863036, 0);
INSERT INTO `la_system_auth_dept` VALUES (23, 1, 6, '2003', 4, 2, 0, 0, 0, 1685863015, 1685863026, 0);
INSERT INTO `la_system_auth_dept` VALUES (24, 1, 6, '2004', 8, 2, 0, 0, 0, 1685863052, 1685863052, 0);
INSERT INTO `la_system_auth_dept` VALUES (25, 1, 6, '2005', 10, 2, 0, 0, 0, 1685863110, 1685863110, 0);
INSERT INTO `la_system_auth_dept` VALUES (26, 1, 6, '2006', 10, 2, 0, 0, 0, 1685863118, 1685863118, 0);
INSERT INTO `la_system_auth_dept` VALUES (27, 1, 7, '2007', 8, 2, 0, 0, 0, 1685863147, 1685863147, 0);
INSERT INTO `la_system_auth_dept` VALUES (28, 1, 7, '2008', 8, 2, 0, 0, 0, 1685863157, 1685863157, 0);
INSERT INTO `la_system_auth_dept` VALUES (29, 1, 7, '2009', 8, 2, 0, 0, 0, 1685863167, 1685863167, 0);
INSERT INTO `la_system_auth_dept` VALUES (30, 1, 7, '2010', 8, 2, 0, 0, 0, 1685863193, 1685863193, 0);
INSERT INTO `la_system_auth_dept` VALUES (31, 1, 8, '111号桌', 6, 2, 0, 0, 0, 1685863279, 1685863279, 0);
INSERT INTO `la_system_auth_dept` VALUES (32, 1, 8, '222号桌', 4, 2, 0, 0, 0, 1685863291, 1685863291, 0);
INSERT INTO `la_system_auth_dept` VALUES (33, 1, 8, '333号桌', 10, 2, 0, 0, 0, 1685863305, 1685863305, 0);

-- ----------------------------
-- Table structure for la_system_auth_menu
-- ----------------------------
DROP TABLE IF EXISTS `la_system_auth_menu`;
CREATE TABLE `la_system_auth_menu`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级菜单',
  `menu_type` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限类型: M=目录，C=菜单，A=按钮',
  `menu_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单名称',
  `menu_icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单图标',
  `menu_sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单排序',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限标识',
  `paths` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '前端组件',
  `selected` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '选中路径',
  `params` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '路由参数',
  `is_cache` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否缓存: 0=否, 1=是',
  `is_show` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否显示: 0=否, 1=是',
  `is_disable` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否禁用: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 797 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统菜单管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_auth_menu
-- ----------------------------
INSERT INTO `la_system_auth_menu` VALUES (1, 0, 'C', '概况', 'local-icon-shuju_liuliang', 50, 'index:console', 'workbench', 'workbench/index', '', '', 1, 1, 0, 1650341765, 1678364773);
INSERT INTO `la_system_auth_menu` VALUES (100, 0, 'M', '权限管理', 'el-icon-Lock', 44, '', 'permission', '', '', '', 0, 1, 0, 1650341765, 1662626201);
INSERT INTO `la_system_auth_menu` VALUES (101, 100, 'C', '管理员', 'local-icon-wode', 0, 'system:admin:list', 'admin', 'permission/admin/index', '', '', 1, 1, 0, 1650341765, 1663301404);
INSERT INTO `la_system_auth_menu` VALUES (102, 101, 'A', '管理员详情', '', 0, 'system:admin:detail', '', '', '', '', 0, 1, 0, 1650341765, 1660201785);
INSERT INTO `la_system_auth_menu` VALUES (103, 101, 'A', '管理员新增', '', 0, 'system:admin:add', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (104, 101, 'A', '管理员编辑', '', 0, 'system:admin:edit', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (105, 101, 'A', '管理员删除', '', 0, 'system:admin:del', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (106, 101, 'A', '管理员状态', '', 0, 'system:admin:disable', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (110, 100, 'C', '角色管理', 'el-icon-Female', 0, 'system:role:list', 'role', 'permission/role/index', '', '', 1, 1, 0, 1650341765, 1663301451);
INSERT INTO `la_system_auth_menu` VALUES (111, 110, 'A', '角色详情', '', 0, 'system:role:detail', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (112, 110, 'A', '角色新增', '', 0, 'system:role:add', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (113, 110, 'A', '角色编辑', '', 0, 'system:role:edit', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (114, 110, 'A', '角色删除', '', 0, 'system:role:del', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (120, 100, 'C', '菜单管理', 'el-icon-Operation', 0, 'system:menu:list', 'menu', 'permission/menu/index', '', '', 1, 1, 0, 1650341765, 1663301388);
INSERT INTO `la_system_auth_menu` VALUES (121, 120, 'A', '菜单详情', '', 0, 'system:menu:detail', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (122, 120, 'A', '菜单新增', '', 0, 'system:menu:add', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (123, 120, 'A', '菜单编辑', '', 0, 'system:menu:edit', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (124, 120, 'A', '菜单删除', '', 0, 'system:menu:del', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (130, 0, 'M', '餐桌管理', 'el-icon-KnifeFork', 47, '', 'board', '', '', '', 0, 1, 0, 1650341765, 1680178075);
INSERT INTO `la_system_auth_menu` VALUES (131, 130, 'C', '桌号设置', 'el-icon-SetUp', 0, 'system:number:list', 'number', 'board/number/index', '', '', 1, 1, 0, 1650341765, 1680178231);
INSERT INTO `la_system_auth_menu` VALUES (132, 131, 'A', '部门详情', '', 0, 'system:number:detail', '', '', '', '', 0, 1, 0, 1650341765, 1680178237);
INSERT INTO `la_system_auth_menu` VALUES (133, 131, 'A', '部门新增', '', 0, 'system:number:add', '', '', '', '', 0, 1, 0, 1650341765, 1680178242);
INSERT INTO `la_system_auth_menu` VALUES (134, 131, 'A', '部门编辑', '', 0, 'system:number:edit', '', '', '', '', 0, 1, 0, 1650341765, 1680178247);
INSERT INTO `la_system_auth_menu` VALUES (135, 131, 'A', '部门删除', '', 0, 'system:number:del', '', '', '', '', 0, 1, 0, 1650341765, 1680178252);
INSERT INTO `la_system_auth_menu` VALUES (140, 130, 'C', '区域管理', 'el-icon-More', 0, 'system:area:list', 'area', 'board/area/index', '', '', 1, 1, 0, 1650341765, 1680178173);
INSERT INTO `la_system_auth_menu` VALUES (141, 140, 'A', '岗位详情', '', 0, 'system:area:detail', '', '', '', '', 0, 1, 0, 1650341765, 1680178279);
INSERT INTO `la_system_auth_menu` VALUES (142, 140, 'A', '岗位新增', '', 0, 'system:area:add', '', '', '', '', 0, 1, 0, 1650341765, 1680178291);
INSERT INTO `la_system_auth_menu` VALUES (143, 140, 'A', '岗位编辑', '', 0, 'system:area:edit', '', '', '', '', 0, 1, 0, 1650341765, 1680178296);
INSERT INTO `la_system_auth_menu` VALUES (144, 140, 'A', '岗位删除', '', 0, 'system:area:del', '', '', '', '', 0, 1, 0, 1650341765, 1680178300);
INSERT INTO `la_system_auth_menu` VALUES (200, 0, 'M', '其它管理', '', 0, '', '', '', '', '', 0, 0, 0, 1650341765, 1660636870);
INSERT INTO `la_system_auth_menu` VALUES (201, 200, 'M', '图库管理', '', 0, '', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (202, 201, 'A', '文件列表', '', 0, 'albums:albumList', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (203, 201, 'A', '文件命名', '', 0, 'albums:albumRename', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (204, 201, 'A', '文件移动', '', 0, 'albums:albumMove', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (205, 201, 'A', '文件删除', '', 0, 'albums:albumDel', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (206, 201, 'A', '分类列表', '', 0, 'albums:cateList', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (207, 201, 'A', '分类新增', '', 0, 'albums:cateAdd', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (208, 201, 'A', '分类命名', '', 0, 'albums:cateRename', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (209, 201, 'A', '分类删除', '', 0, 'albums:cateDel', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (215, 200, 'M', '上传管理', '', 0, '', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (216, 215, 'A', '上传图片', '', 0, 'upload:image', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (217, 215, 'A', '上传视频', '', 0, 'upload:video', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (500, 0, 'M', '系统设置', 'el-icon-Setting', 0, '', 'setting', '', '', '', 0, 1, 0, 1650341765, 1662626322);
INSERT INTO `la_system_auth_menu` VALUES (501, 500, 'M', '网站设置', 'el-icon-Basketball', 10, '', 'website', '', '', '', 0, 1, 0, 1650341765, 1663233572);
INSERT INTO `la_system_auth_menu` VALUES (502, 501, 'C', '网站信息', '', 0, 'setting:website:detail', 'information', 'setting/website/information', '', '', 0, 1, 0, 1650341765, 1660202218);
INSERT INTO `la_system_auth_menu` VALUES (503, 502, 'A', '保存配置', '', 0, 'setting:website:save', '', '', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (505, 501, 'C', '网站备案', '', 0, 'setting:copyright:detail', 'filing', 'setting/website/filing', '', '', 0, 1, 0, 1650341765, 1660202294);
INSERT INTO `la_system_auth_menu` VALUES (506, 505, 'A', '备案保存', '', 0, 'setting:copyright:save', '', 'setting/website/protocol', '', '', 0, 0, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (510, 501, 'C', '政策协议', '', 0, 'setting:protocol:detail', 'protocol', 'setting/website/protocol', '', '', 0, 0, 0, 1660027606, 1685611428);
INSERT INTO `la_system_auth_menu` VALUES (511, 510, 'A', '协议保存', '', 0, 'setting:protocol:save', '', '', '', '', 0, 0, 0, 1660027606, 1663670865);
INSERT INTO `la_system_auth_menu` VALUES (515, 600, 'C', '字典管理', 'el-icon-Box', 0, 'setting:dict:type:list', 'dict', 'setting/dict/type/index', '', '', 0, 1, 1, 1660035436, 1684215969);
INSERT INTO `la_system_auth_menu` VALUES (516, 515, 'A', '字典类型新增', '', 0, 'setting:dict:type:add', '', '', '', '', 0, 1, 0, 1660202761, 1660202761);
INSERT INTO `la_system_auth_menu` VALUES (517, 515, 'A', '字典类型编辑', '', 0, 'setting:dict:type:edit', '', '', '', '', 0, 1, 0, 1660202842, 1660202842);
INSERT INTO `la_system_auth_menu` VALUES (518, 515, 'A', '字典类型删除', '', 0, 'setting:dict:type:del', '', '', '', '', 0, 1, 0, 1660202903, 1660202903);
INSERT INTO `la_system_auth_menu` VALUES (519, 600, 'C', '字典数据管理', '', 0, 'setting:dict:data:list', 'dict/data', 'setting/dict/data/index', '/dev_tools/dict', '', 0, 0, 0, 1660202948, 1663309252);
INSERT INTO `la_system_auth_menu` VALUES (520, 515, 'A', '字典数据新增', '', 0, 'setting:dict:data:add', '', '', '', '', 0, 1, 0, 1660203117, 1660203117);
INSERT INTO `la_system_auth_menu` VALUES (521, 515, 'A', '字典数据编辑', '', 0, 'setting:dict:data:edit', '', '', '', '', 0, 1, 0, 1660203142, 1660203142);
INSERT INTO `la_system_auth_menu` VALUES (522, 515, 'A', '字典数据删除', '', 0, 'setting:dict:data:del', '', '', '', '', 0, 1, 0, 1660203159, 1660203159);
INSERT INTO `la_system_auth_menu` VALUES (550, 500, 'M', '系统维护', 'el-icon-SetUp', 0, '', 'system', '', '', '', 0, 1, 0, 1650341765, 1660202466);
INSERT INTO `la_system_auth_menu` VALUES (551, 550, 'C', '系统环境', '', 0, 'monitor:server', 'environment', 'setting/system/environment', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (552, 550, 'C', '系统缓存', '', 0, 'monitor:cache', 'cache', 'setting/system/cache', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (553, 550, 'C', '系统日志', '', 0, 'system:log:operate', 'journal', 'setting/system/journal', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (555, 500, 'C', '存储设置', 'el-icon-FolderOpened', 6, 'setting:storage:list', 'storage', 'setting/storage/index', '', '', 0, 1, 0, 1650341765, 1663312996);
INSERT INTO `la_system_auth_menu` VALUES (556, 555, 'A', '保存配置', '', 0, 'setting:storage:edit', '', '', '', '', 0, 1, 0, 1650341765, 1650341765);
INSERT INTO `la_system_auth_menu` VALUES (600, 0, 'M', '开发工具', 'el-icon-EditPen', 0, '', 'dev_tools', '', '', '', 0, 0, 0, 1660027606, 1685611461);
INSERT INTO `la_system_auth_menu` VALUES (610, 600, 'C', '代码生成器', 'el-icon-DocumentAdd', 0, 'gen:list', 'code', 'dev_tools/code/index', '', '', 0, 1, 1, 1660028954, 1684215984);
INSERT INTO `la_system_auth_menu` VALUES (611, 610, 'A', '导入数据表', '', 0, 'gen:importTable', '', '', '', '', 0, 1, 0, 1660532389, 1660532389);
INSERT INTO `la_system_auth_menu` VALUES (612, 610, 'A', '生成代码', '', 0, 'gen:genCode', '', '', '', '', 0, 1, 0, 1660532421, 1660532421);
INSERT INTO `la_system_auth_menu` VALUES (613, 610, 'A', '下载代码', '', 0, 'gen:downloadCode', '', '', '', '', 0, 1, 0, 1660532437, 1660532437);
INSERT INTO `la_system_auth_menu` VALUES (614, 610, 'A', '预览代码', '', 0, 'gen:previewCode', '', '', '', '', 0, 1, 0, 1660532549, 1660532549);
INSERT INTO `la_system_auth_menu` VALUES (616, 610, 'A', '同步表结构', '', 0, 'gen:syncTable', '', '', '', '', 0, 1, 0, 1660532781, 1660532781);
INSERT INTO `la_system_auth_menu` VALUES (617, 610, 'A', '删除数据表', '', 0, 'gen:delTable', '', '', '', '', 0, 1, 0, 1660532800, 1660532800);
INSERT INTO `la_system_auth_menu` VALUES (618, 610, 'A', '数据表详情', '', 0, 'gen:detail', '', '', '', '', 0, 1, 0, 1660532964, 1660532977);
INSERT INTO `la_system_auth_menu` VALUES (700, 0, 'M', '素材管理', 'el-icon-Picture', 43, '', 'material', '', '', '', 0, 1, 0, 1660203293, 1663300847);
INSERT INTO `la_system_auth_menu` VALUES (701, 700, 'C', '素材中心', 'el-icon-PictureRounded', 0, '', 'index', 'material/index', '', '', 0, 1, 0, 1660203402, 1663301493);
INSERT INTO `la_system_auth_menu` VALUES (703, 0, 'M', '菜品管理', 'el-icon-ChatLineSquare', 48, '', 'dish', '', '', '', 0, 1, 0, 1661757636, 1680177680);
INSERT INTO `la_system_auth_menu` VALUES (704, 703, 'C', '菜品列表', 'el-icon-ChatDotSquare', 3, 'dish:list', 'lists', 'dish/lists/index', '', '', 1, 1, 0, 1661757743, 1680177177);
INSERT INTO `la_system_auth_menu` VALUES (705, 703, 'C', '菜品分类', 'el-icon-CollectionTag', 0, 'dish:cate:list', 'column', 'dish/column/index', '', '', 1, 1, 0, 1661759218, 1680177339);
INSERT INTO `la_system_auth_menu` VALUES (706, 0, 'M', '渠道设置', 'el-icon-Message', 46, '', 'channel', '', '', '', 0, 1, 1, 1661767630, 1678331735);
INSERT INTO `la_system_auth_menu` VALUES (707, 706, 'C', 'H5设置', 'el-icon-Cellphone', 0, 'channel:h5:detail', 'h5', 'channel/h5', '', '', 0, 1, 1, 1661768566, 1678331929);
INSERT INTO `la_system_auth_menu` VALUES (708, 706, 'M', '微信公众号', 'local-icon-dingdan', 0, '', 'wx_oa', '', '', '', 0, 1, 1, 1661769386, 1678331935);
INSERT INTO `la_system_auth_menu` VALUES (709, 708, 'C', '公众号配置', '', 0, 'channel:oa:detail', 'config', 'channel/wx_oa/config', '', '', 0, 1, 1, 1661769457, 1678332106);
INSERT INTO `la_system_auth_menu` VALUES (710, 706, 'C', '微信小程序', 'local-icon-qudao_xiaochengxu', 0, 'channel:mp:detail', 'weapp', 'channel/weapp', '', '', 0, 1, 1, 1661823746, 1678331942);
INSERT INTO `la_system_auth_menu` VALUES (711, 706, 'C', '微信开放平台', 'local-icon-weixin', 0, 'channel:op:detail', 'wx_op', 'channel/wx_op', '', '', 0, 1, 1, 1661824989, 1678331947);
INSERT INTO `la_system_auth_menu` VALUES (712, 0, 'M', '用户管理', 'el-icon-User', 48, '', 'consumer', '', '', '', 0, 1, 1, 1661832966, 1678331756);
INSERT INTO `la_system_auth_menu` VALUES (713, 712, 'C', '用户列表', 'el-icon-User', 0, 'user:list', 'lists', 'consumer/lists/index', '', '', 0, 1, 1, 1661839365, 1678332035);
INSERT INTO `la_system_auth_menu` VALUES (714, 714, 'A', '用户编辑', '', 0, 'user:edit', 'detail', 'consumer/lists/detail', '/consumer/lists', '', 0, 0, 0, 1661840502, 1662627718);
INSERT INTO `la_system_auth_menu` VALUES (715, 600, 'C', '编辑数据表', '', 0, 'gen:editTable', 'code/edit', 'dev_tools/code/edit', '/dev_tools/code', '', 0, 0, 0, 1661843525, 1661843615);
INSERT INTO `la_system_auth_menu` VALUES (716, 705, 'A', '栏目详情', '', 0, 'dish:cate:detail', 'lists/edit', 'article/lists/edit', '/article/lists', '', 0, 0, 0, 1661844126, 1680177426);
INSERT INTO `la_system_auth_menu` VALUES (717, 0, 'M', '店铺管理', 'el-icon-Brush', 46, '', 'decoration', '', '', '', 0, 1, 0, 1661845634, 1683775411);
INSERT INTO `la_system_auth_menu` VALUES (718, 717, 'C', '页面装修', 'el-icon-CopyDocument', 0, 'decorate:pages:detail', 'pages', 'decoration/pages/index', '', '', 0, 1, 1, 1661845678, 1684215845);
INSERT INTO `la_system_auth_menu` VALUES (719, 717, 'C', '底部导航', 'el-icon-Position', 0, 'decorate:tabbar:detail', 'tabbar', 'decoration/tabbar', '', '', 0, 1, 1, 1661845811, 1684215868);
INSERT INTO `la_system_auth_menu` VALUES (720, 500, 'M', '消息通知', 'el-icon-Message', 9, '', 'message', '', '', '', 0, 0, 0, 1661848742, 1685611480);
INSERT INTO `la_system_auth_menu` VALUES (721, 720, 'C', '通知设置', '', 0, 'setting:notice:list', 'notice', 'message/notice/index', '', '', 0, 1, 0, 1661848772, 1662638112);
INSERT INTO `la_system_auth_menu` VALUES (722, 720, 'C', '通知详情', '', 0, 'setting:notice:detail', 'notice/edit', 'message/notice/edit', '/setting/message/notice', '', 0, 0, 0, 1661848944, 1663142853);
INSERT INTO `la_system_auth_menu` VALUES (723, 720, 'C', '短信设置', '', 0, 'setting:sms:list', 'short_letter', 'message/short_letter/index', '', '', 0, 1, 0, 1661848995, 1662638165);
INSERT INTO `la_system_auth_menu` VALUES (724, 500, 'M', '用户设置', 'local-icon-keziyuyue', 8, '', 'user', '', '', '', 0, 1, 1, 1662455407, 1684216012);
INSERT INTO `la_system_auth_menu` VALUES (725, 724, 'C', '用户设置', '', 0, 'setting:user:detail', 'setup', 'setting/user/setup', '', '', 0, 1, 1, 1662455555, 1684216025);
INSERT INTO `la_system_auth_menu` VALUES (726, 724, 'C', '登录注册', '', 0, 'setting:login:detail', 'login_register', 'setting/user/login_register', '', '', 0, 1, 1, 1662456475, 1684216030);
INSERT INTO `la_system_auth_menu` VALUES (728, 500, 'C', '热门搜索', 'el-icon-Search', 7, 'setting:search:detail', 'search', 'setting/search/index', '', '', 0, 1, 1, 1662540429, 1684216060);
INSERT INTO `la_system_auth_menu` VALUES (730, 704, 'A', '文章新增', '', 0, 'dish:add', '', '', '', '', 0, 1, 0, 1662625870, 1680177391);
INSERT INTO `la_system_auth_menu` VALUES (732, 704, 'A', '文章删除', '', 0, 'article:del', '', '', '', '', 0, 1, 0, 1662625894, 1662625894);
INSERT INTO `la_system_auth_menu` VALUES (733, 704, 'A', '文章状态', '', 0, 'dish:change', '', '', '', '', 0, 1, 0, 1662625909, 1680177397);
INSERT INTO `la_system_auth_menu` VALUES (734, 705, 'A', '栏目新增', '', 0, 'dish:cate:add', '', '', '', '', 0, 1, 0, 1662626024, 1680177431);
INSERT INTO `la_system_auth_menu` VALUES (735, 705, 'A', '栏目编辑', '', 0, 'dish:cate:edit', '', '', '', '', 0, 1, 0, 1662626044, 1680177438);
INSERT INTO `la_system_auth_menu` VALUES (736, 705, 'A', '栏目删除', '', 0, 'dish:cate:del', '', '', '', '', 0, 1, 0, 1662626060, 1680177444);
INSERT INTO `la_system_auth_menu` VALUES (737, 705, 'A', '栏目状态', '', 0, 'dish:cate:change', '', '', '', '', 0, 1, 0, 1662626077, 1680177450);
INSERT INTO `la_system_auth_menu` VALUES (738, 704, 'A', '文章编辑', '', 0, 'dish:edit', 'lists/edit', 'article/lists/edit', '', '', 0, 0, 0, 1662626554, 1680177403);
INSERT INTO `la_system_auth_menu` VALUES (739, 712, 'C', '用户详情', '', 0, 'user:detail', 'detail', 'consumer/lists/detail', '/consumer/lists', '', 0, 0, 1, 1662628049, 1678332046);
INSERT INTO `la_system_auth_menu` VALUES (740, 739, 'A', '用户编辑', '', 0, 'user:edit', '', '', '', '', 0, 1, 0, 1662628085, 1662628085);
INSERT INTO `la_system_auth_menu` VALUES (741, 721, 'A', '设置保存', '', 0, 'setting:notice:save', '', '', '', '', 0, 1, 0, 1662638049, 1662638049);
INSERT INTO `la_system_auth_menu` VALUES (742, 723, 'A', '短信详情', '', 0, 'setting:sms:detail', '', '', '', '', 0, 1, 0, 1662638180, 1662638180);
INSERT INTO `la_system_auth_menu` VALUES (743, 723, 'A', '保存设置', '', 0, 'setting:sms:save', '', '', '', '', 0, 1, 0, 1662638196, 1662638196);
INSERT INTO `la_system_auth_menu` VALUES (744, 707, 'A', '设置保存', '', 0, 'channel:h5:save', '', '', '', '', 0, 1, 0, 1662638326, 1662638326);
INSERT INTO `la_system_auth_menu` VALUES (745, 710, 'A', '设置保存', '', 0, 'channel:mp:detail', '', '', '', '', 0, 1, 0, 1662638359, 1662638359);
INSERT INTO `la_system_auth_menu` VALUES (746, 711, 'A', '保存设置', '', 0, 'channel:op:save', '', '', '', '', 0, 1, 0, 1662638410, 1673248274);
INSERT INTO `la_system_auth_menu` VALUES (747, 709, 'A', '保存', '', 0, 'channel:oa:save', '', '', '', '', 0, 1, 0, 1662638459, 1663310514);
INSERT INTO `la_system_auth_menu` VALUES (748, 708, 'C', '菜单管理', '', 0, 'channel:oaMenu:detail', 'menu', 'channel/wx_oa/menu', '', '', 0, 1, 1, 1663050714, 1678332114);
INSERT INTO `la_system_auth_menu` VALUES (750, 708, 'C', '关注回复', '', 0, 'channel:oaReplyFollow:list', 'follow', 'channel/wx_oa/reply/follow_reply', '', '', 0, 1, 1, 1663149592, 1678332119);
INSERT INTO `la_system_auth_menu` VALUES (751, 708, 'C', '关键字回复', '', 0, 'channel:oaReplyKeyword:list', 'keyword', 'channel/wx_oa/reply/keyword_reply', '', '', 0, 1, 1, 1663149622, 1678332125);
INSERT INTO `la_system_auth_menu` VALUES (752, 708, 'C', '默认回复', '', 0, 'channel:oaReplyDefault:list', 'default', 'channel/wx_oa/reply/default_reply', '', '', 0, 1, 1, 1663149650, 1678332131);
INSERT INTO `la_system_auth_menu` VALUES (753, 718, 'A', '保存', '', 0, 'decorate:pages:save', '', '', '', '', 0, 1, 0, 1663236648, 1663236648);
INSERT INTO `la_system_auth_menu` VALUES (754, 719, 'A', '保存', '', 0, 'decorate:tabbar:save', '', '', '', '', 0, 1, 0, 1663236675, 1663236675);
INSERT INTO `la_system_auth_menu` VALUES (755, 704, 'A', '文章详情', '', 0, 'dish:detail', '', '', '', '', 0, 1, 0, 1663310241, 1680177414);
INSERT INTO `la_system_auth_menu` VALUES (756, 748, 'A', '发布', '', 0, 'channel:oaMenu:publish', '', '', '', '', 0, 1, 0, 1663310379, 1663310525);
INSERT INTO `la_system_auth_menu` VALUES (757, 748, 'A', '保存', '', 0, 'channel:oaMenu:save', '', '', '', '', 0, 1, 0, 1663310556, 1663310556);
INSERT INTO `la_system_auth_menu` VALUES (758, 725, 'A', '保存', '', 0, 'setting:user:save', '', '', '', '', 0, 1, 0, 1663312193, 1663312193);
INSERT INTO `la_system_auth_menu` VALUES (759, 726, 'A', '保存', '', 0, 'setting:login:save', '', '', '', '', 0, 1, 0, 1663312289, 1663312289);
INSERT INTO `la_system_auth_menu` VALUES (760, 728, 'A', '保存', '', 0, 'setting:search:save', '', '', '', '', 0, 1, 0, 1663312423, 1663312423);
INSERT INTO `la_system_auth_menu` VALUES (762, 750, 'A', '新增', '', 0, 'channel:oaReplyFollow:add', '', '', '', '', 1, 1, 0, 1664511131, 1664511131);
INSERT INTO `la_system_auth_menu` VALUES (763, 750, 'A', '状态', '', 0, 'channel:oaReplyFollow:status', '', '', '', '', 1, 1, 0, 1664511160, 1664511160);
INSERT INTO `la_system_auth_menu` VALUES (764, 750, 'A', '编辑', '', 0, 'channel:oaReplyFollow:edit', '', '', '', '', 1, 1, 0, 1664511177, 1664511190);
INSERT INTO `la_system_auth_menu` VALUES (765, 750, 'A', '删除', '', 0, 'channel:oaReplyFollow:del', '', '', '', '', 1, 1, 0, 1664511208, 1664511208);
INSERT INTO `la_system_auth_menu` VALUES (766, 751, 'A', '新增', '', 0, 'channel:oaReplyKeyword:add', '', '', '', '', 1, 1, 0, 1664511264, 1664511264);
INSERT INTO `la_system_auth_menu` VALUES (767, 751, 'A', '状态', '', 0, 'channel:oaReplyKeyword:status', '', '', '', '', 1, 1, 0, 1664511295, 1664511295);
INSERT INTO `la_system_auth_menu` VALUES (768, 751, 'A', '编辑', '', 0, 'channel:oaReplyKeyword:edit', '', '', '', '', 1, 1, 0, 1664511312, 1664511312);
INSERT INTO `la_system_auth_menu` VALUES (769, 751, 'A', '删除', '', 0, 'channel:oaReplyKeyword:del', '', '', '', '', 1, 1, 0, 1664511327, 1664511327);
INSERT INTO `la_system_auth_menu` VALUES (770, 752, 'A', '新增', '', 0, 'channel:oaReplyDefault:add', '', '', '', '', 1, 1, 0, 1664517709, 1664517709);
INSERT INTO `la_system_auth_menu` VALUES (771, 752, 'A', '编辑', '', 0, 'channel:oaReplyDefault:edit', '', '', '', '', 1, 1, 0, 1664517725, 1664517725);
INSERT INTO `la_system_auth_menu` VALUES (772, 752, 'A', '状态', '', 0, 'channel:oaReplyDefault:status', '', '', '', '', 1, 1, 0, 1664517757, 1664517757);
INSERT INTO `la_system_auth_menu` VALUES (773, 752, 'A', '删除', '', 0, 'channel:oaReplyDefault:del', '', '', '', '', 1, 1, 0, 1664517778, 1664517778);
INSERT INTO `la_system_auth_menu` VALUES (774, 610, 'A', '导入数据表列表', '', 0, 'gen:db', '', '', '', '', 1, 1, 0, 1665646316, 1665646316);
INSERT INTO `la_system_auth_menu` VALUES (775, 703, 'C', '菜品添加/编辑', '', 0, 'dish:add/edit', 'lists/edit', 'dish/lists/edit', '/dish/lists', '', 0, 0, 0, 1668677477, 1680177382);
INSERT INTO `la_system_auth_menu` VALUES (779, 717, 'C', 'PC端', 'el-icon-Monitor', 0, '', 'pc', 'decoration/pc', '', '', 0, 1, 1, 1673248971, 1684215875);
INSERT INTO `la_system_auth_menu` VALUES (780, 0, 'M', '模板', 'el-icon-SetUp', 0, '', 'template', '', '', '', 0, 0, 0, 1673319812, 1685611467);
INSERT INTO `la_system_auth_menu` VALUES (781, 780, 'M', '组件示例', 'el-icon-Coin', 0, '', 'component', '', '', '', 0, 1, 1, 1673319842, 1678332221);
INSERT INTO `la_system_auth_menu` VALUES (782, 781, 'C', '富文本', '', 0, '', 'rich_text', 'template/component/rich_text', '', '', 0, 1, 1, 1673319879, 1678332251);
INSERT INTO `la_system_auth_menu` VALUES (783, 781, 'C', '上传文件', '', 0, '', 'upload', 'template/component/upload', '', '', 0, 1, 1, 1673319905, 1678332257);
INSERT INTO `la_system_auth_menu` VALUES (784, 781, 'C', '图标', '', 0, '', 'icon', 'template/component/icon', '', '', 0, 1, 1, 1673319936, 1678332262);
INSERT INTO `la_system_auth_menu` VALUES (785, 781, 'C', '文件选择器', '', 0, '', 'file', 'template/component/file', '', '', 0, 1, 1, 1673319972, 1678332266);
INSERT INTO `la_system_auth_menu` VALUES (786, 781, 'C', '链接选择器', '', 0, '', 'link', 'template/component/link', '', '', 0, 1, 1, 1673319997, 1678332270);
INSERT INTO `la_system_auth_menu` VALUES (787, 781, 'C', '超出自动打点', '', 0, '', 'overflow', 'template/component/overflow', '', '', 0, 1, 1, 1673320021, 1678332275);
INSERT INTO `la_system_auth_menu` VALUES (788, 781, 'C', '悬浮input', '', 0, '', 'popover_input', 'template/component/popover_input', '', '', 0, 1, 1, 1673320046, 1678332279);
INSERT INTO `la_system_auth_menu` VALUES (790, 0, 'C', '点餐台', 'el-icon-Monitor', 49, 'order:index', 'order/index', 'order/index', '', '', 1, 1, 0, 1678365242, 1679145658);
INSERT INTO `la_system_auth_menu` VALUES (794, 0, 'M', '订单管理', 'el-icon-Tickets', 45, '', 'orders', '', '', '', 0, 1, 0, 1679308510, 1679308531);
INSERT INTO `la_system_auth_menu` VALUES (795, 794, 'C', '订单列表', 'el-icon-CreditCard', 0, 'orders:list', 'list', 'orders/list', '', '', 0, 1, 0, 1679308751, 1680178390);
INSERT INTO `la_system_auth_menu` VALUES (796, 717, 'C', '店铺设置', 'el-icon-Setting', 0, 'shop:info', 'shop/info', 'shop/info', '', '', 0, 1, 0, 1684141210, 1684141210);
INSERT INTO `la_system_auth_menu` VALUES (797, 717, 'C', '小票打印机', 'el-icon-Printer', 0, 'shop:print:index', 'print', 'shop/print/index', '', '', 0, 1, 0, 1684141298, 1684141298);

-- ----------------------------
-- Table structure for la_system_auth_perm
-- ----------------------------
DROP TABLE IF EXISTS `la_system_auth_perm`;
CREATE TABLE `la_system_auth_perm`  (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '主键',
  `role_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色ID',
  `menu_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统角色菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_auth_perm
-- ----------------------------
INSERT INTO `la_system_auth_perm` VALUES ('0953cc5d26e71566a00e74e3c464025d', 2, 701);
INSERT INTO `la_system_auth_perm` VALUES ('0a97b5c275f18f497d3601c4c6ff4ccb', 2, 795);
INSERT INTO `la_system_auth_perm` VALUES ('0aa224d1558f855dd2960709d8013d5b', 2, 142);
INSERT INTO `la_system_auth_perm` VALUES ('0e8c1f0fb59b367245c1fd62c2e96491', 2, 134);
INSERT INTO `la_system_auth_perm` VALUES ('104a633af692e7c0bfae7f0a507b1421', 2, 737);
INSERT INTO `la_system_auth_perm` VALUES ('1411c9af277e53c1522fb48decbf7f84', 2, 716);
INSERT INTO `la_system_auth_perm` VALUES ('18e7c21995608987ad05925ecde92033', 2, 130);
INSERT INTO `la_system_auth_perm` VALUES ('241bd428ee475d0e1e91332c4cb1b2a4', 2, 132);
INSERT INTO `la_system_auth_perm` VALUES ('29a174c719d11902359fe3e7b5f0a22b', 2, 133);
INSERT INTO `la_system_auth_perm` VALUES ('39522b0af820f140a780dec1db37d00a', 2, 735);
INSERT INTO `la_system_auth_perm` VALUES ('41274c6afd2a0f8b5c21b53139019a3a', 2, 704);
INSERT INTO `la_system_auth_perm` VALUES ('4355f1a6b0cbedd012f61ff6d5597bfc', 2, 797);
INSERT INTO `la_system_auth_perm` VALUES ('4ddba641444ab3679b94066819dc4c3d', 2, 730);
INSERT INTO `la_system_auth_perm` VALUES ('5874b8675fc6c378e2048a4976d4e543', 2, 755);
INSERT INTO `la_system_auth_perm` VALUES ('597808ef23e449cfc71875b46fba6017', 2, 794);
INSERT INTO `la_system_auth_perm` VALUES ('6dd2052a8c3593330d20456f499e8187', 2, 1);
INSERT INTO `la_system_auth_perm` VALUES ('7661d830acbddb411aa6fa9763feb0ec', 2, 717);
INSERT INTO `la_system_auth_perm` VALUES ('7847c40670a6a20a2818fe5ec6b443fa', 2, 734);
INSERT INTO `la_system_auth_perm` VALUES ('7bb7c7e7a0adaf7ce88b13a69296d923', 2, 140);
INSERT INTO `la_system_auth_perm` VALUES ('90fcf6366b642eae5404eda50cf139e4', 2, 703);
INSERT INTO `la_system_auth_perm` VALUES ('9c57e9361ca58bf100ee755ba445107f', 2, 732);
INSERT INTO `la_system_auth_perm` VALUES ('9e3f115ca317afb94b23f9bee50ed3c6', 2, 700);
INSERT INTO `la_system_auth_perm` VALUES ('a43c5c15dbac356b41853b77c426f64b', 2, 141);
INSERT INTO `la_system_auth_perm` VALUES ('a94985be7eaac144af338b523f9924f5', 2, 736);
INSERT INTO `la_system_auth_perm` VALUES ('ab9e7b7d1433e73f971d51e6bb4ec798', 2, 705);
INSERT INTO `la_system_auth_perm` VALUES ('b189e86dd0da0024cd1ebe95ba09bd1f', 2, 143);
INSERT INTO `la_system_auth_perm` VALUES ('b91e1774d606f1f412dcb2ad9f867add', 2, 144);
INSERT INTO `la_system_auth_perm` VALUES ('bad9255c02448cfe3e015d25aaa164b5', 2, 775);
INSERT INTO `la_system_auth_perm` VALUES ('c1c3fcb8c1f13d59739916c6269b02c6', 2, 131);
INSERT INTO `la_system_auth_perm` VALUES ('c8a4e65aa2633437028ed309c8039288', 2, 733);
INSERT INTO `la_system_auth_perm` VALUES ('ca14c0708032c1a1f060eeb2790d23c2', 2, 738);
INSERT INTO `la_system_auth_perm` VALUES ('da528c4c70fc0b0aa9b933ee68429835', 2, 796);
INSERT INTO `la_system_auth_perm` VALUES ('fec7e24e36d471a2cb91fe89d4eefbcd', 2, 135);
INSERT INTO `la_system_auth_perm` VALUES ('fed277292f8b86f01bdcfb205a197be0', 2, 790);

-- ----------------------------
-- Table structure for la_system_auth_post
-- ----------------------------
DROP TABLE IF EXISTS `la_system_auth_post`;
CREATE TABLE `la_system_auth_post`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aid` int(10) NOT NULL,
  `code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '岗位编码',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '岗位名称',
  `remarks` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '岗位备注',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '岗位排序',
  `is_stop` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否停用: 0=否, 1=是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统岗位管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_auth_post
-- ----------------------------
INSERT INTO `la_system_auth_post` VALUES (1, 1, '', '666包间', '', 0, 0, 0, 1680438761, 1680768549, 0);
INSERT INTO `la_system_auth_post` VALUES (2, 1, '', '888包间', '', 0, 0, 0, 1680438772, 1680768557, 0);
INSERT INTO `la_system_auth_post` VALUES (3, 1, '', '大厅', '', 1, 0, 0, 1680438780, 1680768583, 0);
INSERT INTO `la_system_auth_post` VALUES (4, 1, '', '999包间', '', 0, 0, 0, 1680768573, 1680768573, 0);
INSERT INTO `la_system_auth_post` VALUES (5, 1, '', '111包间', '', 0, 0, 0, 1680768655, 1680768655, 0);
INSERT INTO `la_system_auth_post` VALUES (6, 1, '', '二楼大厅', '', 0, 0, 0, 1685862981, 1685862981, 0);
INSERT INTO `la_system_auth_post` VALUES (7, 1, '', '二楼包间', '', 0, 0, 0, 1685862989, 1685862989, 0);
INSERT INTO `la_system_auth_post` VALUES (8, 1, '', '三楼', '', 0, 0, 0, 1685863258, 1685863258, 0);

-- ----------------------------
-- Table structure for la_system_auth_role
-- ----------------------------
DROP TABLE IF EXISTS `la_system_auth_role`;
CREATE TABLE `la_system_auth_role`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注信息',
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色排序',
  `is_disable` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否禁用: 0=否, 1=是',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统角色管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_auth_role
-- ----------------------------
INSERT INTO `la_system_auth_role` VALUES (2, '商户', '', 0, 0, 1680938448, 1686016013);

-- ----------------------------
-- Table structure for la_system_config
-- ----------------------------
DROP TABLE IF EXISTS `la_system_config`;
CREATE TABLE `la_system_config`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '类型',
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '键',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '值',
  `create_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统全局配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_config
-- ----------------------------
INSERT INTO `la_system_config` VALUES (1, 'storage', 'default', 'qiniu', 1660620367, 1680251990);
INSERT INTO `la_system_config` VALUES (2, 'storage', 'local', '{\"name\":\"本地存储\"}', 1660620367, 1679302717);
INSERT INTO `la_system_config` VALUES (3, 'storage', 'qiniu', '{\"name\":\"七牛云存储\",\"bucket\":\"zhaoyafei\",\"secretKey\":\"zT3XIoFnEfNNUxjnXSV5F\",\"accessKey\":\"wV6SuE3kyKg1OVl\",\"domain\":\"http://qiniu\"}', 1660620367, 1680251990);
INSERT INTO `la_system_config` VALUES (4, 'storage', 'aliyun', '{\"name\":\"阿里云OSS\",\"bucket\":\"\",\"secretKey\":\"\",\"accessKey\":\"\",\"domain\":\"\"}', 1660620367, 1662620071);
INSERT INTO `la_system_config` VALUES (5, 'storage', 'qcloud', '{\"name\":\"腾讯云COS\",\"bucket\":\"\",\"secretKey\":\"\",\"accessKey\":\"\",\"domain\":\"\",\"region\":\"\"}', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (6, 'sms', 'default', 'aliyun', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (7, 'sms', 'aliyun', '{\"name\":\"阿里云短信\",\"alias\":\"aliyun\",\"sign\":\"\",\"appKey\":\"\",\"secretKey\":\"\"}', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (8, 'sms', 'tencent', '{\"name\":\"腾讯云短信\",\"alias\":\"tencent\",\"sign\":\"\",\"appId\":\"\",\"secretId\":\"\",\"secretKey\":\"\"}', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (9, 'sms', 'huawei', '{\"name\":\"华为云短信\",\"alias\":\"huawei\"}', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (10, 'website', 'name', '扫码点餐系统', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (11, 'website', 'logo', '/api/static/backend_logo.png', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (12, 'website', 'favicon', '/api/static/backend_favicon.ico', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (13, 'website', 'backdrop', '/api/static/backend_backdrop.png', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (14, 'website', 'copyright', '[{\"link\":\"\",\"name\":\"面向商户的扫码点餐系统（多商户）\"}]', 1660620367, 1684063076);
INSERT INTO `la_system_config` VALUES (15, 'website', 'shopName', 'LikeAdmin开源系统', 1631255140, 1631255140);
INSERT INTO `la_system_config` VALUES (16, 'website', 'shopLogo', '/api/static/shop_logo.png', 1631255140, 1631255140);
INSERT INTO `la_system_config` VALUES (17, 'protocol', 'service', '{\"name\":\"服务协议\",\"content\":\"\"}', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (18, 'protocol', 'privacy', '{\"name\":\"隐私协议\",\"content\":\"\"}', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (19, 'tabbar', 'style', '{\"defaultColor\":\"#4A5DFF\",\"selectedColor\":\"#EA5455\"}', 1660620367, 1662544900);
INSERT INTO `la_system_config` VALUES (20, 'search', 'isHotSearch', '0', 1660620367, 1662546997);
INSERT INTO `la_system_config` VALUES (30, 'h5_channel', 'status', '1', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (31, 'h5_channel', 'close', '0', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (32, 'h5_channel', 'url', '', 1660620367, 1660620367);
INSERT INTO `la_system_config` VALUES (40, 'mp_channel', 'name', '', 1660620367, 1662551403);
INSERT INTO `la_system_config` VALUES (41, 'mp_channel', 'primaryId', '', 1660620367, 1662551403);
INSERT INTO `la_system_config` VALUES (42, 'mp_channel', 'appId', '', 1660620367, 1662551403);
INSERT INTO `la_system_config` VALUES (43, 'mp_channel', 'appSecret', '', 1660620367, 1662551403);
INSERT INTO `la_system_config` VALUES (44, 'mp_channel', 'qrCode', '', 1660620367, 1662551403);
INSERT INTO `la_system_config` VALUES (55, 'oa_channel', 'name', '', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (56, 'oa_channel', 'primaryId', ' ', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (57, 'oa_channel', 'qrCode', '', 1662551337, 1662551337);
INSERT INTO `la_system_config` VALUES (58, 'oa_channel', 'appId', '', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (59, 'oa_channel', 'appSecret', '', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (60, 'oa_channel', 'url', '', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (61, 'oa_channel', 'token', '', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (62, 'oa_channel', 'encodingAesKey', '', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (63, 'oa_channel', 'encryptionType', '1', 1660620367, 1662551337);
INSERT INTO `la_system_config` VALUES (64, 'oa_channel', 'menus', '[]', 1631255140, 1663118712);
INSERT INTO `la_system_config` VALUES (68, 'op_channel', 'appId', '', 0, 0);
INSERT INTO `la_system_config` VALUES (69, 'op_channel', 'appSecret', '', 0, 0);
INSERT INTO `la_system_config` VALUES (70, 'login', 'loginWay', '1,2', 1660620367, 1662538771);
INSERT INTO `la_system_config` VALUES (71, 'login', 'forceBindMobile', '0', 1660620367, 1662538771);
INSERT INTO `la_system_config` VALUES (72, 'login', 'openAgreement', '1', 1660620367, 1662538771);
INSERT INTO `la_system_config` VALUES (73, 'login', 'openOtherAuth', '1', 1660620367, 1662538771);
INSERT INTO `la_system_config` VALUES (74, 'login', 'autoLoginAuth', '1,2', 1660620367, 1662538771);
INSERT INTO `la_system_config` VALUES (80, 'user', 'defaultAvatar', '/api/static/default_avatar.png', 1660620367, 1662535156);

-- ----------------------------
-- Table structure for la_system_log_login
-- ----------------------------
DROP TABLE IF EXISTS `la_system_log_login`;
CREATE TABLE `la_system_log_login`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '注解',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录账号',
  `ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录地址',
  `os` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作系统',
  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '操作状态: 1=成功, 2=失败',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统登录日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_log_login
-- ----------------------------
INSERT INTO `la_system_log_login` VALUES (1, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1677420560);
INSERT INTO `la_system_log_login` VALUES (2, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1677420578);
INSERT INTO `la_system_log_login` VALUES (3, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1677420657);
INSERT INTO `la_system_log_login` VALUES (4, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678324458);
INSERT INTO `la_system_log_login` VALUES (5, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678324565);
INSERT INTO `la_system_log_login` VALUES (6, 2, 'ceshi', '127.0.0.1', 'Windows', 'Firefox', 1, 1678325042);
INSERT INTO `la_system_log_login` VALUES (7, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678325071);
INSERT INTO `la_system_log_login` VALUES (8, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678326495);
INSERT INTO `la_system_log_login` VALUES (9, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678326773);
INSERT INTO `la_system_log_login` VALUES (10, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678354264);
INSERT INTO `la_system_log_login` VALUES (11, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678354281);
INSERT INTO `la_system_log_login` VALUES (12, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678774192);
INSERT INTO `la_system_log_login` VALUES (13, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1678862187);
INSERT INTO `la_system_log_login` VALUES (14, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1679115551);
INSERT INTO `la_system_log_login` VALUES (15, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1679204367);
INSERT INTO `la_system_log_login` VALUES (16, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1679296369);
INSERT INTO `la_system_log_login` VALUES (17, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1679377905);
INSERT INTO `la_system_log_login` VALUES (18, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1679462516);
INSERT INTO `la_system_log_login` VALUES (19, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1679548873);
INSERT INTO `la_system_log_login` VALUES (20, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680056552);
INSERT INTO `la_system_log_login` VALUES (21, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680153770);
INSERT INTO `la_system_log_login` VALUES (22, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680246239);
INSERT INTO `la_system_log_login` VALUES (23, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680325795);
INSERT INTO `la_system_log_login` VALUES (24, 2, 'ceshi', '127.0.0.1', 'Windows', 'Firefox', 1, 1680340640);
INSERT INTO `la_system_log_login` VALUES (25, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680340904);
INSERT INTO `la_system_log_login` VALUES (26, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680415387);
INSERT INTO `la_system_log_login` VALUES (27, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680507090);
INSERT INTO `la_system_log_login` VALUES (28, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680584322);
INSERT INTO `la_system_log_login` VALUES (29, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680693374);
INSERT INTO `la_system_log_login` VALUES (30, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680761915);
INSERT INTO `la_system_log_login` VALUES (31, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1680937791);
INSERT INTO `la_system_log_login` VALUES (32, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1681452279);
INSERT INTO `la_system_log_login` VALUES (33, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1681628773);
INSERT INTO `la_system_log_login` VALUES (34, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1681803484);
INSERT INTO `la_system_log_login` VALUES (35, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1681970408);
INSERT INTO `la_system_log_login` VALUES (36, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1682406189);
INSERT INTO `la_system_log_login` VALUES (37, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1682488100);
INSERT INTO `la_system_log_login` VALUES (38, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1682571890);
INSERT INTO `la_system_log_login` VALUES (39, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1683775205);
INSERT INTO `la_system_log_login` VALUES (40, 1, 'admin', '127.0.0.1', 'Unknown', 'Unknown', 1, 1683990617);
INSERT INTO `la_system_log_login` VALUES (41, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684058927);
INSERT INTO `la_system_log_login` VALUES (42, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684120238);
INSERT INTO `la_system_log_login` VALUES (43, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684209866);
INSERT INTO `la_system_log_login` VALUES (44, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684217774);
INSERT INTO `la_system_log_login` VALUES (45, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684226166);
INSERT INTO `la_system_log_login` VALUES (46, 1, 'admin', '127.0.0.1', 'Unknown', 'Unknown', 1, 1684304791);
INSERT INTO `la_system_log_login` VALUES (47, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684477184);
INSERT INTO `la_system_log_login` VALUES (48, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684641389);
INSERT INTO `la_system_log_login` VALUES (49, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684735345);
INSERT INTO `la_system_log_login` VALUES (50, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684735345);
INSERT INTO `la_system_log_login` VALUES (51, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684819684);
INSERT INTO `la_system_log_login` VALUES (52, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1684896330);
INSERT INTO `la_system_log_login` VALUES (53, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1685178833);
INSERT INTO `la_system_log_login` VALUES (54, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1685255514);
INSERT INTO `la_system_log_login` VALUES (55, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1685513224);
INSERT INTO `la_system_log_login` VALUES (56, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1685607801);
INSERT INTO `la_system_log_login` VALUES (57, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1685860401);
INSERT INTO `la_system_log_login` VALUES (58, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1685938143);
INSERT INTO `la_system_log_login` VALUES (59, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1686011311);
INSERT INTO `la_system_log_login` VALUES (60, 3, '123', '127.0.0.1', 'Windows', 'Firefox', 1, 1686011856);
INSERT INTO `la_system_log_login` VALUES (61, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1686011889);
INSERT INTO `la_system_log_login` VALUES (62, 3, '123', '127.0.0.1', 'Windows', 'Firefox', 1, 1686012094);
INSERT INTO `la_system_log_login` VALUES (63, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1686014883);
INSERT INTO `la_system_log_login` VALUES (64, 3, '123', '127.0.0.1', 'Windows', 'Firefox', 1, 1686016023);
INSERT INTO `la_system_log_login` VALUES (65, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1686016262);
INSERT INTO `la_system_log_login` VALUES (66, 1, 'admin', '127.0.0.1', 'Windows', 'Firefox', 1, 1686038510);

-- ----------------------------
-- Table structure for la_system_log_operate
-- ----------------------------
DROP TABLE IF EXISTS `la_system_log_operate`;
CREATE TABLE `la_system_log_operate`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人ID',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求类型: GET/POST/PUT',
  `title` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作标题',
  `ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求IP',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求接口',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求方法',
  `args` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '执行状态: 1=成功, 2=失败',
  `start_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始时间',
  `end_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  `task_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '执行耗时',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 368 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_log_operate
-- ----------------------------
INSERT INTO `la_system_log_operate` VALUES (1, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1677421549, 1677421550, 169, 1677421550);
INSERT INTO `la_system_log_operate` VALUES (2, 1, 'POST', '管理员新增', '127.0.0.1', '/api/system/admin/add', 'com.mdd.admin.controller.system.SystemAuthAdminController.add()', '[{\"avatar\":\"\",\"deptIds\":[],\"isDisable\":0,\"isMultipoint\":1,\"nickname\":\"测试号\",\"password\":\"123456\",\"postIds\":[],\"roleIds\":[1],\"sort\":0,\"username\":\"ceshi\"}]', '', 1, 1678324916, 1678324916, 128, 1678324916);
INSERT INTO `la_system_log_operate` VALUES (3, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1678324941, 1678324941, 11, 1678324941);
INSERT INTO `la_system_log_operate` VALUES (4, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=1', '', 1, 1678324954, 1678324954, 9, 1678324954);
INSERT INTO `la_system_log_operate` VALUES (5, 1, 'POST', '角色编辑', '127.0.0.1', '/api/system/role/edit', 'com.mdd.admin.controller.system.SystemAuthRoleController.edit()', '[{\"id\":1,\"isDisable\":0,\"menuIds\":\"1,703,704,730,732,733,738,755,705,716,734,735,736,737,775,717,718,753,719,754,779\",\"name\":\"审核员\",\"remark\":\"审核数据\",\"sort\":0}]', '', 1, 1678324984, 1678324985, 247, 1678324985);
INSERT INTO `la_system_log_operate` VALUES (6, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1678324985, 1678324985, 5, 1678324985);
INSERT INTO `la_system_log_operate` VALUES (7, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"\",\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Burger\",\"menuName\":\"桌台管理\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"workbench\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678331552, 1678331552, 62, 1678331552);
INSERT INTO `la_system_log_operate` VALUES (8, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":789,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Burger\",\"menuName\":\"桌台管理\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"workben\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678331585, 1678331585, 160, 1678331585);
INSERT INTO `la_system_log_operate` VALUES (9, 1, 'POST', '菜单删除', '127.0.0.1', '/api/system/menu/del', 'com.mdd.admin.controller.system.SystemAuthMenuController.del()', '[{\"id\":789}]', '', 1, 1678331610, 1678331610, 166, 1678331610);
INSERT INTO `la_system_log_operate` VALUES (10, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":706,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Message\",\"menuName\":\"渠道设置\",\"menuSort\":46,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"channel\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678331735, 1678331736, 129, 1678331736);
INSERT INTO `la_system_log_operate` VALUES (11, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":712,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-User\",\"menuName\":\"用户管理\",\"menuSort\":48,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"consumer\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678331756, 1678331756, 128, 1678331756);
INSERT INTO `la_system_log_operate` VALUES (12, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/h5\",\"id\":707,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Cellphone\",\"menuName\":\"H5设置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"h5\",\"perms\":\"channel:h5:detail\",\"pid\":706,\"selected\":\"\"}]', '', 1, 1678331929, 1678331929, 211, 1678331929);
INSERT INTO `la_system_log_operate` VALUES (13, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":708,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"local-icon-dingdan\",\"menuName\":\"微信公众号\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"wx_oa\",\"perms\":\"\",\"pid\":706,\"selected\":\"\"}]', '', 1, 1678331935, 1678331935, 91, 1678331935);
INSERT INTO `la_system_log_operate` VALUES (14, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/weapp\",\"id\":710,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"local-icon-qudao_xiaochengxu\",\"menuName\":\"微信小程序\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"weapp\",\"perms\":\"channel:mp:detail\",\"pid\":706,\"selected\":\"\"}]', '', 1, 1678331942, 1678331942, 171, 1678331942);
INSERT INTO `la_system_log_operate` VALUES (15, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/wx_op\",\"id\":711,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"local-icon-weixin\",\"menuName\":\"微信开放平台\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"wx_op\",\"perms\":\"channel:op:detail\",\"pid\":706,\"selected\":\"\"}]', '', 1, 1678331947, 1678331947, 70, 1678331947);
INSERT INTO `la_system_log_operate` VALUES (16, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"consumer/lists/index\",\"id\":713,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-User\",\"menuName\":\"用户列表\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"lists\",\"perms\":\"user:list\",\"pid\":712,\"selected\":\"\"}]', '', 1, 1678332035, 1678332036, 286, 1678332036);
INSERT INTO `la_system_log_operate` VALUES (17, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"consumer/lists/detail\",\"id\":739,\"isCache\":0,\"isDisable\":1,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"用户详情\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"detail\",\"perms\":\"user:detail\",\"pid\":712,\"selected\":\"/consumer/lists\"}]', '', 1, 1678332046, 1678332046, 184, 1678332046);
INSERT INTO `la_system_log_operate` VALUES (18, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/wx_oa/config\",\"id\":709,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"公众号配置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"config\",\"perms\":\"channel:oa:detail\",\"pid\":708,\"selected\":\"\"}]', '', 1, 1678332106, 1678332107, 608, 1678332107);
INSERT INTO `la_system_log_operate` VALUES (19, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/wx_oa/menu\",\"id\":748,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"菜单管理\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"menu\",\"perms\":\"channel:oaMenu:detail\",\"pid\":708,\"selected\":\"\"}]', '', 1, 1678332114, 1678332114, 216, 1678332114);
INSERT INTO `la_system_log_operate` VALUES (20, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/wx_oa/reply/follow_reply\",\"id\":750,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"关注回复\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"follow\",\"perms\":\"channel:oaReplyFollow:list\",\"pid\":708,\"selected\":\"\"}]', '', 1, 1678332119, 1678332119, 105, 1678332119);
INSERT INTO `la_system_log_operate` VALUES (21, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/wx_oa/reply/keyword_reply\",\"id\":751,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"关键字回复\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"keyword\",\"perms\":\"channel:oaReplyKeyword:list\",\"pid\":708,\"selected\":\"\"}]', '', 1, 1678332125, 1678332125, 112, 1678332125);
INSERT INTO `la_system_log_operate` VALUES (22, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"channel/wx_oa/reply/default_reply\",\"id\":752,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"默认回复\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"default\",\"perms\":\"channel:oaReplyDefault:list\",\"pid\":708,\"selected\":\"\"}]', '', 1, 1678332131, 1678332131, 88, 1678332131);
INSERT INTO `la_system_log_operate` VALUES (23, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":780,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-SetUp\",\"menuName\":\"模板\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"template\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678332216, 1678332217, 547, 1678332217);
INSERT INTO `la_system_log_operate` VALUES (24, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":781,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Coin\",\"menuName\":\"组件示例\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"component\",\"perms\":\"\",\"pid\":780,\"selected\":\"\"}]', '', 1, 1678332221, 1678332221, 153, 1678332221);
INSERT INTO `la_system_log_operate` VALUES (25, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/rich_text\",\"id\":782,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"富文本\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"rich_text\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332251, 1678332251, 284, 1678332251);
INSERT INTO `la_system_log_operate` VALUES (26, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/upload\",\"id\":783,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"上传文件\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"upload\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332257, 1678332257, 166, 1678332257);
INSERT INTO `la_system_log_operate` VALUES (27, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/icon\",\"id\":784,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"图标\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"icon\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332262, 1678332262, 81, 1678332262);
INSERT INTO `la_system_log_operate` VALUES (28, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/file\",\"id\":785,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"文件选择器\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"file\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332266, 1678332266, 130, 1678332266);
INSERT INTO `la_system_log_operate` VALUES (29, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/link\",\"id\":786,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"链接选择器\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"link\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332270, 1678332271, 394, 1678332271);
INSERT INTO `la_system_log_operate` VALUES (30, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/overflow\",\"id\":787,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"超出自动打点\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"overflow\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332275, 1678332275, 155, 1678332275);
INSERT INTO `la_system_log_operate` VALUES (31, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"template/component/popover_input\",\"id\":788,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"悬浮input\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"popover_input\",\"perms\":\"\",\"pid\":781,\"selected\":\"\"}]', '', 1, 1678332279, 1678332279, 165, 1678332279);
INSERT INTO `la_system_log_operate` VALUES (32, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1678362060, 1678362060, 37, 1678362060);
INSERT INTO `la_system_log_operate` VALUES (33, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"workbench/index\",\"id\":1,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"local-icon-shuju_liuliang\",\"menuName\":\"概况\",\"menuSort\":50,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"workbench\",\"perms\":\"index:console\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678364773, 1678364773, 132, 1678364773);
INSERT INTO `la_system_log_operate` VALUES (34, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"order/index\",\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Monitor\",\"menuName\":\"点餐台\",\"menuSort\":49,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order\",\"perms\":\"order:index\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678365242, 1678365242, 302, 1678365242);
INSERT INTO `la_system_log_operate` VALUES (35, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":703,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-ChatLineSquare\",\"menuName\":\"文章资讯\",\"menuSort\":48,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"article\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678365253, 1678365253, 220, 1678365253);
INSERT INTO `la_system_log_operate` VALUES (36, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', NULL, 2, 1678774430, 1678774430, 14, 1678774430);
INSERT INTO `la_system_log_operate` VALUES (37, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', NULL, 2, 1678774736, 1678774736, 18, 1678774736);
INSERT INTO `la_system_log_operate` VALUES (38, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', NULL, 2, 1678775245, 1678775245, 7, 1678775245);
INSERT INTO `la_system_log_operate` VALUES (39, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', NULL, 2, 1678775318, 1678775318, 7, 1678775318);
INSERT INTO `la_system_log_operate` VALUES (40, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', NULL, 2, 1678775406, 1678775406, 5, 1678775406);
INSERT INTO `la_system_log_operate` VALUES (41, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', '', 1, 1678775526, 1678775527, 301, 1678775527);
INSERT INTO `la_system_log_operate` VALUES (42, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[1]}]', '', 1, 1678775974, 1678775975, 245, 1678775975);
INSERT INTO `la_system_log_operate` VALUES (43, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'QQ截图20221003171235.png', NULL, 2, 1678776114, 1678776115, 1549, 1678776115);
INSERT INTO `la_system_log_operate` VALUES (44, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '002.png', NULL, 2, 1678776238, 1678776239, 481, 1678776239);
INSERT INTO `la_system_log_operate` VALUES (45, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '002.png', NULL, 2, 1678776510, 1678776511, 400, 1678776511);
INSERT INTO `la_system_log_operate` VALUES (46, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '002.png', '', 1, 1678777683, 1678777684, 783, 1678777684);
INSERT INTO `la_system_log_operate` VALUES (47, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1678788110, 1678788110, 118, 1678788110);
INSERT INTO `la_system_log_operate` VALUES (48, 1, 'POST', '菜单删除', '127.0.0.1', '/api/system/menu/del', 'com.mdd.admin.controller.system.SystemAuthMenuController.del()', '[{\"id\":777}]', '', 1, 1678865364, 1678865364, 286, 1678865364);
INSERT INTO `la_system_log_operate` VALUES (49, 1, 'POST', '菜单删除', '127.0.0.1', '/api/system/menu/del', 'com.mdd.admin.controller.system.SystemAuthMenuController.del()', '[{\"id\":776}]', '', 1, 1678865368, 1678865368, 162, 1678865368);
INSERT INTO `la_system_log_operate` VALUES (50, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":703,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-ChatLineSquare\",\"menuName\":\"菜品管理\",\"menuSort\":48,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"article\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1678870150, 1678870150, 462, 1678870150);
INSERT INTO `la_system_log_operate` VALUES (51, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":2}]', '', 1, 1678870167, 1678870168, 257, 1678870168);
INSERT INTO `la_system_log_operate` VALUES (52, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":2}]', '', 1, 1678870169, 1678870170, 158, 1678870170);
INSERT INTO `la_system_log_operate` VALUES (53, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"article/lists/index\",\"id\":704,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-ChatDotSquare\",\"menuName\":\"菜品列表\",\"menuSort\":3,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"lists\",\"perms\":\"article:list\",\"pid\":703,\"selected\":\"\"}]', '', 1, 1678870200, 1678870201, 346, 1678870201);
INSERT INTO `la_system_log_operate` VALUES (54, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"article/column/index\",\"id\":705,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-CollectionTag\",\"menuName\":\"菜品分类\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"column\",\"perms\":\"article:cate:list\",\"pid\":703,\"selected\":\"\"}]', '', 1, 1678870216, 1678870216, 157, 1678870216);
INSERT INTO `la_system_log_operate` VALUES (55, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"\",\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"order:console\",\"pid\":790,\"selected\":\"\"}]', '', 1, 1679144490, 1679144491, 227, 1679144491);
INSERT INTO `la_system_log_operate` VALUES (56, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"order/console\",\"id\":791,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/console\",\"perms\":\"order:console\",\"pid\":790,\"selected\":\"\"}]', '', 1, 1679144958, 1679144958, 553, 1679144958);
INSERT INTO `la_system_log_operate` VALUES (57, 1, 'POST', '菜单删除', '127.0.0.1', '/api/system/menu/del', 'com.mdd.admin.controller.system.SystemAuthMenuController.del()', '[{\"id\":791}]', '', 1, 1679145298, 1679145298, 677, 1679145298);
INSERT INTO `la_system_log_operate` VALUES (58, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"order/console\",\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/console\",\"perms\":\"order:console\",\"pid\":790,\"selected\":\"\"}]', '', 1, 1679145380, 1679145380, 318, 1679145380);
INSERT INTO `la_system_log_operate` VALUES (59, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"order/console\",\"id\":792,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/console\",\"perms\":\"order:console\",\"pid\":790,\"selected\":\"order\"}]', '', 1, 1679145479, 1679145479, 503, 1679145479);
INSERT INTO `la_system_log_operate` VALUES (60, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"order/index\",\"id\":790,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Monitor\",\"menuName\":\"点餐台\",\"menuSort\":49,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/index\",\"perms\":\"order:index\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679145658, 1679145658, 297, 1679145658);
INSERT INTO `la_system_log_operate` VALUES (61, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"order/console\",\"id\":792,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/console\",\"perms\":\"order:console\",\"pid\":790,\"selected\":\"/order/index\"}]', '', 1, 1679145831, 1679145831, 250, 1679145831);
INSERT INTO `la_system_log_operate` VALUES (62, 1, 'POST', '菜单删除', '127.0.0.1', '/api/system/menu/del', 'com.mdd.admin.controller.system.SystemAuthMenuController.del()', '[{\"id\":792}]', '', 1, 1679145939, 1679145940, 568, 1679145940);
INSERT INTO `la_system_log_operate` VALUES (63, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"order/console\",\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/console\",\"perms\":\"order:console\",\"pid\":0,\"selected\":\"order/index\"}]', '', 1, 1679146015, 1679146016, 571, 1679146016);
INSERT INTO `la_system_log_operate` VALUES (64, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"order/console\",\"id\":793,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"点餐\",\"menuSort\":49,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"order/console\",\"perms\":\"order:console\",\"pid\":0,\"selected\":\"order/index\"}]', '', 1, 1679146030, 1679146030, 425, 1679146030);
INSERT INTO `la_system_log_operate` VALUES (65, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":130,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-KnifeFork\",\"menuName\":\"餐桌管理\",\"menuSort\":45,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"organization\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679296817, 1679296818, 598, 1679296818);
INSERT INTO `la_system_log_operate` VALUES (66, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"organization/department/index\",\"id\":131,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-SetUp\",\"menuName\":\"桌号设置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"department\",\"perms\":\"system:dept:list\",\"pid\":130,\"selected\":\"\"}]', '', 1, 1679296921, 1679296921, 616, 1679296921);
INSERT INTO `la_system_log_operate` VALUES (67, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"organization/post/index\",\"id\":140,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-More\",\"menuName\":\"分类管理\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"post\",\"perms\":\"system:post:list\",\"pid\":130,\"selected\":\"\"}]', '', 1, 1679297046, 1679297047, 535, 1679297047);
INSERT INTO `la_system_log_operate` VALUES (68, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":130,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-KnifeFork\",\"menuName\":\"餐桌管理\",\"menuSort\":48,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"organization\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679297110, 1679297111, 153, 1679297111);
INSERT INTO `la_system_log_operate` VALUES (69, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":717,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Brush\",\"menuName\":\"装修管理\",\"menuSort\":46,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"decoration\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679297143, 1679297144, 255, 1679297144);
INSERT INTO `la_system_log_operate` VALUES (70, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":130,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-KnifeFork\",\"menuName\":\"餐桌管理\",\"menuSort\":47,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"organization\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679297152, 1679297153, 177, 1679297153);
INSERT INTO `la_system_log_operate` VALUES (71, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"\",\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Tickets\",\"menuName\":\"订单管理\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"orders\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679308510, 1679308511, 539, 1679308511);
INSERT INTO `la_system_log_operate` VALUES (72, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":794,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Tickets\",\"menuName\":\"订单管理\",\"menuSort\":45,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"orders\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1679308531, 1679308532, 198, 1679308532);
INSERT INTO `la_system_log_operate` VALUES (73, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"orders/orderList\",\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-CreditCard\",\"menuName\":\"订单列表\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"orderList\",\"perms\":\"orders:orderList\",\"pid\":794,\"selected\":\"orders\"}]', '', 1, 1679308751, 1679308751, 137, 1679308751);
INSERT INTO `la_system_log_operate` VALUES (74, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"organization/post/index\",\"id\":140,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-More\",\"menuName\":\"区域管理\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"post\",\"perms\":\"system:post:list\",\"pid\":130,\"selected\":\"\"}]', '', 1, 1679308994, 1679308995, 475, 1679308995);
INSERT INTO `la_system_log_operate` VALUES (75, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', NULL, 2, 1679548918, 1679548918, 18, 1679548918);
INSERT INTO `la_system_log_operate` VALUES (76, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"0.0\",\"cid\":1,\"content\":\"<p>balblbnlbnlbnlb</p>\",\"image\":\"http://127.0.0.1:8082/api/uploads/image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介\",\"isShow\":1,\"sort\":0,\"summary\":\"没有\",\"title\":\"测试一下\",\"visit\":0}]', '', 1, 1679548943, 1679548943, 155, 1679548943);
INSERT INTO `la_system_log_operate` VALUES (77, 1, 'POST', '文章删除', '127.0.0.1', '/api/article/del', 'com.mdd.admin.controller.ArticleController.del()', '[{\"id\":4}]', '', 1, 1679562938, 1679562939, 582, 1679562939);
INSERT INTO `la_system_log_operate` VALUES (78, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":2}]', '', 1, 1680081543, 1680081544, 156, 1680081544);
INSERT INTO `la_system_log_operate` VALUES (79, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":2}]', '', 1, 1680081545, 1680081545, 71, 1680081545);
INSERT INTO `la_system_log_operate` VALUES (80, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"dish/lists/index\",\"id\":704,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-ChatDotSquare\",\"menuName\":\"菜品列表\",\"menuSort\":3,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"lists\",\"perms\":\"dish:list\",\"pid\":703,\"selected\":\"\"}]', '', 1, 1680177177, 1680177177, 156, 1680177177);
INSERT INTO `la_system_log_operate` VALUES (81, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"dish/column/index\",\"id\":705,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-CollectionTag\",\"menuName\":\"菜品分类\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"column\",\"perms\":\"dish:cate:list\",\"pid\":703,\"selected\":\"\"}]', '', 1, 1680177339, 1680177340, 565, 1680177340);
INSERT INTO `la_system_log_operate` VALUES (82, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"dish/lists/edit\",\"id\":775,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"菜品添加/编辑\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"lists/edit\",\"perms\":\"dish:add/edit\",\"pid\":703,\"selected\":\"/dish/lists\"}]', '', 1, 1680177382, 1680177382, 364, 1680177382);
INSERT INTO `la_system_log_operate` VALUES (83, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":730,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"文章新增\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:add\",\"pid\":704,\"selected\":\"\"}]', '', 1, 1680177391, 1680177392, 159, 1680177392);
INSERT INTO `la_system_log_operate` VALUES (84, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":733,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"文章状态\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:change\",\"pid\":704,\"selected\":\"\"}]', '', 1, 1680177397, 1680177398, 180, 1680177398);
INSERT INTO `la_system_log_operate` VALUES (85, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"article/lists/edit\",\"id\":738,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"文章编辑\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"lists/edit\",\"perms\":\"dish:edit\",\"pid\":704,\"selected\":\"\"}]', '', 1, 1680177403, 1680177403, 160, 1680177403);
INSERT INTO `la_system_log_operate` VALUES (86, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":755,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"文章详情\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:detail\",\"pid\":704,\"selected\":\"\"}]', '', 1, 1680177414, 1680177414, 225, 1680177414);
INSERT INTO `la_system_log_operate` VALUES (87, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"article/lists/edit\",\"id\":716,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"栏目详情\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"lists/edit\",\"perms\":\"dish:cate:detail\",\"pid\":705,\"selected\":\"/article/lists\"}]', '', 1, 1680177426, 1680177426, 288, 1680177426);
INSERT INTO `la_system_log_operate` VALUES (88, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":734,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"栏目新增\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:cate:add\",\"pid\":705,\"selected\":\"\"}]', '', 1, 1680177431, 1680177431, 80, 1680177431);
INSERT INTO `la_system_log_operate` VALUES (89, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":735,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"栏目编辑\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:cate:edit\",\"pid\":705,\"selected\":\"\"}]', '', 1, 1680177438, 1680177438, 180, 1680177438);
INSERT INTO `la_system_log_operate` VALUES (90, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":736,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"栏目删除\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:cate:del\",\"pid\":705,\"selected\":\"\"}]', '', 1, 1680177444, 1680177444, 156, 1680177444);
INSERT INTO `la_system_log_operate` VALUES (91, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":737,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"栏目状态\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"dish:cate:change\",\"pid\":705,\"selected\":\"\"}]', '', 1, 1680177450, 1680177450, 168, 1680177450);
INSERT INTO `la_system_log_operate` VALUES (92, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":703,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-ChatLineSquare\",\"menuName\":\"菜品管理\",\"menuSort\":48,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"dish\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1680177680, 1680177681, 187, 1680177681);
INSERT INTO `la_system_log_operate` VALUES (93, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":130,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-KnifeFork\",\"menuName\":\"餐桌管理\",\"menuSort\":47,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"board\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1680178075, 1680178076, 227, 1680178076);
INSERT INTO `la_system_log_operate` VALUES (94, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"board/number/index\",\"id\":131,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-SetUp\",\"menuName\":\"桌号设置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"board\",\"perms\":\"system:board:list\",\"pid\":130,\"selected\":\"\"}]', '', 1, 1680178130, 1680178130, 155, 1680178130);
INSERT INTO `la_system_log_operate` VALUES (95, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"board/area/index\",\"id\":140,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-More\",\"menuName\":\"区域管理\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"area\",\"perms\":\"system:area:list\",\"pid\":130,\"selected\":\"\"}]', '', 1, 1680178173, 1680178174, 590, 1680178174);
INSERT INTO `la_system_log_operate` VALUES (96, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":132,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"部门详情\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:board:detail\",\"pid\":131,\"selected\":\"\"}]', '', 1, 1680178192, 1680178193, 214, 1680178193);
INSERT INTO `la_system_log_operate` VALUES (97, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":133,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"部门新增\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:board:add\",\"pid\":131,\"selected\":\"\"}]', '', 1, 1680178198, 1680178198, 154, 1680178198);
INSERT INTO `la_system_log_operate` VALUES (98, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"board/number/index\",\"id\":131,\"isCache\":1,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-SetUp\",\"menuName\":\"桌号设置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"number\",\"perms\":\"system:number:list\",\"pid\":130,\"selected\":\"\"}]', '', 1, 1680178231, 1680178231, 190, 1680178231);
INSERT INTO `la_system_log_operate` VALUES (99, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":132,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"部门详情\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:number:detail\",\"pid\":131,\"selected\":\"\"}]', '', 1, 1680178237, 1680178238, 162, 1680178238);
INSERT INTO `la_system_log_operate` VALUES (100, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":133,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"部门新增\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:number:add\",\"pid\":131,\"selected\":\"\"}]', '', 1, 1680178242, 1680178242, 172, 1680178242);
INSERT INTO `la_system_log_operate` VALUES (101, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":134,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"部门编辑\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:number:edit\",\"pid\":131,\"selected\":\"\"}]', '', 1, 1680178247, 1680178247, 169, 1680178247);
INSERT INTO `la_system_log_operate` VALUES (102, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":135,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"部门删除\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:number:del\",\"pid\":131,\"selected\":\"\"}]', '', 1, 1680178252, 1680178252, 164, 1680178252);
INSERT INTO `la_system_log_operate` VALUES (103, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":141,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"岗位详情\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:area:detail\",\"pid\":140,\"selected\":\"\"}]', '', 1, 1680178279, 1680178279, 209, 1680178279);
INSERT INTO `la_system_log_operate` VALUES (104, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":142,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"岗位新增\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:area:add\",\"pid\":140,\"selected\":\"\"}]', '', 1, 1680178291, 1680178291, 183, 1680178291);
INSERT INTO `la_system_log_operate` VALUES (105, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":143,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"岗位编辑\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:area:edit\",\"pid\":140,\"selected\":\"\"}]', '', 1, 1680178296, 1680178296, 62, 1680178296);
INSERT INTO `la_system_log_operate` VALUES (106, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":144,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"岗位删除\",\"menuSort\":0,\"menuType\":\"A\",\"params\":\"\",\"paths\":\"\",\"perms\":\"system:area:del\",\"pid\":140,\"selected\":\"\"}]', '', 1, 1680178300, 1680178300, 98, 1680178300);
INSERT INTO `la_system_log_operate` VALUES (107, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"orders/list\",\"id\":795,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-CreditCard\",\"menuName\":\"订单列表\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"list\",\"perms\":\"orders:list\",\"pid\":794,\"selected\":\"\"}]', '', 1, 1680178390, 1680178391, 528, 1680178391);
INSERT INTO `la_system_log_operate` VALUES (108, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '2[OYW7C(IG`RE9@9JOWDF6Y.jpg', '', 1, 1680254553, 1680254559, 6194, 1680254559);
INSERT INTO `la_system_log_operate` VALUES (109, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[3]}]', '', 1, 1680333316, 1680333316, 324, 1680333316);
INSERT INTO `la_system_log_operate` VALUES (110, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', '', 1, 1680336300, 1680336301, 1494, 1680336301);
INSERT INTO `la_system_log_operate` VALUES (111, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[4]}]', '', 1, 1680336313, 1680336313, 272, 1680336313);
INSERT INTO `la_system_log_operate` VALUES (112, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', '', 1, 1680336740, 1680336740, 451, 1680336740);
INSERT INTO `la_system_log_operate` VALUES (113, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '2[OYW7C(IG`RE9@9JOWDF6Y.jpg', '', 1, 1680336754, 1680336755, 976, 1680336755);
INSERT INTO `la_system_log_operate` VALUES (114, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[6]}]', '', 1, 1680337358, 1680337359, 354, 1680337359);
INSERT INTO `la_system_log_operate` VALUES (115, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[5]}]', '', 1, 1680337361, 1680337362, 75, 1680337362);
INSERT INTO `la_system_log_operate` VALUES (116, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'ba.png', '', 1, 1680337364, 1680337365, 776, 1680337365);
INSERT INTO `la_system_log_operate` VALUES (117, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'QQ截图20220330172216.png', '', 1, 1680337436, 1680337437, 1037, 1680337437);
INSERT INTO `la_system_log_operate` VALUES (118, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '一亿像素中国地图.jpg', '', 1, 1680337474, 1680337477, 2828, 1680337477);
INSERT INTO `la_system_log_operate` VALUES (119, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[9]}]', '', 1, 1680337507, 1680337507, 210, 1680337507);
INSERT INTO `la_system_log_operate` VALUES (120, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[8]}]', '', 1, 1680337510, 1680337510, 65, 1680337510);
INSERT INTO `la_system_log_operate` VALUES (121, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[7]}]', '', 1, 1680337512, 1680337512, 87, 1680337512);
INSERT INTO `la_system_log_operate` VALUES (122, 1, 'POST', '管理员更新', '127.0.0.1', '/api/system/admin/upInfo', 'com.mdd.admin.controller.system.SystemAuthAdminController.upInfo()', '[{\"avatar\":\"http://qiniu.52yhqw.top/image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"currPassword\":\"\",\"nickname\":\"admin\",\"password\":\"\"}]', '', 1, 1680340967, 1680340967, 160, 1680340967);
INSERT INTO `la_system_log_operate` VALUES (123, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"凉菜\",\"sort\":0}]', '', 1, 1680420017, 1680420017, 233, 1680420017);
INSERT INTO `la_system_log_operate` VALUES (124, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"热菜\",\"sort\":0}]', '', 1, 1680420022, 1680420022, 202, 1680420022);
INSERT INTO `la_system_log_operate` VALUES (125, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"肉菜\",\"sort\":0}]', '', 1, 1680420026, 1680420026, 165, 1680420026);
INSERT INTO `la_system_log_operate` VALUES (126, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"烧烤系列\",\"sort\":0}]', '', 1, 1680420032, 1680420033, 166, 1680420033);
INSERT INTO `la_system_log_operate` VALUES (127, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":6,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是一个黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋\",\"isShow\":1,\"sort\":0,\"summary\":\"666\",\"title\":\"黄瓜炒鸡蛋\",\"visit\":0}]', '', 1, 1680420146, 1680420146, 226, 1680420146);
INSERT INTO `la_system_log_operate` VALUES (128, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'QQ截图20220330172216.png', '', 1, 1680529277, 1680529279, 1818, 1680529279);
INSERT INTO `la_system_log_operate` VALUES (129, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":4,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230403/9808920f-73a0-4218-bd13-0ed4e8376772.png\",\"intro\":\"就是西红柿炒鸡蛋\",\"isShow\":1,\"sort\":0,\"summary\":\"999\",\"title\":\"西红柿炒鸡蛋\",\"visit\":0}]', '', 1, 1680529284, 1680529284, 93, 1680529284);
INSERT INTO `la_system_log_operate` VALUES (130, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '017be761222ef211013eaf70aab03c.jpg', '', 1, 1680621799, 1680621801, 1559, 1680621801);
INSERT INTO `la_system_log_operate` VALUES (131, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'u=3794021449,3553549761&fm=253&fmt=auto&app=138&f=JPEG.webp', NULL, 2, 1680621813, 1680621813, 5, 1680621813);
INSERT INTO `la_system_log_operate` VALUES (132, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '01743b5c2db88aa8012029ac7d92b2.jpg@1280w_1l_2o_100sh.jpg', '', 1, 1680621823, 1680621823, 774, 1680621823);
INSERT INTO `la_system_log_operate` VALUES (133, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":3,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230404/3c3675e9-1df6-4bc0-89b6-0a233770afe3.jpg\",\"intro\":\"好吃的凉菜\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"清香凉菜\",\"visit\":0}]', '', 1, 1680621860, 1680621860, 243, 1680621860);
INSERT INTO `la_system_log_operate` VALUES (134, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":4,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230404/1cbb9b93-22be-4fbd-9758-ccd0198f760c.jpg\",\"intro\":\"红烧肉啊\",\"isShow\":1,\"sort\":0,\"summary\":\"688\",\"title\":\"红烧肉\",\"visit\":0}]', '', 1, 1680621961, 1680621961, 202, 1680621961);
INSERT INTO `la_system_log_operate` VALUES (135, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'a85fddc2519f4ab785e55fbd791dd90a_1125w_1455h.jpg', '', 1, 1680622187, 1680622187, 410, 1680622187);
INSERT INTO `la_system_log_operate` VALUES (136, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":4,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230404/da5235ff-ea93-4b6e-969a-2c43d9eb4c91.jpg\",\"intro\":\"这是个爆炒鱿鱼\",\"isShow\":1,\"sort\":0,\"summary\":\"222\",\"title\":\"爆炒鱿鱼\",\"visit\":0}]', '', 1, 1680622210, 1680622210, 256, 1680622210);
INSERT INTO `la_system_log_operate` VALUES (137, 1, 'POST', '菜单删除', '127.0.0.1', '/api/system/menu/del', 'com.mdd.admin.controller.system.SystemAuthMenuController.del()', '[{\"id\":793}]', '', 1, 1680762738, 1680762739, 284, 1680762739);
INSERT INTO `la_system_log_operate` VALUES (138, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'u=3794021449,3553549761&fm=253&fmt=auto&app=138&f=JPEG.jpeg', '', 1, 1680763947, 1680763969, 21783, 1680763969);
INSERT INTO `la_system_log_operate` VALUES (139, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"\",\"cid\":4,\"content\":\"\",\"id\":6,\"image\":\"http://qiniu.52yhqw.top/image/20230406/be5490cf-72b6-4dd8-9b10-88fa39e11b0e.jpeg\",\"intro\":\"就是西红柿炒鸡蛋\",\"isShow\":1,\"sort\":0,\"summary\":\"999\",\"title\":\"西红柿炒鸡蛋\",\"visit\":0}]', '', 1, 1680763976, 1680763976, 167, 1680763976);
INSERT INTO `la_system_log_operate` VALUES (140, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (6).jpeg', '', 1, 1680764080, 1680764081, 388, 1680764081);
INSERT INTO `la_system_log_operate` VALUES (141, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"\",\"cid\":6,\"content\":\"\",\"id\":5,\"image\":\"http://qiniu.52yhqw.top/image/20230406/69d2d96e-f023-4806-aa22-56994f43cb64.jpeg\",\"intro\":\"这是一个黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋黄瓜炒鸡蛋\",\"isShow\":1,\"sort\":0,\"summary\":\"666\",\"title\":\"黄瓜炒鸡蛋\",\"visit\":0}]', '', 1, 1680764089, 1680764089, 158, 1680764089);
INSERT INTO `la_system_log_operate` VALUES (142, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (2).jpeg', '', 1, 1680764100, 1680764100, 393, 1680764100);
INSERT INTO `la_system_log_operate` VALUES (143, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":4,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230406/60b7fb06-c7a2-40cc-ba4e-debcfb9cc25e.jpeg\",\"intro\":\"这是个油闷大虾\",\"isShow\":1,\"sort\":0,\"summary\":\"20\",\"title\":\"油闷大虾\",\"visit\":0}]', '', 1, 1680764150, 1680764150, 148, 1680764150);
INSERT INTO `la_system_log_operate` VALUES (144, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (3).jpeg', '', 1, 1680764196, 1680764196, 449, 1680764196);
INSERT INTO `la_system_log_operate` VALUES (145, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":4,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230406/e835893b-3f60-41f2-aaa7-a5a79104946c.jpeg\",\"intro\":\"这是个春卷\",\"isShow\":1,\"sort\":0,\"summary\":\"50\",\"title\":\"春卷\",\"visit\":0}]', '', 1, 1680764201, 1680764201, 66, 1680764201);
INSERT INTO `la_system_log_operate` VALUES (146, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1680938437, 1680938437, 74, 1680938437);
INSERT INTO `la_system_log_operate` VALUES (147, 1, 'POST', '角色新增', '127.0.0.1', '/api/system/role/add', 'com.mdd.admin.controller.system.SystemAuthRoleController.add()', '[{\"isDisable\":0,\"menuIds\":\"\",\"name\":\"商户\",\"remark\":\"\",\"sort\":0}]', '', 1, 1680938448, 1680938448, 230, 1680938448);
INSERT INTO `la_system_log_operate` VALUES (148, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1680938448, 1680938448, 6, 1680938448);
INSERT INTO `la_system_log_operate` VALUES (149, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1680938454, 1680938454, 99, 1680938454);
INSERT INTO `la_system_log_operate` VALUES (150, 1, 'POST', '角色编辑', '127.0.0.1', '/api/system/role/edit', 'com.mdd.admin.controller.system.SystemAuthRoleController.edit()', '[{\"id\":2,\"isDisable\":0,\"menuIds\":\"1,790,703,704,730,732,733,738,755,705,716,734,735,736,737,775,130,131,132,133,134,135,140,141,142,143,144,717,718,753,719,754,779,794,795,700,701\",\"name\":\"商户\",\"remark\":\"\",\"sort\":0}]', '', 1, 1680938482, 1680938482, 487, 1680938482);
INSERT INTO `la_system_log_operate` VALUES (151, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1680938482, 1680938482, 8, 1680938482);
INSERT INTO `la_system_log_operate` VALUES (152, 1, 'POST', '管理员编辑', '127.0.0.1', '/api/system/admin/edit', 'com.mdd.admin.controller.system.SystemAuthAdminController.edit()', '[{\"avatar\":\"http://127.0.0.1:8082/api/static/backend_avatar.png\",\"deptIds\":[],\"id\":2,\"isDisable\":0,\"isMultipoint\":1,\"nickname\":\"测试号\",\"password\":\"\",\"postIds\":[],\"roleIds\":[2],\"sort\":0,\"username\":\"ceshi\"}]', '', 1, 1680938535, 1680938536, 592, 1680938536);
INSERT INTO `la_system_log_operate` VALUES (153, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'u=2073211799,3375406234&fm=253&fmt=auto&app=138&f=JPEG (1).jpeg', '', 1, 1680948092, 1680948093, 1053, 1680948093);
INSERT INTO `la_system_log_operate` VALUES (154, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":5,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230408/27d0bc3d-05b2-42dc-a9b3-79b97d9ebda8.jpeg\",\"intro\":\"大肘子大肘子\",\"isShow\":1,\"sort\":0,\"summary\":\"500\",\"title\":\"肘子\",\"visit\":0}]', '', 1, 1680948098, 1680948098, 187, 1680948098);
INSERT INTO `la_system_log_operate` VALUES (155, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":717,\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Brush\",\"menuName\":\"店铺管理\",\"menuSort\":46,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"decoration\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1683775411, 1683775411, 148, 1683775411);
INSERT INTO `la_system_log_operate` VALUES (156, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1683775904, 1683775904, 45, 1683775904);
INSERT INTO `la_system_log_operate` VALUES (157, 1, 'POST', '角色删除', '127.0.0.1', '/api/system/role/del', 'com.mdd.admin.controller.system.SystemAuthRoleController.del()', '[{\"id\":1}]', '\r\n### Error querying database.  Cause: com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: Unknown column \'role\' in \'field list\'\r\n### The error may exist in com/mdd/common/mapper/system/SystemAuthAdminMapper.java (best guess)\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT     id,role,nickname     FROM la_system_auth_admin           WHERE (role = ? AND is_delete = ?)\r\n### Cause: com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: Unknown column \'role\' in \'field list\'\n; bad SQL grammar []; nested exception is com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: Unknown column \'role\' in \'field list\'', 2, 1683775910, 1683775910, 288, 1683775910);
INSERT INTO `la_system_log_operate` VALUES (158, 1, 'POST', '角色删除', '127.0.0.1', '/api/system/role/del', 'com.mdd.admin.controller.system.SystemAuthRoleController.del()', '[{\"id\":1}]', '', 1, 1683776408, 1683776409, 478, 1683776409);
INSERT INTO `la_system_log_operate` VALUES (159, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1683776409, 1683776409, 48, 1683776409);
INSERT INTO `la_system_log_operate` VALUES (160, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1683776586, 1683776586, 27, 1683776586);
INSERT INTO `la_system_log_operate` VALUES (161, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', 'backend_backdrop.png', '', 1, 1684138998, 1684138999, 1115, 1684138999);
INSERT INTO `la_system_log_operate` VALUES (162, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"shop/info\",\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Setting\",\"menuName\":\"店铺设置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"shop/info\",\"perms\":\"shop:info\",\"pid\":717,\"selected\":\"\"}]', '', 1, 1684141210, 1684141210, 104, 1684141211);
INSERT INTO `la_system_log_operate` VALUES (163, 1, 'POST', '菜单新增', '127.0.0.1', '/api/system/menu/add', 'com.mdd.admin.controller.system.SystemAuthMenuController.add()', '[{\"component\":\"shop/print/index\",\"isCache\":0,\"isDisable\":0,\"isShow\":1,\"menuIcon\":\"el-icon-Printer\",\"menuName\":\"小票打印机\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"print\",\"perms\":\"shop:print:index\",\"pid\":717,\"selected\":\"\"}]', '', 1, 1684141298, 1684141298, 185, 1684141298);
INSERT INTO `la_system_log_operate` VALUES (164, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"decoration/pages/index\",\"id\":718,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-CopyDocument\",\"menuName\":\"页面装修\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"pages\",\"perms\":\"decorate:pages:detail\",\"pid\":717,\"selected\":\"\"}]', '', 1, 1684215845, 1684215845, 159, 1684215845);
INSERT INTO `la_system_log_operate` VALUES (165, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"decoration/tabbar\",\"id\":719,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Position\",\"menuName\":\"底部导航\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"tabbar\",\"perms\":\"decorate:tabbar:detail\",\"pid\":717,\"selected\":\"\"}]', '', 1, 1684215868, 1684215868, 124, 1684215868);
INSERT INTO `la_system_log_operate` VALUES (166, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"decoration/pc\",\"id\":779,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Monitor\",\"menuName\":\"PC端\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"pc\",\"perms\":\"\",\"pid\":717,\"selected\":\"\"}]', '', 1, 1684215875, 1684215875, 127, 1684215875);
INSERT INTO `la_system_log_operate` VALUES (167, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":600,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-EditPen\",\"menuName\":\"开发工具\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"dev_tools\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1684215962, 1684215963, 251, 1684215963);
INSERT INTO `la_system_log_operate` VALUES (168, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"setting/dict/type/index\",\"id\":515,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Box\",\"menuName\":\"字典管理\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"dict\",\"perms\":\"setting:dict:type:list\",\"pid\":600,\"selected\":\"\"}]', '', 1, 1684215969, 1684215970, 150, 1684215970);
INSERT INTO `la_system_log_operate` VALUES (169, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"dev_tools/code/index\",\"id\":610,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-DocumentAdd\",\"menuName\":\"代码生成器\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"code\",\"perms\":\"gen:list\",\"pid\":600,\"selected\":\"\"}]', '', 1, 1684215984, 1684215985, 205, 1684215985);
INSERT INTO `la_system_log_operate` VALUES (170, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":724,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"local-icon-keziyuyue\",\"menuName\":\"用户设置\",\"menuSort\":8,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"user\",\"perms\":\"\",\"pid\":500,\"selected\":\"\"}]', '', 1, 1684216012, 1684216012, 255, 1684216012);
INSERT INTO `la_system_log_operate` VALUES (171, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"setting/user/setup\",\"id\":725,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"用户设置\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"setup\",\"perms\":\"setting:user:detail\",\"pid\":724,\"selected\":\"\"}]', '', 1, 1684216025, 1684216025, 219, 1684216025);
INSERT INTO `la_system_log_operate` VALUES (172, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"setting/user/login_register\",\"id\":726,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"\",\"menuName\":\"登录注册\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"login_register\",\"perms\":\"setting:login:detail\",\"pid\":724,\"selected\":\"\"}]', '', 1, 1684216030, 1684216030, 235, 1684216030);
INSERT INTO `la_system_log_operate` VALUES (173, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"setting/search/index\",\"id\":728,\"isCache\":0,\"isDisable\":1,\"isShow\":1,\"menuIcon\":\"el-icon-Search\",\"menuName\":\"热门搜索\",\"menuSort\":7,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"search\",\"perms\":\"setting:search:detail\",\"pid\":500,\"selected\":\"\"}]', '', 1, 1684216060, 1684216060, 219, 1684216060);
INSERT INTO `la_system_log_operate` VALUES (174, 1, 'GET', '缓存监控', '127.0.0.1', '/api/monitor/cache', 'com.mdd.admin.controller.monitor.MonitorCacheController.info()', '', '', 1, 1684216075, 1684216075, 185, 1684216075);
INSERT INTO `la_system_log_operate` VALUES (175, 1, 'GET', '服务监控', '127.0.0.1', '/api/monitor/server', 'com.mdd.admin.controller.monitor.MonitorServerController.info()', '', '', 1, 1684216078, 1684216081, 2858, 1684216081);
INSERT INTO `la_system_log_operate` VALUES (176, 1, 'GET', '缓存监控', '127.0.0.1', '/api/monitor/cache', 'com.mdd.admin.controller.monitor.MonitorCacheController.info()', '', '', 1, 1684216111, 1684216111, 3, 1684216111);
INSERT INTO `la_system_log_operate` VALUES (177, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1684216272, 1684216272, 11, 1684216272);
INSERT INTO `la_system_log_operate` VALUES (178, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '文章不存在!', 2, 1684307588, 1684307588, 13, 1684307588);
INSERT INTO `la_system_log_operate` VALUES (179, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '文章不存在!', 2, 1684307657, 1684307657, 2, 1684307657);
INSERT INTO `la_system_log_operate` VALUES (180, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307742, 1684307742, 210, 1684307742);
INSERT INTO `la_system_log_operate` VALUES (181, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 132, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (182, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 139, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (183, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 142, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (184, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 144, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (185, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 138, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (186, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 139, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (187, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 138, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (188, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 146, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (189, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 144, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (190, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 283, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (191, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 143, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (192, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 138, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (193, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 144, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (194, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 277, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (195, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 144, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (196, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 143, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (197, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 140, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (198, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 147, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (199, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 142, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (200, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 138, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (201, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307755, 1684307755, 8, 1684307755);
INSERT INTO `la_system_log_operate` VALUES (202, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 88, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (203, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 80, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (204, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 84, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (205, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 84, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (206, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 83, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (207, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 85, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (208, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 82, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (209, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 80, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (210, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 85, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (211, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 87, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (212, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 82, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (213, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 82, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (214, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 84, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (215, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 82, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (216, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 83, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (217, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 89, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (218, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 88, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (219, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 85, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (220, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 90, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (221, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 25, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (222, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 7, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (223, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 20, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (224, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 19, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (225, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 21, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (226, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 23, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (227, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 24, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (228, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 24, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (229, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 32, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (230, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 27, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (231, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 28, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (232, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 27, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (233, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 26, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (234, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 29, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (235, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 35, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (236, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 27, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (237, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 31, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (238, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 30, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (239, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 35, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (240, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 32, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (241, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 34, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (242, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 10, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (243, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 6, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (244, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 25, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (245, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 24, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (246, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 28, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (247, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 23, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (248, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 25, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (249, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 25, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (250, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 25, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (251, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 31, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (252, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 32, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (253, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 33, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (254, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 33, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (255, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 34, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (256, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 34, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (257, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 36, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (258, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 29, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (259, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 35, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (260, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 37, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (261, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 27, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (262, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 41, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (263, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 6, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (264, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 9, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (265, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 10, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (266, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 10, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (267, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 11, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (268, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 11, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (269, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 11, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (270, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 10, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (271, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 9, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (272, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 12, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (273, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 13, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (274, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 10, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (275, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 14, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (276, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 8, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (277, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 6, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (278, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 6, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (279, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 7, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (280, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"123\",\"cid\":1,\"content\":\"测试测试\",\"id\":4,\"image\":\"image/20230314/9052387f-e3a5-4738-8ea7-c24400a43553.png\",\"intro\":\"这是简介测试测试\",\"isShow\":1,\"sort\":0,\"summary\":\"100\",\"title\":\"测试测试测试\",\"visit\":122}]', '', 1, 1684307756, 1684307756, 6, 1684307756);
INSERT INTO `la_system_log_operate` VALUES (281, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486368, 1684486369, 167, 1684486369);
INSERT INTO `la_system_log_operate` VALUES (282, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486371, 1684486371, 113, 1684486371);
INSERT INTO `la_system_log_operate` VALUES (283, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486372, 1684486372, 196, 1684486372);
INSERT INTO `la_system_log_operate` VALUES (284, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486379, 1684486379, 76, 1684486379);
INSERT INTO `la_system_log_operate` VALUES (285, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486412, 1684486412, 226, 1684486412);
INSERT INTO `la_system_log_operate` VALUES (286, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486421, 1684486421, 225, 1684486421);
INSERT INTO `la_system_log_operate` VALUES (287, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486427, 1684486427, 167, 1684486427);
INSERT INTO `la_system_log_operate` VALUES (288, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684486452, 1684486452, 257, 1684486452);
INSERT INTO `la_system_log_operate` VALUES (289, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684487079, 1684487079, 195, 1684487079);
INSERT INTO `la_system_log_operate` VALUES (290, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684487083, 1684487084, 180, 1684487084);
INSERT INTO `la_system_log_operate` VALUES (291, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684492687, 1684492687, 246, 1684492687);
INSERT INTO `la_system_log_operate` VALUES (292, 1, 'POST', '文章分类状态', '127.0.0.1', '/api/article/cate/change', 'com.mdd.admin.controller.ArtCateController.change()', '[{\"id\":3}]', '', 1, 1684492696, 1684492697, 182, 1684492697);
INSERT INTO `la_system_log_operate` VALUES (293, 1, 'POST', '管理员编辑', '127.0.0.1', '/api/system/admin/edit', 'com.mdd.admin.controller.system.SystemAuthAdminController.edit()', '[{\"avatar\":\"http://qiniu.52yhqw.top/image/20230515/e757b7d5-e4c1-42e0-aad0-9b7ae82e0a9e.png\",\"deptIds\":[],\"id\":2,\"isDisable\":0,\"isMultipoint\":1,\"nickname\":\"测试号\",\"password\":\"\",\"postIds\":[],\"roleIds\":[2],\"sort\":0,\"username\":\"ceshi\"}]', '', 1, 1685255697, 1685255697, 159, 1685255697);
INSERT INTO `la_system_log_operate` VALUES (294, 1, 'POST', '管理员新增', '127.0.0.1', '/api/system/admin/add', 'com.mdd.admin.controller.system.SystemAuthAdminController.add()', '[{\"avatar\":\"\",\"deptIds\":[],\"isDisable\":0,\"isMultipoint\":1,\"nickname\":\"张亮麻辣烫\",\"password\":\"123456\",\"postIds\":[],\"roleIds\":[2],\"sort\":0,\"username\":\"123\"}]', '', 1, 1685255767, 1685255767, 270, 1685255767);
INSERT INTO `la_system_log_operate` VALUES (295, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '表情.gif', '', 1, 1685255864, 1685255865, 1602, 1685255865);
INSERT INTO `la_system_log_operate` VALUES (296, 1, 'POST', '管理员编辑', '127.0.0.1', '/api/system/admin/edit', 'com.mdd.admin.controller.system.SystemAuthAdminController.edit()', '[{\"avatar\":\"http://qiniu.52yhqw.top/image/20230528/0610fcf3-d20d-4070-86cd-9732c2da4ee3.gif\",\"deptIds\":[1],\"id\":1,\"isDisable\":0,\"isMultipoint\":1,\"nickname\":\"admin\",\"password\":\"\",\"postIds\":[],\"roleIds\":[0],\"sort\":0,\"username\":\"admin\"}]', '', 1, 1685255873, 1685255873, 202, 1685255873);
INSERT INTO `la_system_log_operate` VALUES (297, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1685513275, 1685513275, 58, 1685513275);
INSERT INTO `la_system_log_operate` VALUES (298, 1, 'GET', '服务监控', '127.0.0.1', '/api/monitor/server', 'com.mdd.admin.controller.monitor.MonitorServerController.info()', '', '', 1, 1685608704, 1685608708, 3083, 1685608708);
INSERT INTO `la_system_log_operate` VALUES (299, 1, 'GET', '缓存监控', '127.0.0.1', '/api/monitor/cache', 'com.mdd.admin.controller.monitor.MonitorCacheController.info()', '', '', 1, 1685608735, 1685608735, 61, 1685608735);
INSERT INTO `la_system_log_operate` VALUES (300, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1685608777, 1685608777, 64, 1685608777);
INSERT INTO `la_system_log_operate` VALUES (301, 1, 'POST', '相册文件删除', '127.0.0.1', '/api/albums/albumDel', 'com.mdd.admin.controller.AlbumsController.albumDel()', '[{\"ids\":[10]}]', '', 1, 1685608859, 1685608859, 221, 1685608859);
INSERT INTO `la_system_log_operate` VALUES (302, 1, 'GET', '服务监控', '127.0.0.1', '/api/monitor/server', 'com.mdd.admin.controller.monitor.MonitorServerController.info()', '', '', 1, 1685611152, 1685611154, 1197, 1685611154);
INSERT INTO `la_system_log_operate` VALUES (303, 1, 'GET', '缓存监控', '127.0.0.1', '/api/monitor/cache', 'com.mdd.admin.controller.monitor.MonitorCacheController.info()', '', '', 1, 1685611171, 1685611171, 2, 1685611171);
INSERT INTO `la_system_log_operate` VALUES (304, 1, 'GET', '缓存监控', '127.0.0.1', '/api/monitor/cache', 'com.mdd.admin.controller.monitor.MonitorCacheController.info()', '', '', 1, 1685611334, 1685611334, 2, 1685611334);
INSERT INTO `la_system_log_operate` VALUES (305, 1, 'GET', '服务监控', '127.0.0.1', '/api/monitor/server', 'com.mdd.admin.controller.monitor.MonitorServerController.info()', '', '', 1, 1685611339, 1685611340, 1073, 1685611340);
INSERT INTO `la_system_log_operate` VALUES (306, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"setting/website/protocol\",\"id\":510,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"\",\"menuName\":\"政策协议\",\"menuSort\":0,\"menuType\":\"C\",\"params\":\"\",\"paths\":\"protocol\",\"perms\":\"setting:protocol:detail\",\"pid\":501,\"selected\":\"\"}]', '', 1, 1685611428, 1685611429, 459, 1685611429);
INSERT INTO `la_system_log_operate` VALUES (307, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1685611451, 1685611451, 6, 1685611451);
INSERT INTO `la_system_log_operate` VALUES (308, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":600,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"el-icon-EditPen\",\"menuName\":\"开发工具\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"dev_tools\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1685611461, 1685611462, 212, 1685611462);
INSERT INTO `la_system_log_operate` VALUES (309, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":780,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"el-icon-SetUp\",\"menuName\":\"模板\",\"menuSort\":0,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"template\",\"perms\":\"\",\"pid\":0,\"selected\":\"\"}]', '', 1, 1685611467, 1685611467, 58, 1685611467);
INSERT INTO `la_system_log_operate` VALUES (310, 1, 'POST', '菜单编辑', '127.0.0.1', '/api/system/menu/edit', 'com.mdd.admin.controller.system.SystemAuthMenuController.edit()', '[{\"component\":\"\",\"id\":720,\"isCache\":0,\"isDisable\":0,\"isShow\":0,\"menuIcon\":\"el-icon-Message\",\"menuName\":\"消息通知\",\"menuSort\":9,\"menuType\":\"M\",\"params\":\"\",\"paths\":\"message\",\"perms\":\"\",\"pid\":500,\"selected\":\"\"}]', '', 1, 1685611480, 1685611480, 201, 1685611480);
INSERT INTO `la_system_log_operate` VALUES (311, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '干烧排骨.jpeg', '', 1, 1685860774, 1685860776, 1814, 1685860776);
INSERT INTO `la_system_log_operate` VALUES (312, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '蒙古烤羊排.jpeg', '', 1, 1685860774, 1685860776, 1885, 1685860776);
INSERT INTO `la_system_log_operate` VALUES (313, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '干锅肥肠.jpeg', '', 1, 1685860774, 1685860776, 1885, 1685860776);
INSERT INTO `la_system_log_operate` VALUES (314, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":5,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/503d0c8d-4909-4ef1-a794-22bba366fe5c.jpeg\",\"intro\":\"好吃的干锅大肥肠\",\"isShow\":1,\"sort\":0,\"summary\":\"59\",\"title\":\"干锅肥肠\",\"visit\":0}]', '', 1, 1685860832, 1685860833, 326, 1685860833);
INSERT INTO `la_system_log_operate` VALUES (315, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"多人优惠套餐\",\"sort\":1}]', '', 1, 1685860873, 1685860873, 214, 1685860873);
INSERT INTO `la_system_log_operate` VALUES (316, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":6,\"isShow\":1,\"name\":\"烧烤系列\",\"sort\":0}]', '', 1, 1685860879, 1685860879, 148, 1685860879);
INSERT INTO `la_system_log_operate` VALUES (317, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"海鲜\",\"sort\":0}]', '', 1, 1685860897, 1685860897, 170, 1685860897);
INSERT INTO `la_system_log_operate` VALUES (318, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"饮品\",\"sort\":0}]', '', 1, 1685860907, 1685860908, 152, 1685860908);
INSERT INTO `la_system_log_operate` VALUES (319, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"主食\",\"sort\":0}]', '', 1, 1685860913, 1685860913, 101, 1685860913);
INSERT INTO `la_system_log_operate` VALUES (320, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":8,\"isShow\":1,\"name\":\"海鲜系列\",\"sort\":0}]', '', 1, 1685861108, 1685861109, 163, 1685861109);
INSERT INTO `la_system_log_operate` VALUES (321, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":7,\"isShow\":1,\"name\":\"多人优惠套餐\",\"sort\":10}]', '', 1, 1685861162, 1685861162, 90, 1685861162);
INSERT INTO `la_system_log_operate` VALUES (322, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":8,\"isShow\":1,\"name\":\"海鲜系列\",\"sort\":4}]', '', 1, 1685861225, 1685861226, 190, 1685861226);
INSERT INTO `la_system_log_operate` VALUES (323, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":6,\"isShow\":1,\"name\":\"烧烤系列\",\"sort\":9}]', '', 1, 1685861231, 1685861231, 111, 1685861231);
INSERT INTO `la_system_log_operate` VALUES (324, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":5,\"isShow\":1,\"name\":\"肉菜\",\"sort\":3}]', '', 1, 1685861243, 1685861243, 170, 1685861243);
INSERT INTO `la_system_log_operate` VALUES (325, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":3,\"isShow\":1,\"name\":\"精品凉菜\",\"sort\":0}]', '', 1, 1685861253, 1685861253, 141, 1685861253);
INSERT INTO `la_system_log_operate` VALUES (326, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":3,\"isShow\":1,\"name\":\"精品凉菜\",\"sort\":2}]', '', 1, 1685861256, 1685861256, 135, 1685861256);
INSERT INTO `la_system_log_operate` VALUES (327, 1, 'POST', '文章分类编辑', '127.0.0.1', '/api/article/cate/edit', 'com.mdd.admin.controller.ArtCateController.edit()', '[{\"id\":4,\"isShow\":1,\"name\":\"热菜\",\"sort\":5}]', '', 1, 1685861263, 1685861263, 140, 1685861263);
INSERT INTO `la_system_log_operate` VALUES (328, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":6,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/5d2b0a56-e661-4b59-bf21-4b81d63ac734.jpeg\",\"intro\":\"香喷喷的蒙古烤羊排\",\"isShow\":1,\"sort\":0,\"summary\":\"99\",\"title\":\"蒙古烤羊排\",\"visit\":0}]', '', 1, 1685861420, 1685861420, 273, 1685861420);
INSERT INTO `la_system_log_operate` VALUES (329, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":5,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/427c32bf-2838-4f65-95a6-60f1152afb98.jpeg\",\"intro\":\"超好吃的干烧排骨\",\"isShow\":1,\"sort\":0,\"summary\":\"150\",\"title\":\"干烧排骨\",\"visit\":0}]', '', 1, 1685861462, 1685861462, 187, 1685861462);
INSERT INTO `la_system_log_operate` VALUES (330, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '三人套餐.jpg', '', 1, 1685861483, 1685861484, 501, 1685861484);
INSERT INTO `la_system_log_operate` VALUES (331, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '开胃大虾.jpg', '', 1, 1685861483, 1685861484, 530, 1685861484);
INSERT INTO `la_system_log_operate` VALUES (332, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '蒜香小龙虾.jpg', '', 1, 1685861483, 1685861484, 519, 1685861484);
INSERT INTO `la_system_log_operate` VALUES (333, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":8,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/9f862c45-0958-41e0-ac00-0d96998a6b66.jpg\",\"intro\":\"蒜香小龙虾好吃的很\",\"isShow\":1,\"sort\":0,\"summary\":\"210\",\"title\":\"蒜香小龙虾\",\"visit\":0}]', '', 1, 1685861508, 1685861508, 207, 1685861508);
INSERT INTO `la_system_log_operate` VALUES (334, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":8,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/af4735e4-1d0a-42bb-93e5-842c2111d3f6.jpg\",\"intro\":\"开胃大虾，好吃不腻！\",\"isShow\":1,\"sort\":0,\"summary\":\"996\",\"title\":\"开胃大虾\",\"visit\":0}]', '', 1, 1685861555, 1685861555, 184, 1685861555);
INSERT INTO `la_system_log_operate` VALUES (335, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":7,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/d0ff35e6-91f6-4377-bc1c-cc95509ed185.jpg\",\"intro\":\"三人套餐，三荤一素。实惠多多\",\"isShow\":1,\"sort\":0,\"summary\":\"599\",\"title\":\"三人套餐（三荤一素）\",\"visit\":0}]', '', 1, 1685861618, 1685861618, 165, 1685861618);
INSERT INTO `la_system_log_operate` VALUES (336, 1, 'POST', '文章分类新增', '127.0.0.1', '/api/article/cate/add', 'com.mdd.admin.controller.ArtCateController.add()', '[{\"isShow\":1,\"name\":\"河南名吃\",\"sort\":7}]', '', 1, 1685861665, 1685861665, 231, 1685861665);
INSERT INTO `la_system_log_operate` VALUES (337, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '可乐.jpeg', '', 1, 1685861802, 1685861802, 497, 1685861802);
INSERT INTO `la_system_log_operate` VALUES (338, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '青岛崂山啤酒.jpeg', '', 1, 1685861802, 1685861803, 724, 1685861803);
INSERT INTO `la_system_log_operate` VALUES (339, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":9,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/e589574e-cf31-41ac-a5fa-8916e08da816.jpeg\",\"intro\":\"喝啤酒就喝崂山啤酒\",\"isShow\":1,\"sort\":0,\"summary\":\"5\",\"title\":\"崂山啤酒500ml\",\"visit\":0}]', '', 1, 1685861835, 1685861835, 157, 1685861835);
INSERT INTO `la_system_log_operate` VALUES (340, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":9,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/768a00c7-8d9f-4062-b44d-f3f3b367992e.jpeg\",\"intro\":\"可乐清凉爽口\",\"isShow\":1,\"sort\":0,\"summary\":\"3\",\"title\":\"可口可乐300ml\",\"visit\":0}]', '', 1, 1685861861, 1685861861, 184, 1685861861);
INSERT INTO `la_system_log_operate` VALUES (341, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '河南烩面.jpg', '', 1, 1685861877, 1685861877, 476, 1685861877);
INSERT INTO `la_system_log_operate` VALUES (342, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":10,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/94db5aba-3dd7-4573-b8c4-547dabb44c75.jpg\",\"intro\":\"河南烩面\",\"isShow\":1,\"sort\":0,\"summary\":\"20\",\"title\":\"河南烩面\",\"visit\":0}]', '', 1, 1685861895, 1685861896, 181, 1685861896);
INSERT INTO `la_system_log_operate` VALUES (343, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '灌汤包.jpeg', '', 1, 1685861969, 1685861970, 468, 1685861970);
INSERT INTO `la_system_log_operate` VALUES (344, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":11,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/f1b6112c-7b87-43b5-8113-212a590325be.jpeg\",\"intro\":\"\",\"isShow\":1,\"sort\":0,\"summary\":\"30\",\"title\":\"灌汤包 / 笼\",\"visit\":0}]', '', 1, 1685862000, 1685862000, 168, 1685862000);
INSERT INTO `la_system_log_operate` VALUES (345, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '胡辣汤.jpeg', '', 1, 1685862029, 1685862029, 487, 1685862029);
INSERT INTO `la_system_log_operate` VALUES (346, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":11,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/08de6cc7-3ac8-41ea-9de5-18912f19c1b3.jpeg\",\"intro\":\"河南胡辣汤正宗的很\",\"isShow\":1,\"sort\":0,\"summary\":\"19.9\",\"title\":\"河南正宗胡辣汤\",\"visit\":0}]', '', 1, 1685862061, 1685862061, 148, 1685862061);
INSERT INTO `la_system_log_operate` VALUES (347, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '卷煎.jpeg', '', 1, 1685862125, 1685862125, 643, 1685862125);
INSERT INTO `la_system_log_operate` VALUES (348, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":11,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/d0bb39f6-70be-4aa1-99ad-84dd50b30f2d.jpeg\",\"intro\":\"\",\"isShow\":1,\"sort\":0,\"summary\":\"60\",\"title\":\"卷煎\",\"visit\":0}]', '', 1, 1685862141, 1685862141, 174, 1685862141);
INSERT INTO `la_system_log_operate` VALUES (349, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '开封高炉烧饼.jpeg', '', 1, 1685862169, 1685862170, 635, 1685862170);
INSERT INTO `la_system_log_operate` VALUES (350, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":11,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/50d62e5f-c32b-41d8-a42a-eba705973666.jpeg\",\"intro\":\"\",\"isShow\":1,\"sort\":0,\"summary\":\"2\",\"title\":\"开封高炉烧饼 / 个\",\"visit\":0}]', '', 1, 1685862195, 1685862195, 144, 1685862195);
INSERT INTO `la_system_log_operate` VALUES (351, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '蒸米.jpeg', '', 1, 1685862271, 1685862272, 526, 1685862272);
INSERT INTO `la_system_log_operate` VALUES (352, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":10,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/05a6b94c-dfbf-4c46-a3a4-8f03e1ec5545.jpeg\",\"intro\":\"\",\"isShow\":1,\"sort\":0,\"summary\":\"0.01\",\"title\":\"蒸米一份\",\"visit\":0}]', '', 1, 1685862283, 1685862283, 103, 1685862283);
INSERT INTO `la_system_log_operate` VALUES (353, 1, 'POST', '文章编辑', '127.0.0.1', '/api/article/edit', 'com.mdd.admin.controller.ArticleController.edit()', '[{\"author\":\"\",\"cid\":10,\"content\":\"\",\"id\":26,\"image\":\"http://qiniu.52yhqw.top/image/20230604/05a6b94c-dfbf-4c46-a3a4-8f03e1ec5545.jpeg\",\"intro\":\"\",\"isShow\":1,\"sort\":0,\"summary\":\"5\",\"title\":\"蒸米一份\",\"visit\":0}]', '', 1, 1685862289, 1685862290, 188, 1685862290);
INSERT INTO `la_system_log_operate` VALUES (354, 1, 'POST', '上传图片', '127.0.0.1', '/api/upload/image', 'com.mdd.admin.controller.UploadController.image()', '凉拌金针菇.jpeg', '', 1, 1685862378, 1685862378, 517, 1685862378);
INSERT INTO `la_system_log_operate` VALUES (355, 1, 'POST', '文章新增', '127.0.0.1', '/api/article/add', 'com.mdd.admin.controller.ArticleController.add()', '[{\"author\":\"\",\"cid\":3,\"content\":\"\",\"image\":\"http://qiniu.52yhqw.top/image/20230604/06bbacc6-c6be-4030-ae94-a9fd72f573e3.jpeg\",\"intro\":\"\",\"isShow\":1,\"sort\":0,\"summary\":\"10\",\"title\":\"凉拌金针菇\",\"visit\":0}]', '', 1, 1685862397, 1685862397, 126, 1685862397);
INSERT INTO `la_system_log_operate` VALUES (356, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1686011893, 1686011893, 19, 1686011893);
INSERT INTO `la_system_log_operate` VALUES (357, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1686011896, 1686011896, 6, 1686011896);
INSERT INTO `la_system_log_operate` VALUES (358, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1686011899, 1686011899, 4, 1686011899);
INSERT INTO `la_system_log_operate` VALUES (359, 1, 'POST', '角色编辑', '127.0.0.1', '/api/system/role/edit', 'com.mdd.admin.controller.system.SystemAuthRoleController.edit()', '[{\"id\":2,\"isDisable\":0,\"menuIds\":\"717,1,790,703,704,730,732,733,738,755,705,716,734,735,736,737,775,130,131,132,133,134,135,140,141,142,143,144,796,797,794,795,700,701\",\"name\":\"商户\",\"remark\":\"\",\"sort\":0}]', '', 1, 1686011928, 1686011928, 210, 1686011928);
INSERT INTO `la_system_log_operate` VALUES (360, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1686011928, 1686011928, 7, 1686011928);
INSERT INTO `la_system_log_operate` VALUES (361, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1686011932, 1686011932, 5, 1686011932);
INSERT INTO `la_system_log_operate` VALUES (362, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1686014994, 1686014994, 7, 1686014994);
INSERT INTO `la_system_log_operate` VALUES (363, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1686015981, 1686015981, 3, 1686015981);
INSERT INTO `la_system_log_operate` VALUES (364, 1, 'POST', '角色编辑', '127.0.0.1', '/api/system/role/edit', 'com.mdd.admin.controller.system.SystemAuthRoleController.edit()', '[{\"id\":2,\"isDisable\":0,\"menuIds\":\"717,1,790,703,704,730,732,733,738,755,705,716,734,735,736,737,775,130,131,132,133,134,135,140,141,142,143,144,796,797,794,795,700,701\",\"name\":\"商户\",\"remark\":\"\",\"sort\":0}]', '', 1, 1686016013, 1686016014, 413, 1686016014);
INSERT INTO `la_system_log_operate` VALUES (365, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1686016014, 1686016014, 5, 1686016014);
INSERT INTO `la_system_log_operate` VALUES (366, 1, 'GET', '角色列表', '127.0.0.1', '/api/system/role/list', 'com.mdd.admin.controller.system.SystemAuthRoleController.list()', 'pageNo=1&pageSize=15', '', 1, 1686016265, 1686016265, 5, 1686016265);
INSERT INTO `la_system_log_operate` VALUES (367, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1686016267, 1686016267, 3, 1686016267);
INSERT INTO `la_system_log_operate` VALUES (368, 1, 'GET', '角色详情', '127.0.0.1', '/api/system/role/detail', 'com.mdd.admin.controller.system.SystemAuthRoleController.detail()', 'id=2', '', 1, 1686016277, 1686016277, 4, 1686016277);

-- ----------------------------
-- Table structure for la_system_log_sms
-- ----------------------------
DROP TABLE IF EXISTS `la_system_log_sms`;
CREATE TABLE `la_system_log_sms`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `scene` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '场景编号',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发送内容',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送状态：[0=发送中, 1=发送成功, 2=发送失败]',
  `results` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '短信结果',
  `send_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送时间',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统短信日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_system_log_sms
-- ----------------------------

-- ----------------------------
-- Table structure for la_user
-- ----------------------------
DROP TABLE IF EXISTS `la_user`;
CREATE TABLE `la_user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sn` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '编号',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户账号',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户密码',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户电话',
  `salt` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '加密盐巴',
  `sex` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户性别: [1=男, 2=女]',
  `channel` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注册渠道: [1=微信小程序, 2=微信公众号, 3=手机H5, 4=电脑PC, 5=苹果APP, 6=安卓APP]',
  `is_disable` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否禁用: [0=否, 1=是]',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除: [0=否, 1=是]',
  `last_login_ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `last_login_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_user
-- ----------------------------

-- ----------------------------
-- Table structure for la_user_auth
-- ----------------------------
DROP TABLE IF EXISTS `la_user_auth`;
CREATE TABLE `la_user_auth`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `openid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Openid',
  `unionid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Unionid',
  `client` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '客户端类型: [1=微信小程序, 2=微信公众号, 3=手机H5, 4=电脑PC, 5=苹果APP, 6=安卓APP]',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `openid`(`openid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户授权表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of la_user_auth
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
