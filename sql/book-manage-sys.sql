/*
 Navicat Premium Dump SQL

 Source Server         : local-db-mysql
 Source Server Type    : MySQL
 Source Server Version : 50741 (5.7.41)
 Source Host           : localhost:3306
 Source Schema         : book-manage-sys

 Target Server Type    : MySQL
 Target Server Version : 50741 (5.7.41)
 File Encoding         : 65001

 Date: 08/12/2024 16:54:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '书籍表主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书籍名',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书籍封面',
  `publisher` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '出版社',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书籍的作者',
  `isbn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '国际标准书号',
  `num` int(11) NULL DEFAULT NULL COMMENT '馆藏数量',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书籍简介',
  `bookshelf_id` int(11) NULL DEFAULT NULL COMMENT '书架ID',
  `category_id` int(11) NULL DEFAULT NULL COMMENT '书籍类别ID',
  `is_plan_buy` tinyint(1) NULL DEFAULT NULL COMMENT '是否计划购买',
  `plan_buy_time` date NULL DEFAULT NULL COMMENT '计划购买时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '入库时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (8, '中国历史常识', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=92b0af4Snipaste_2024-12-07_22-23-37.png', '浙江大学出版商', '吕思勉', '67898989Y', 3, '一本华人世界公认的国史巨著，民国以来畅销至今的国史读本。通古通今通天下，知兴知衰知未来。一本书让你读懂五千年中国史。', 1, 1, 0, NULL, '2024-12-01 22:25:36');
INSERT INTO `book` VALUES (9, '历史的棋局', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=b9c792dSnipaste_2024-12-07_22-28-02.png', '人民日报出版社', '李开元', '545435432443JIM', 4, '一本书读懂古代帝王将相的生存博弈与宦海风波！《国家人文历史》汇集众多历史专家倾心写就，触摸历史体温、发现历史真相，三大主题、14个朝代、3000年历史。在历史的棋谱里，看中国人的成败经验与济世智慧！', 3, 1, 0, NULL, '2024-12-07 22:29:33');
INSERT INTO `book` VALUES (10, '历史的镜子', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=bba3eccSnipaste_2024-12-07_22-39-35.png', '四川文艺出版社', '吴晗', '543543543D', 4, '中国史学大家吴晗经典之作。有趣，有洞见，挖掘不为人知的历史细节。跨度一千余年，讲述中华文明的蜕变与转型。明善恶，辨是非，照人心——一部再现历史真相的磅礴史诗。酷威文化', 1, 1, 0, NULL, '2024-12-07 22:40:19');
INSERT INTO `book` VALUES (11, '狂人日记', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=e07eee1Snipaste_2024-12-07_22-42-43.png', '中国友谊出版公司', '鲁迅', '4234324E', 4, '中国现代白话小说开山之作，收录鲁迅全部小说《呐喊》《彷徨》《故事新编》。以1938年上海复社版为底本，原汁原味原版风貌，另收录鲁迅生平及照片', 1, 3, 0, '2024-12-17', '2024-12-07 22:43:32');
INSERT INTO `book` VALUES (12, '乔家大院', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=72ac187Snipaste_2024-12-07_22-44-45.png', '中国青年出版社', '朱秀海', '5354T', 5, '乔家大院', 3, 2, 0, NULL, '2024-12-07 22:45:46');
INSERT INTO `book` VALUES (13, '当怪物来敲门', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=1972eeeSnipaste_2024-12-08_14-57-02.png', '新蕾出版社', '派崔克·奈斯', '6778789UIYU', 2, '囊括卡内基文学奖和凯特·格林纳威大奖两个重磅奖项的儿童文学作品；同名改编电影感动全球亿万观众；一部关于生命、失去与爱的美丽杰作，教会孩子如何正确面对死亡', 1, 3, 0, NULL, '2024-12-08 14:57:56');
INSERT INTO `book` VALUES (14, '罗生门', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=7e74decSnipaste_2024-12-08_14-58-14.png', '北京燕山出版社', '芥川龙之介', '687678UU', 10, '罗生门 芥川龙之介 短篇作品小说集 日本文学小说图书', 3, 2, 0, NULL, '2024-12-08 14:58:58');
INSERT INTO `book` VALUES (15, '骆驼样子', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=6ba424dSnipaste_2024-12-08_15-33-09.png', '中国日报出版社', '老舍', '5435345HJHJh', 6, '祥子是个破产的青年农民。从农村来到城市，渴望以自己的诚实劳动买一辆属于自己的车。做个独立的劳动者是祥子的志愿，他用三年的时间省吃俭用，终于实现了理想，成为自食其力的上等车夫。', 3, 2, 0, NULL, '2024-12-08 15:43:16');
INSERT INTO `book` VALUES (16, '萤火谷的梦想家', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=9337258Snipaste_2024-12-08_15-45-06.png', '长江少年儿童出版社', '艾莉森·麦吉', '67878798HHH', 9, '入围2018深圳读书月“年度十大童书”30强。《纽约时报》畅销书作家艾莉森·麦吉六年打磨，温情励志获奖小说《哈利·波特》译者马爱农翻译。荣获国际阅读协会教师选择奖、美国父母选择奖等。（心喜阅童书出品）', 1, 2, 1, '2024-12-17', '2024-12-08 15:46:06');

-- ----------------------------
-- Table structure for book_order_history
-- ----------------------------
DROP TABLE IF EXISTS `book_order_history`;
CREATE TABLE `book_order_history`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图书预约历史ID',
  `book_id` int(11) NULL DEFAULT NULL COMMENT '图书ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `deadline_num` int(11) NULL DEFAULT NULL COMMENT '借书的数量',
  `is_return` tinyint(1) NULL DEFAULT NULL COMMENT '是否已经归还',
  `return_time` date NULL DEFAULT NULL COMMENT '归还时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '借书时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_order_history
-- ----------------------------
INSERT INTO `book_order_history` VALUES (27, 14, 2, 1, 1, '2024-12-17', '2024-12-08 15:54:45');
INSERT INTO `book_order_history` VALUES (28, 14, 2, 1, 1, '2024-12-16', '2024-12-08 16:43:54');

-- ----------------------------
-- Table structure for book_rss_history
-- ----------------------------
DROP TABLE IF EXISTS `book_rss_history`;
CREATE TABLE `book_rss_history`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图书订阅ID',
  `book_id` int(11) NULL DEFAULT NULL COMMENT '图书ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '订阅时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_rss_history
-- ----------------------------
INSERT INTO `book_rss_history` VALUES (9, 11, 2, '2024-12-08 15:12:37');
INSERT INTO `book_rss_history` VALUES (10, 16, 2, '2024-12-08 16:44:23');

-- ----------------------------
-- Table structure for book_save
-- ----------------------------
DROP TABLE IF EXISTS `book_save`;
CREATE TABLE `book_save`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图书收藏主键ID',
  `book_id` int(11) NULL DEFAULT NULL COMMENT '图书ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_save
-- ----------------------------
INSERT INTO `book_save` VALUES (16, 15, 2);
INSERT INTO `book_save` VALUES (17, 14, 2);

-- ----------------------------
-- Table structure for bookshelf
-- ----------------------------
DROP TABLE IF EXISTS `bookshelf`;
CREATE TABLE `bookshelf`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '书架表主键ID',
  `floor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书架所在的楼层',
  `area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书架所属的区域',
  `frame` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '书架名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bookshelf
-- ----------------------------
INSERT INTO `bookshelf` VALUES (1, '1楼', '东区', 'A1');
INSERT INTO `bookshelf` VALUES (3, '2楼', '北区', 'A2');

-- ----------------------------
-- Table structure for bookshelf_category
-- ----------------------------
DROP TABLE IF EXISTS `bookshelf_category`;
CREATE TABLE `bookshelf_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '书架种类关联表主键',
  `bookshelf_id` int(11) NULL DEFAULT NULL COMMENT '书架ID',
  `category_id` int(11) NULL DEFAULT NULL COMMENT '书籍类别ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bookshelf_category
-- ----------------------------

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '书籍类别主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '类别名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '历史大类');
INSERT INTO `category` VALUES (2, '小说');
INSERT INTO `category` VALUES (3, '文学');
INSERT INTO `category` VALUES (5, '社交');
INSERT INTO `category` VALUES (6, '心理学');
INSERT INTO `category` VALUES (7, '外国小说');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '网站即将进行系统维护，服务暂停通知', '<p><span style=\"color: rgb(5, 7, 59); background-color: rgb(253, 253, 254); font-size: 15px;\">尊敬的用户，为了给您带来更加流畅、安全的浏览体验，本网站将于今晚23:00至次日凌晨5:00进行系统升级与维护。</span></p><p><img src=\"/api/online-test/v1.0/file/getFile?fileName=a83d99110.jpg\" alt=\"/api/online-test/v1.0/file/getFile?fileName=a83d99110.jpg\" data-href=\"/api/online-test/v1.0/file/getFile?fileName=a83d99110.jpg\" style=\"width: 417.00px;height: 311.12px;\"/></p><p><span style=\"color: rgb(5, 7, 59); background-color: rgb(253, 253, 254); font-size: 15px;\">在此期间，网站将暂停所有服务，包括登录、浏览、下单等功能。</span></p><p><span style=\"color: rgb(5, 7, 59); background-color: rgb(253, 253, 254); font-size: 15px;\">请提前安排好您的使用计划，对给您带来的不便深表歉意，并感谢您的理解与支持！</span></p>', '2024-08-03 12:23:30');
INSERT INTO `notice` VALUES (5, '加强账户安全，请立即更新密码', '<p><span style=\"color: rgb(5, 7, 59); background-color: rgb(253, 253, 254); font-size: 15px;\">近期，我们发现有不法分子试图通过非法手段获取用户信息。为了保障您的账户安全，我们强烈建议您立即登录网站，更新您的登录密码，并开启双重验证功能。同时，请确保不要使用过于简单或与个人信息相关的密码，以免遭受损失。</span></p>', '2024-08-03 12:24:16');
INSERT INTO `notice` VALUES (6, '夏日狂欢节，限时优惠等你来抢！', '<p><span style=\"color: rgb(5, 7, 59); background-color: rgb(253, 253, 254); font-size: 15px;\">炎炎夏日，我们为您准备了丰富多彩的夏日狂欢节活动！从即日起至本月底，全场商品低至五折起，更有满额赠礼、积分翻倍等多重好礼等你来拿！快来抢购心仪的商品，享受清凉一夏吧！</span></p>', '2024-08-03 12:24:31');
INSERT INTO `notice` VALUES (7, '关于隐私政策的重要更新，请仔细阅读', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:24:46');
INSERT INTO `notice` VALUES (8, '全新功能“智能推荐”正式上线，让购物更便捷！', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:25:01');
INSERT INTO `notice` VALUES (9, '快递服务调整公告，请注意查收时间变化', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:25:14');
INSERT INTO `notice` VALUES (10, '会员日尊享特惠，独家福利不容错过！', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:25:27');
INSERT INTO `notice` VALUES (11, '警惕网络诈骗，保护个人财产安全', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:25:39');
INSERT INTO `notice` VALUES (12, '全新面貌，更优体验 —— 网站改版上线', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:25:56');
INSERT INTO `notice` VALUES (13, ' 关于网站内容版权的严正声明', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:26:09');
INSERT INTO `notice` VALUES (14, '诚邀合作伙伴，共创辉煌未来！', '<h4 style=\"text-align: start;\">尊敬的各位员工、合作伙伴及客户：</h4><p style=\"text-align: start;\">为了让大家及时了解公司的最新动态和发展方向，现将[公司名称]在2024年第四季度的重要事项和决策公布如下，请各位知悉。</p><h3 style=\"text-align: start;\">一、业务发展与战略调整</h3><ol><li style=\"text-align: start;\">市场扩展计划在本季度，我们成功进入了三个新的国际市场：欧洲、东南亚和中东。为此，我们将加大在这几个区域的品牌推广力度，并设立本地化的销售和服务团队。同时，国内市场的深耕策略也在稳步推进中，特别是在二三线城市开设了多家旗舰店和技术服务中心，进一步提升了品牌影响力和服务质量。</li><li style=\"text-align: start;\">新产品发布经过数月的努力研发，我们的新一代智能产品系列——[产品名称]正式上市。这款产品融合了最新的AI技术和人性化设计理念，旨在为用户提供更加便捷高效的解决方案。随着新产品的推出，我们也启动了一系列促销活动和用户反馈收集机制，确保能够快速响应市场需求并进行持续优化。</li><li style=\"text-align: start;\">战略合作签署[公司名称]与国际知名科技企业[合作方名称]达成了深度合作协议，在云计算、大数据分析等领域展开广泛合作。双方将共同探索新技术的应用场景，推动产业升级转型。</li></ol><h3 style=\"text-align: start;\">二、内部管理与组织架构</h3><ol><li style=\"text-align: start;\">人才引进与培养为了满足公司快速发展的人才需求，人力资源部门在本季度开展了大规模招聘行动，吸引了众多来自国内外顶尖学府的专业人才加入我们的团队。此外，针对现有员工的职业发展规划，我们推出了“精英成长计划”，通过内部培训课程、导师辅导以及外部进修机会等多种方式提升员工的专业技能和个人素质。</li><li style=\"text-align: start;\">绩效考核制度更新结合实际运营情况，我们对原有的绩效考核体系进行了全面修订和完善，增加了更多量化指标和定性评价相结合的方式，力求做到公平公正地评估每位员工的工作表现。新的考核结果将直接应用于年度奖金分配和个人晋升决策过程中，激励全体员工积极进取，创造更好的业绩。</li><li style=\"text-align: start;\">企业文化建设本季度，公司举办了多次文化主题活动，如户外拓展训练营、创意工作坊等，增强了团队凝聚力和创造力。同时，也加强了对公司使命愿景的理解认同，营造了一个开放包容的工作氛围。</li></ol><h3 style=\"text-align: start;\">三、社会责任与公益活动</h3><ol><li style=\"text-align: start;\">环保举措实施作为负责任的企业公民，我们在生产环节严格遵守国家环保标准，投资建设了先进的污水处理设施，并推行绿色办公理念，减少纸张浪费和能源消耗。未来，我们还将继续探索可持续发展的路径，积极参与行业内外的环保倡议，为保护地球环境贡献力量。</li><li style=\"text-align: start;\">公益捐赠与志愿服务在社会公益方面，[公司名称]积极响应政府号召，向受灾地区捐赠了价值数百万元的物资；此外，还组织员工志愿者参与社区服务项目，帮助弱势群体改善生活条件。我们相信，企业的成功不仅仅体现在经济效益上，更应该体现在对社会的责任感和贡献度之中。</li></ol><h3 style=\"text-align: start;\">四、展望未来</h3><p style=\"text-align: start;\">随着上述各项工作的逐步落实，我们有信心在接下来的时间里取得更加辉煌的成绩。感谢所有关心和支持[公司名称]发展的朋友们！让我们携手共进，迎接更加美好的明天！</p>', '2024-08-03 12:26:23');

-- ----------------------------
-- Table structure for reader_proposal
-- ----------------------------
DROP TABLE IF EXISTS `reader_proposal`;
CREATE TABLE `reader_proposal`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '读者反馈ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '反馈者用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '反馈的问题内容',
  `is_publish` tinyint(1) NULL DEFAULT NULL COMMENT '是否公开',
  `reply_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '回复内容',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `is_reply` tinyint(1) NULL DEFAULT NULL COMMENT '是否已经回复',
  `create_time` datetime NULL DEFAULT NULL COMMENT '用户反馈时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reader_proposal
-- ----------------------------
INSERT INTO `reader_proposal` VALUES (2, 7, '有人占座，管不管？！', 1, '正在逐步优化管理措施', '2024-09-07 14:31:13', 1, '2024-09-07 14:30:52');
INSERT INTO `reader_proposal` VALUES (3, 7, '可以提前还书吗？', 1, NULL, NULL, 0, '2024-09-07 16:26:19');
INSERT INTO `reader_proposal` VALUES (4, 8, '馆藏的书籍太久了，跟不上时代！', 1, '3232', '2024-09-12 16:57:41', 1, '2024-09-07 16:26:59');
INSERT INTO `reader_proposal` VALUES (5, 8, '三楼开放吗？什么时候开放', 1, '开放的。周天全天', '2024-09-07 16:32:43', 1, '2024-09-07 16:32:19');
INSERT INTO `reader_proposal` VALUES (6, 8, '测试AOP拦截新增行为', 1, '2323', '2024-09-11 18:01:02', 1, '2024-09-11 15:19:10');
INSERT INTO `reader_proposal` VALUES (7, 8, '12121', 1, NULL, NULL, 0, '2024-09-12 17:00:54');
INSERT INTO `reader_proposal` VALUES (8, 10, '美食类别涵盖了中国不同地区的特色风味，从北到南，从东至西，展示了中华大地丰富多彩的饮食文化和地域特色。希望这些建议能为你提供灵感！如果有任何特定需求或需要进一步的信息，请随时告知', 1, '美食类别涵盖了中国不同地区的特色风味，从北到南，从东至西，展示了中华大地丰富多彩的饮食文化和地域特色。希望这些建议能为你提供灵感！如果有任何特定需求或需要进一步的信息，请随时告知', '2024-12-05 19:55:21', 1, '2024-10-19 06:46:44');
INSERT INTO `reader_proposal` VALUES (9, 9, '测试数据', 1, NULL, NULL, 0, '2024-10-19 06:46:51');
INSERT INTO `reader_proposal` VALUES (10, 12, '继续反馈', 1, NULL, NULL, 0, '2024-10-19 06:46:59');
INSERT INTO `reader_proposal` VALUES (11, 2, '美食类别涵盖了中国不同地区的特色风味，从北到南，从东', NULL, '5656546', '2024-12-08 16:39:31', 1, '2024-12-05 21:37:43');
INSERT INTO `reader_proposal` VALUES (13, 2, '测试发布', NULL, NULL, NULL, 0, '2024-12-06 05:41:44');

-- ----------------------------
-- Table structure for rss_notification
-- ----------------------------
DROP TABLE IF EXISTS `rss_notification`;
CREATE TABLE `rss_notification`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订阅通知ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '通知的内容',
  `is_read` tinyint(1) NULL DEFAULT NULL COMMENT '用户是否已经阅读',
  `create_time` datetime NULL DEFAULT NULL COMMENT '通知的时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rss_notification
-- ----------------------------
INSERT INTO `rss_notification` VALUES (15, 2, '您好，您订阅的由鲁迅创作的书籍【狂人日记】已经上线，可以借阅了', 1, '2024-12-08 15:31:02');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `user_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户账号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `user_pwd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户密码',
  `user_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户头像',
  `user_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户邮箱',
  `user_role` int(11) NULL DEFAULT NULL COMMENT '用户角色',
  `is_login` tinyint(1) NULL DEFAULT NULL COMMENT '可登录状态(0：可用，1：不可用)',
  `is_word` tinyint(1) NULL DEFAULT NULL COMMENT '禁言状态(0：可用，1：不可用)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '用户注册时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'B站【程序员辰星】原创出品', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=60c99f6Snipaste_2024-08-31_17-40-55.png', '1343243@qq.com', 1, 0, 0, '2024-12-04 12:53:05');
INSERT INTO `user` VALUES (2, 'zhangfan', '张帆', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=ba728e7pic_6.jpg', '12311323@qq.com', 2, 0, 0, '2024-08-16 16:12:12');
INSERT INTO `user` VALUES (7, 'liran', '李冉', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=5ee4cb8熊猫.png', '12434@qq.com', 1, 1, 1, '2024-10-19 06:39:12');
INSERT INTO `user` VALUES (8, 'lichen', '李琛', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=109bac7pic_7.jpg', '12345@qq.com', 2, 0, 0, '2024-12-05 15:44:45');
INSERT INTO `user` VALUES (9, 'wangfangfang', '王芳芳', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=b76542cpic_8.jpg', '1234@qq.com', 2, 0, 1, '2024-12-05 15:45:12');
INSERT INTO `user` VALUES (10, 'yuelang', '月朗', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=c7568c2pic_5.jpg', '4532432@qq.com', 2, 0, 0, '2024-12-05 15:46:46');
INSERT INTO `user` VALUES (11, 'chenxin', '陈芯', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=cdf71ffSnipaste_2024-11-29_18-22-44.png', '123432@qq.com', 2, 0, 0, '2024-12-05 15:47:08');
INSERT INTO `user` VALUES (12, 'hututu', '胡图图', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=e694502Snipaste_2024-11-22_00-47-41.png', '4343@qq.com', 2, 0, 0, '2024-12-05 15:47:26');
INSERT INTO `user` VALUES (13, 'fanggui', '方贵', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=3e28f7cSnipaste_2024-11-22_00-47-32.png', '43423@qq.com', 2, 0, 0, '2024-12-05 15:51:13');
INSERT INTO `user` VALUES (14, 'jiangxin', '江心', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=e9a35efpic_7.jpg', '124343@qq.com', 2, 0, 0, '2024-12-05 15:54:50');
INSERT INTO `user` VALUES (15, 'moxin', '陌心', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=be0e757Snipaste_2024-11-22_00-46-13.png', '654456@qq.com', 2, 1, 1, '2024-12-05 15:55:12');

-- ----------------------------
-- Table structure for user_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `user_operation_log`;
CREATE TABLE `user_operation_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户行为日志表主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '行为描述',
  `create_time` datetime NULL DEFAULT NULL COMMENT '记录时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_operation_log
-- ----------------------------
INSERT INTO `user_operation_log` VALUES (1, 2, '借书操作', '2024-09-04 15:06:49');
INSERT INTO `user_operation_log` VALUES (4, 2, '向系统提交建议', '2024-09-11 15:19:10');
INSERT INTO `user_operation_log` VALUES (10, 2, '向系统提交建议', '2024-12-05 21:38:15');
INSERT INTO `user_operation_log` VALUES (12, 2, '借阅书籍', '2024-12-07 15:03:13');
INSERT INTO `user_operation_log` VALUES (13, 2, '借阅书籍', '2024-12-07 15:05:21');
INSERT INTO `user_operation_log` VALUES (14, 2, '借阅书籍', '2024-12-07 15:05:24');
INSERT INTO `user_operation_log` VALUES (15, 2, '借阅书籍', '2024-12-07 15:05:26');
INSERT INTO `user_operation_log` VALUES (16, 2, '借阅书籍', '2024-12-07 15:06:02');
INSERT INTO `user_operation_log` VALUES (17, 2, '借阅书籍', '2024-12-07 15:07:48');
INSERT INTO `user_operation_log` VALUES (18, 2, '借阅书籍', '2024-12-07 15:08:01');
INSERT INTO `user_operation_log` VALUES (19, 2, '借阅书籍', '2024-12-07 15:08:30');
INSERT INTO `user_operation_log` VALUES (20, 2, '借阅书籍', '2024-12-07 15:09:02');
INSERT INTO `user_operation_log` VALUES (21, 2, '借阅书籍', '2024-12-07 15:10:18');
INSERT INTO `user_operation_log` VALUES (22, 2, '借阅书籍', '2024-12-07 15:11:07');
INSERT INTO `user_operation_log` VALUES (23, 2, '借阅书籍', '2024-12-07 15:11:18');
INSERT INTO `user_operation_log` VALUES (25, 2, '归还书籍', '2024-12-07 15:46:14');
INSERT INTO `user_operation_log` VALUES (26, 2, '归还书籍', '2024-12-07 15:46:39');
INSERT INTO `user_operation_log` VALUES (27, 2, '借阅书籍', '2024-12-07 15:53:02');
INSERT INTO `user_operation_log` VALUES (28, 2, '借阅书籍', '2024-12-07 15:59:16');
INSERT INTO `user_operation_log` VALUES (29, 2, '借阅书籍', '2024-12-07 15:59:24');
INSERT INTO `user_operation_log` VALUES (30, 2, '归还书籍', '2024-12-07 15:59:29');
INSERT INTO `user_operation_log` VALUES (31, 2, '借阅书籍', '2024-12-07 16:03:10');
INSERT INTO `user_operation_log` VALUES (32, 2, '归还书籍', '2024-12-07 16:03:15');
INSERT INTO `user_operation_log` VALUES (33, 2, '借阅书籍', '2024-12-07 16:03:47');
INSERT INTO `user_operation_log` VALUES (34, 2, '借阅书籍', '2024-12-07 16:04:41');
INSERT INTO `user_operation_log` VALUES (35, 2, '借阅书籍', '2024-12-07 16:04:41');
INSERT INTO `user_operation_log` VALUES (36, 2, '借阅书籍', '2024-12-07 16:05:09');
INSERT INTO `user_operation_log` VALUES (37, 2, '借阅书籍', '2024-12-07 16:05:17');
INSERT INTO `user_operation_log` VALUES (38, 2, '归还书籍', '2024-12-07 16:05:21');
INSERT INTO `user_operation_log` VALUES (39, 2, '借阅书籍', '2024-12-07 16:09:24');
INSERT INTO `user_operation_log` VALUES (40, 2, '归还书籍', '2024-12-07 16:09:29');
INSERT INTO `user_operation_log` VALUES (41, 2, '借阅书籍', '2024-12-07 16:13:35');
INSERT INTO `user_operation_log` VALUES (42, 2, '归还书籍', '2024-12-07 16:13:40');
INSERT INTO `user_operation_log` VALUES (43, 2, '借阅书籍', '2024-12-07 16:13:48');
INSERT INTO `user_operation_log` VALUES (44, 2, '归还书籍', '2024-12-07 16:13:51');
INSERT INTO `user_operation_log` VALUES (45, 2, '借阅书籍', '2024-12-07 16:14:20');
INSERT INTO `user_operation_log` VALUES (46, 2, '归还书籍', '2024-12-07 16:14:24');
INSERT INTO `user_operation_log` VALUES (47, 2, '借阅书籍', '2024-12-07 16:14:30');
INSERT INTO `user_operation_log` VALUES (48, 2, '归还书籍', '2024-12-07 16:14:32');
INSERT INTO `user_operation_log` VALUES (49, 2, '借阅书籍', '2024-12-07 16:17:15');
INSERT INTO `user_operation_log` VALUES (50, 2, '借阅书籍', '2024-12-07 16:17:36');
INSERT INTO `user_operation_log` VALUES (51, 2, '借阅书籍', '2024-12-08 15:54:45');
INSERT INTO `user_operation_log` VALUES (52, 2, '归还书籍', '2024-12-08 15:54:49');
INSERT INTO `user_operation_log` VALUES (53, 2, '借阅书籍', '2024-12-08 16:43:54');
INSERT INTO `user_operation_log` VALUES (54, 2, '归还书籍', '2024-12-08 16:44:03');

SET FOREIGN_KEY_CHECKS = 1;
