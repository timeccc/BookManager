/*
 Navicat Premium Data Transfer

 Source Server         : ninglibrary
 Source Server Type    : MySQL
 Source Server Version : 50741 (5.7.41-log)
 Source Host           : localhost:3306
 Source Schema         : book-manage-sys

 Target Server Type    : MySQL
 Target Server Version : 50741 (5.7.41-log)
 File Encoding         : 65001

 Date: 11/05/2025 15:48:08
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
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (17, '万历十五年', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=41db6371736355551108.jpg', '中华书局', '黄仁宇', '4632874328', 6, '万历十五年', 1, 1, 0, NULL, '2025-02-04 13:20:31');
INSERT INTO `book` VALUES (18, '狂人日记', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=84b81ad狂人日记.jpg', '中国友谊出版公司', '鲁迅', '9787505738478', 5, '《狂人日记：鲁迅小说全集》收录《呐喊》《彷徨》和《故事新编》中的全部小说，共计33篇。这些小说多描写底层社会普通人的悲剧，鲁迅以他如匕首般犀利的文笔批判着“麻木的国人灵魂”，希望藉此警醒世人。鲁迅小说的主题多是反封建、反礼教、反传统、反迷信，善于创造典型形象，讽刺人物的阴暗面，故事多以故乡为背景。小说主人公阿Q、祥林嫂、孔乙己、闰土等在中国众所周知。', 3, 3, 0, '2025-02-04', '2025-02-04 13:22:24');
INSERT INTO `book` VALUES (19, '人生', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=3745448cd420cd1735585716047.jpg', '北京十月文艺出版社', '路遥', '9787530217061', 5, '《人生》以陕北高原的城乡生活为背景，叙述了知识青年高加林回到家乡又离开家乡，再回归家乡的人生变化过程。《人生》讲述了一个年轻人面临的爱情与事业、理想与现实间的艰难选择，具有巨大的共情力量，说出了每个人，尤其是年轻人的困境、期待与追求。《人生》在有限生命中不懈追寻的激情，在每个人的心底激起回响；《人生》大地般宽广的气质，给予对生活失望的人莫大的安慰与力量。这是路遥的《人生》，也是我们每个人的人生。', 1, 7, 0, NULL, '2025-02-06 12:19:32');
INSERT INTO `book` VALUES (20, '云边有个小卖部', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=ae03a3a43f7fd11736359453637.jpg', '湖南文艺出版社', '张嘉佳', '9787540487645', 1, '刘十三自幼与开小卖部的外婆相依为命，努力读书为了离开小镇，追寻远方与梦想。在城市里碰壁受挫的刘十三回到了小镇，与少时玩伴程霜重逢。小镇生活平静却暗潮汹涌，一个孤儿，一场婚礼，一场意外，几乎打破了所有人的生活。', 3, 2, 0, NULL, '2025-02-06 12:21:03');
INSERT INTO `book` VALUES (21, '活着', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=cd1d0b41738815274532.jpg', '北京十月文艺出版社', '余华', '9787530215593', 5, '活着》是当代作家余华的代表作，讲述了一个人历尽世间沧桑和磨难的一生，亦将中国大半个世纪的社会变迁凝缩其间。《活着》还讲述了眼泪的宽广和丰富；讲述了绝望的不存在；讲述了人是为了活着本身而活着的，而不是为了活着之外的任何事物而活着。', 3, 3, 0, NULL, '2025-02-06 12:25:10');
INSERT INTO `book` VALUES (22, '长安的荔枝', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=44f1a999c2063a1735586486409.jpg', '湖南文艺出版社', '马伯庸', '9787572608582', 3, '大唐天宝十四年，长安城的小吏李善德突然接到一个任务：要在贵妃诞日之前，从岭南运来新鲜荔枝。荔枝“一日色变，两日香变，三日味变”，而岭南距长安五千余里，山水迢迢，这是个不可能完成的任务，可为了家人，李善德决心放手一搏：“就算失败，我也想知道，自己倒在距离终点多远的地方。”', 1, 5, 0, NULL, '2025-02-06 12:28:07');
INSERT INTO `book` VALUES (23, '圆圈正义', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=65ef57fdf2ac0d1736390601786.jpg', '中国法制出版社', '罗翔', '9787521603774', 5, '《圆圈正义》一书共收录作者的49篇随笔文章,分为“圆圈正义”“何谓榜样”“道德谴责的打开方式”“身负权力 各自珍重”“法律人的理智和多数人的情感”“生命的尊严”“心怀永恒 活在当下”七大部分，作者在本书中运用特有的坦诚、自省而尖锐的笔调，探讨了法律、正义、道德、权力的理念与现实、分析了如张扣扣案、莫某纵火案等社会热点案件、分享了自身求学经验和对人生的思考。本书不仅启蒙读者法律意识和法治观念，更在于帮助读者理解法律背后更深层次的价值基础。', 3, 5, 0, NULL, '2025-02-06 12:30:09');
INSERT INTO `book` VALUES (24, 'Python语言程序设计基础', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=974e8411738816368728.jpg', '高等教育出版社', '嵩天', '9787040471700', 3, '本书提出了以理解和运用计算生态为目标的Python语言教学思想，不仅系统讲解了Python语言语法，同时介绍了从数据理解到图像处理的14个Python函数库，向初学Python语言的读者展示了全新的编程语言学习路径。', 3, 7, 0, NULL, '2025-02-06 12:35:34');
INSERT INTO `book` VALUES (25, 'C程序设计', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=7741cb91738816577259.jpg', '清华大学出版社', '谭浩强', '9787302481447', 6, '本书按照C语言的新标准C 99进行介绍，所有程序都符合C 99的规定，使编写程序更加规范；对C语言和程序设计的基本概念和要点讲解透彻、全面而深入', 3, 7, 0, NULL, '2025-02-06 12:38:58');
INSERT INTO `book` VALUES (26, '生死疲劳', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=09b67b52c1487b1735585843416.jpg', '浙江文艺出版社', '莫言', '9787533966102', 5, '不看不知道，莫言真幽默！在极度痛苦时笑出声来，获得内心深处的解脱。', 1, 3, 0, NULL, '2025-04-27 17:15:12');
INSERT INTO `book` VALUES (27, '平凡的世界', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=4eaa7351736355494827.jpg', '北京十月文艺出版社', '路遥', '9787530221396', 6, '《平凡的世界》是一段平凡却热血、温暖又动人的成长故事，小说以孙少平与孙少安两兄弟为主角，讲述他们在生活中面临重重困难与挑战，却依然无畏前行的人生历程。《平凡的世界》深刻展示了普通人在大时代中走过的平凡却不平庸的道路，细腻书写亲情、爱情和友情，饱含真善美和昂扬向上的力量，今天读来依然让人充满共鸣，更给人以激励。《平凡的世界》是一部跨时代的经典，在反映时代的同时超越时代，散发出经久不衰的魅力。', 3, 2, 0, NULL, '2025-04-27 18:51:47');
INSERT INTO `book` VALUES (28, '曾国藩传', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=6103ed6曾国藩.jpg', '民主与建设出版社', '张宏杰', '9787513921091', 5, '曾国藩，没有显赫的家世，天赋堪称晚清同时代大人物当中最差，却官至两江总督、直隶总督、武英殿大学士，在复杂的时代变局中超越众人，成就最大，被誉为大清“中兴第一名臣”，且最后全身而退。他的人生经历，无论是过去还是现在都给人以特别的启示。', 1, 1, 0, NULL, '2025-04-27 18:53:27');
INSERT INTO `book` VALUES (29, '诗经', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=b5015d60a522411736402267505-1609463607.jpg', '浙江人出版社', '小岩井', '9787213100376', 3, '《诗经》是中国古代最早的诗歌总集，收录了305首诗歌，分为《风》《雅》《颂》三个部分，内容涵盖了西周初年至春秋中叶的诗歌。它不仅创立了中国诗歌史上第一个有形的历史阶段，还对后世的诗歌创作产生了深远的影响。', 3, 3, 0, '2025-05-04', '2025-05-02 22:56:27');

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
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_order_history
-- ----------------------------
INSERT INTO `book_order_history` VALUES (29, 17, 18, 1, 1, '2025-02-05', '2025-02-04 13:33:19');
INSERT INTO `book_order_history` VALUES (30, 22, 21, 1, 1, '2025-05-02', '2025-05-02 22:14:47');
INSERT INTO `book_order_history` VALUES (31, 26, 21, 2, 0, '2025-05-03', '2025-05-02 22:45:30');

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_rss_history
-- ----------------------------
INSERT INTO `book_rss_history` VALUES (11, 18, 18, '2025-02-04 21:52:51');
INSERT INTO `book_rss_history` VALUES (12, 18, 20, '2025-02-07 18:58:54');
INSERT INTO `book_rss_history` VALUES (13, 29, 21, '2025-05-02 22:58:27');

-- ----------------------------
-- Table structure for book_save
-- ----------------------------
DROP TABLE IF EXISTS `book_save`;
CREATE TABLE `book_save`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图书收藏主键ID',
  `book_id` int(11) NULL DEFAULT NULL COMMENT '图书ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_save
-- ----------------------------
INSERT INTO `book_save` VALUES (16, 15, 2);
INSERT INTO `book_save` VALUES (17, 14, 2);
INSERT INTO `book_save` VALUES (19, 24, 18);
INSERT INTO `book_save` VALUES (20, 27, 20);
INSERT INTO `book_save` VALUES (21, 27, 21);
INSERT INTO `book_save` VALUES (22, 26, 21);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '历史');
INSERT INTO `category` VALUES (2, '小说');
INSERT INTO `category` VALUES (3, '文学');
INSERT INTO `category` VALUES (5, '社科');
INSERT INTO `category` VALUES (7, '技术');

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (15, 'Vue.js 的核心概念和技术的总结', '<h3 style=\"text-align: start;\"></h3><h1 style=\"text-align: center;\">Vue.js 的核心概念和技术的总结</h1><h3 style=\"text-align: start;\">1. <strong>Vue 实例</strong></h3><ul><li style=\"text-align: start;\">创建 Vue 实例：通过 new Vue() 创建一个 Vue 应用实例，并将其挂载到 DOM 元素上。</li><li style=\"text-align: start;\">选项对象：传递给 Vue 构造函数的对象包含多个属性，如 data, methods, computed, watch 等。</li></ul><pre style=\"text-align: left;\"><code>&nbsp;new Vue({&nbsp; &nbsp;el: \'#app\',&nbsp; &nbsp;data: {&nbsp; &nbsp; &nbsp;message: \'Hello Vue!\'&nbsp;  },&nbsp; &nbsp;methods: {&nbsp; &nbsp; &nbsp;greet() {&nbsp; &nbsp; &nbsp; &nbsp;return this.message;&nbsp; &nbsp;  }&nbsp;  }&nbsp;});</code></pre><h3 style=\"text-align: start;\">2. <strong>模板语法</strong></h3><ul><li style=\"text-align: start;\">插值 (Interpolation)：使用双大括号 {{ }} 插入数据。</li><li style=\"text-align: start;\">指令 (Directives)：以 v- 开头的特殊属性，用于绑定数据、条件渲染、列表渲染等。v-bind: 动态绑定HTML属性。v-on: 绑定事件监听器。v-if/v-else/v-show: 条件渲染。v-for: 列表渲染。</li></ul><pre style=\"text-align: left;\"><code>&nbsp;&lt;div id=\"app\"&gt;&nbsp; &nbsp;&lt;p&gt;{{ message }}&lt;/p&gt;&nbsp; &nbsp;&lt;button v-on:click=\"greet\"&gt;Greet&lt;/button&gt;&nbsp; &nbsp;&lt;ul&gt;&nbsp; &nbsp; &nbsp;&lt;li v-for=\"(item, index) in items\" :key=\"index\"&gt;{{ item }}&lt;/li&gt;&nbsp; &nbsp;&lt;/ul&gt;&nbsp;&lt;/div&gt;</code></pre><h3 style=\"text-align: start;\">3. <strong>组件化开发</strong></h3><ul><li style=\"text-align: start;\">定义组件：使用 Vue.component 或在单文件组件（.vue 文件）中定义可复用的组件。</li><li style=\"text-align: start;\">局部注册组件：在父组件内部注册子组件。</li><li style=\"text-align: start;\">全局注册组件：在整个应用中可用。</li></ul><pre style=\"text-align: left;\"><code>&nbsp;Vue.component(\'my-component\', {&nbsp; &nbsp;template: \'&lt;div&gt;A custom component!&lt;/div&gt;\'&nbsp;});&nbsp;​&nbsp;new Vue({ el: \'#app\' });</code></pre><h3 style=\"text-align: start;\">4. <strong>计算属性与侦听器</strong></h3><ul><li style=\"text-align: start;\">计算属性 (Computed Properties)：基于其他数据属性自动计算的结果。</li><li style=\"text-align: start;\">侦听器 (Watchers)：当某个数据属性变化时执行异步或开销较大的操作。</li></ul><pre style=\"text-align: left;\"><code>&nbsp;new Vue({&nbsp; &nbsp;el: \'#app\',&nbsp; &nbsp;data: {&nbsp; &nbsp; &nbsp;firstName: \'John\',&nbsp; &nbsp; &nbsp;lastName: \'Doe\'&nbsp;  },&nbsp; &nbsp;computed: {&nbsp; &nbsp; &nbsp;fullName() {&nbsp; &nbsp; &nbsp; &nbsp;return `${this.firstName} ${this.lastName}`;&nbsp; &nbsp;  }&nbsp;  },&nbsp; &nbsp;watch: {&nbsp; &nbsp; &nbsp;firstName(newVal) {&nbsp; &nbsp; &nbsp; &nbsp;console.log(`First name changed to ${newVal}`);&nbsp; &nbsp;  }&nbsp;  }&nbsp;});</code></pre><h3 style=\"text-align: start;\">5. <strong>状态管理</strong></h3><ul><li style=\"text-align: start;\">Vuex：官方的状态管理模式和库，用于集中管理和共享应用程序的状态。Store: 存储状态的地方。Mutations: 同步更改状态的方法。Actions: 处理异步操作。Getters: 类似于计算属性，用于从 store 中派生出一些状态。</li></ul><pre style=\"text-align: left;\"><code>&nbsp;import Vue from \'vue\';&nbsp;import Vuex from \'vuex\';&nbsp;​&nbsp;Vue.use(Vuex);&nbsp;​&nbsp;const store = new Vuex.Store({&nbsp; &nbsp;state: {&nbsp; &nbsp; &nbsp;count: 0&nbsp;  },&nbsp; &nbsp;mutations: {&nbsp; &nbsp; &nbsp;increment(state) {&nbsp; &nbsp; &nbsp; &nbsp;state.count++;&nbsp; &nbsp;  }&nbsp;  },&nbsp; &nbsp;actions: {&nbsp; &nbsp; &nbsp;increment({ commit }) {&nbsp; &nbsp; &nbsp; &nbsp;commit(\'increment\');&nbsp; &nbsp;  }&nbsp;  },&nbsp; &nbsp;getters: {&nbsp; &nbsp; &nbsp;doubleCount: state =&gt; state.count * 2&nbsp;  }&nbsp;});</code></pre><h3 style=\"text-align: start;\">6. <strong>路由管理</strong></h3><ul><li style=\"text-align: start;\">Vue Router：官方的路由管理库，允许创建单页面应用（SPA），支持动态加载组件、导航守卫等功能。</li></ul><pre style=\"text-align: left;\"><code>&nbsp;import Vue from \'vue\';&nbsp;import VueRouter from \'vue-router\';&nbsp;import Home from \'./components/Home.vue\';&nbsp;import About from \'./components/About.vue\';&nbsp;​&nbsp;Vue.use(VueRouter);&nbsp;​&nbsp;const routes = [&nbsp;  { path: \'/\', component: Home },&nbsp;  { path: \'/about\', component: About }&nbsp;];&nbsp;​&nbsp;const router = new VueRouter({&nbsp; &nbsp;routes // 简写为 `routes: routes`&nbsp;});&nbsp;​&nbsp;new Vue({&nbsp; &nbsp;router,&nbsp; &nbsp;render: h =&gt; h(App)&nbsp;}).$mount(\'#app\');</code></pre><h3 style=\"text-align: start;\">7. <strong>生命周期钩子</strong></h3><ul><li style=\"text-align: start;\">生命周期图：了解 Vue 实例从创建到销毁的各个阶段。</li><li style=\"text-align: start;\">常用钩子：beforeCreatecreatedbeforeMountmountedbeforeUpdateupdatedbeforeDestroydestroyed</li></ul><pre style=\"text-align: left;\"><code>&nbsp;new Vue({&nbsp; &nbsp;el: \'#app\',&nbsp; &nbsp;mounted() {&nbsp; &nbsp; &nbsp;console.log(\'Component has been mounted.\');&nbsp;  }&nbsp;});</code></pre><h3 style=\"text-align: start;\">8. <strong>工具与生态</strong></h3><ul><li style=\"text-align: start;\">Vue CLI：命令行工具，简化项目的搭建、配置和脚本编写。</li><li style=\"text-align: start;\">Vuetify / Element UI / BootstrapVue：流行的 UI 框架，提供丰富的预构建组件。</li><li style=\"text-align: start;\">Vue Devtools：浏览器扩展，帮助调试 Vue 应用。</li></ul><h3 style=\"text-align: start;\">9. <strong>响应式原理</strong></h3><ul><li style=\"text-align: start;\">响应式系统：理解 Vue 如何通过依赖追踪和观察者模式实现双向数据绑定。</li><li style=\"text-align: start;\">虚拟 DOM：Vue 使用虚拟 DOM 提高渲染效率，减少直接操作真实 DOM 的次数。</li></ul><h3 style=\"text-align: start;\">10. <strong>最佳实践</strong></h3><ul><li style=\"text-align: start;\">保持组件单一职责：每个组件应该只负责一个小任务。</li><li style=\"text-align: start;\">合理拆分逻辑：将复杂逻辑分解成小函数或辅助函数。</li><li style=\"text-align: start;\">遵循官方风格指南：确保代码的一致性和可读性。</li></ul><h3 style=\"text-align: start;\">总结</h3><p style=\"text-align: start;\">以上内容覆盖了 Vue.js 的基础知识和常见特性，适合初学者学习和掌握。随着经验的增长，你可以深入研究更高级的主题，如性能优化、测试、国际化支持等。如果你有具体的问题或者需要进一步的帮助，请随时提问！</p><p><br></p>', '2025-02-04 13:25:32');
INSERT INTO `notice` VALUES (17, '错误信息TypeError: Cannot read property \'parseComponent\' of undefined', '<p><br></p><p style=\"text-align: start;\">你遇到的错误信息 <code>TypeError: Cannot read property \'parseComponent\' of undefined</code> 通常与 Vue 单文件组件（SFCs）处理相关的问题有关。这个错误表明在尝试解析 <code>.vue</code> 文件时，某个工具或库试图访问一个未定义对象的 <code>parseComponent</code> 方法。</p><p style=\"text-align: start;\">以下是一些可能的原因和解决方法：</p><ol><li style=\"text-align: start;\">Vue 或相关依赖版本问题：确保你使用的 Vue CLI、Vue 版本以及相关的依赖（如 @vue/compiler-sfc）是兼容的。如果你最近更新了某些包，请检查是否有不兼容的情况发生。可以尝试更新所有依赖到最新版本或者回退到之前稳定工作的版本。</li><li style=\"text-align: start;\">Babel 配置问题：如果你的项目使用 Babel 进行转译，确保 Babel 和其插件配置正确，特别是涉及到 Vue 的插件，如 @vue/babel-plugin-jsx（如果适用）。</li><li style=\"text-align: start;\">缓存问题：尝试清除 npm 缓存，并删除 node_modules 目录和 package-lock.json 文件后重新安装依赖。 npm cache clean --force rm -rf node_modules package-lock.json npm install</li><li style=\"text-align: start;\">检查 Webpack 配置：如果你自定义了 Webpack 配置，确保正确配置了处理 .vue 文件的规则。这通常涉及到 vue-loader 的正确使用。</li><li style=\"text-align: start;\">具体查看出错的文件：错误日志中提到的 ./src/App.vue 文件可能包含有问题的代码。检查该文件中的语法错误、缺失的模块导入或其他异常情况。确保 &lt;template&gt;, &lt;script&gt;, 和 &lt;style&gt; 标签都正确闭合，且没有拼写错误。</li><li style=\"text-align: start;\">环境问题：确认你的开发环境设置正确。例如，确保全局安装的 Vue CLI 版本与项目所需的版本相匹配。</li></ol><p style=\"text-align: start;\">通过以上步骤，你应该能够找到并解决导致 <code>Cannot read property \'parseComponent\' of undefined</code> 错误的原因。如果问题依旧存在，提供更多的上下文信息（如 <code>package.json</code> 中的相关依赖版本、Webpack 配置等）会有助于更精确地定位问题所在。</p>', '2025-02-04 13:35:10');
INSERT INTO `notice` VALUES (19, 'MCP及与大模型的关系', '<p>MCP（Mixture of Competing Predictors）可以理解为“竞争预测器混合模型”，是一种用于提升模型性能的技术，它和大模型有紧密的联系，以下是具体介绍：</p><h3 style=\"text-align: start;\">MCP是什么</h3><ul><li style=\"text-align: start;\">简单解释：MCP是一种将多个不同的预测器（可以理解为不同的模型或者模型的不同部分）组合在一起的方法。这些预测器会“竞争”着对同一个问题进行预测，然后通过一定的策略将它们的预测结果综合起来，得到最终的预测结果。就好比一个团队中有多个专家，每个专家都有自己擅长的领域和判断方式，他们各自给出答案，最后团队综合这些答案做出最终决策。</li><li style=\"text-align: start;\">工作原理：在MCP中，每个预测器都有自己的预测结果和置信度（可以理解为对自己预测结果的信心程度）。在预测时，每个预测器会先给出自己的预测结果和置信度，然后根据这些置信度来分配权重，权重高的预测器对最终结果的贡献更大。例如，有三个预测器A、B、C，它们对某个问题的预测结果分别是1、2、3，置信度分别是0.9、0.6、0.5，那么最终的预测结果会更倾向于A的预测结果1，但也会综合考虑B和C的结果，最终结果可能是1.2左右。</li></ul><h3 style=\"text-align: start;\">MCP和大模型的关系</h3><ul><li style=\"text-align: start;\">提升大模型性能：大模型虽然参数众多、能力强大，但在某些情况下也会出现预测不准确的情况。MCP可以作为大模型的“辅助工具”，通过引入多个不同的预测器（这些预测器可以是大模型的不同部分，也可以是其他小模型），让大模型的预测更加准确、鲁棒。比如，大模型在处理一些复杂的自然语言处理任务时，可能会对某些边缘情况或罕见的表达方式预测不准，MCP中的其他预测器可以补充大模型的不足，提高整体预测效果。</li><li style=\"text-align: start;\">优化大模型资源利用：大模型的计算资源消耗非常大，而MCP可以通过合理分配任务给不同的预测器，避免大模型在所有任务上都“大材小用”，从而优化资源利用。例如，在一些简单的任务上，可以让小模型或者大模型的轻量级部分来处理，而在复杂的任务上再让大模型的主体部分发力，这样可以节省计算资源，提高效率。</li><li style=\"text-align: start;\">增强大模型的泛化能力：大模型在训练数据上表现很好，但在面对新的、未见过的数据时，可能会出现泛化能力不足的问题。MCP中的多个预测器有不同的特点和优势，它们的组合可以更好地适应各种不同的数据分布，从而增强大模型的泛化能力，让大模型在面对各种复杂多变的实际情况时都能有较好的表现。</li></ul>', '2025-04-28 14:06:21');
INSERT INTO `notice` VALUES (20, '陕北红军和红26军的建立', '<p style=\"text-align: start;\">红二十六军和陕北红军是中国共产党在土地革命战争时期于西北地区创建的重要革命武装力量，二者在建立过程中相互配合、相互支援，共同为西北革命根据地的创建和发展做出了巨大贡献。以下是关于它们的建立过程及关系的详细介绍：</p><h3 style=\"text-align: start;\">一、红二十六军的建立过程</h3><ul><li style=\"text-align: start;\">背景与初期</li></ul><p style=\"text-indent: 2em; text-align: start;\">斗争大革命失败后，刘志丹、谢子长等共产党人遵照中共陕西省委的指示，开始了艰难曲折的创建革命武装活动。1931年9月，刘志丹在陕甘边界的南梁地区建立了南梁游击队，这是红二十六军的前身之一。1932年初，南梁游击队与晋西游击队等队伍会合，改编为西北反帝同盟军，后进一步改编为中国工农红军陕甘游击队。</p><ul><li style=\"text-align: start;\">正式成立与初期发展</li></ul><p style=\"text-indent: 2em; text-align: start;\">1932年12月，中共陕西省委将陕甘游击队改编为中国工农红军第二十六军第二团，标志着红二十六军的正式成立。成立初期，红二十六军面临着敌人的残酷“围剿”和内部的“左”倾错误指导，但仍在刘志丹等领导人的带领下，坚持斗争，逐步发展壮大。</p><ul><li style=\"text-align: start;\">重建与壮大</li></ul><p style=\"text-indent: 2em; text-align: start;\">1933年5月，红二十六军在南下途中遭国民党军阻击而失败，但幸存的红军领导人和骨干返回根据地后，继续坚持斗争。1933年11月，红二十六军在渭北根据地重建，并逐步发展壮大，先后组建了多个团和游击队。至1934年秋，红二十六军已发展成为一支拥有2000余人的主力红军，开辟了以南梁为中心的陕甘边革命根据地。</p><h3 style=\"text-align: start;\">二、陕北红军的建立过程</h3><ul><li style=\"text-align: start;\">背景与初期斗争</li></ul><p style=\"text-indent: 2em; text-align: start;\">在红二十六军建立的同时，陕北地区的共产党人也积极开展武装斗争，创建革命根据地。1931年秋至1932年，刘志丹、谢子长等领导人在陕北地区发动了一系列武装起义和游击战争，为陕北红军的建立奠定了基础。</p><ul><li style=\"text-align: start;\">正式成立与发展</li></ul><p style=\"text-indent: 2em; text-align: start;\">1934年底至1935年初，中共陕北特委将原陕北游击队组建的陕北红军第一、二、三团合编为中国工农红军第二十七军八十四师，标志着陕北红军的正式成立。陕北红军成立后，积极配合红二十六军作战，共同打击敌人，保卫和发展革命根据地。</p><h3 style=\"text-align: start;\">三、红二十六军与陕北红军的关系</h3><ul><li style=\"text-align: start;\">相互配合与支援</li></ul><p style=\"text-align: start;\">红二十六军和陕北红军在建立过程中相互配合、相互支援，共同应对敌人的“围剿”和进攻。它们经常联合行动，共同打击敌人，保卫和发展革命根据地。</p><ul><li style=\"text-align: start;\">统一领导与指挥</li></ul><p style=\"text-align: start;\">1935年2月，中共陕甘边和陕北两特委商议成立党的西北工委和西北革命军事委员会，统一领导两区的党组织和红军。从此，陕甘边红军（包括红二十六军）和陕北红军统称为西北红军，在西北工委和西北革命军事委员会的统一领导下进行斗争。</p><ul><li style=\"text-align: start;\">共同的历史贡献</li></ul><p style=\"text-align: start;\">红二十六军和陕北红军在土地革命战争时期共同为西北革命根据地的创建和发展做出了巨大贡献。它们不仅保卫了革命根据地的安全，还积极向外扩张，打击敌人，为中国革命的胜利奠定了坚实基础。</p>', '2025-05-01 16:39:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of reader_proposal
-- ----------------------------
INSERT INTO `reader_proposal` VALUES (15, 21, '对于部分学生来说，白天可能没有太多时间去图书馆。可以考虑在周末和节假日适当延长开放时间，比如从早上9点开放到晚上9点，方便读者利用课余时间和休息时间来阅读和学习。', 1, '我们会综合考虑图书馆的人力资源、运营成本以及读者的实际需求，努力在保障服务质量的前提下，尽可能延长开放时间。如果能够实现，我们计划将周末和节假日的开放时间从早上9点延长至晚上9点，以便读者能够在课余时间和休息时间更自由地安排阅读和学习。', '2025-02-06 13:23:44', 1, '2025-02-06 12:56:59');
INSERT INTO `reader_proposal` VALUES (17, 20, '增加书籍种类和数量： 增加一些热门领域、新兴学科以及小众但有价值的书籍，对于一些热门小说系列，可以多采购几套，以满足不同读者同时借阅的需求', 1, '我们非常重视您的需求，会尽快着手调整图书采购计划。针对热门领域、新兴学科以及小众但有价值的书籍，我们会安排专人进行市场调研和专家咨询，争取在下一次采购中增加相关书籍的种类和数量。同时，对于热门小说系列，我们会根据借阅数据和读者反馈，适当增加采购套数，以满足更多读者同时借阅的需求。请您继续关注图书馆的公告和新书推荐，我们会及时更新书籍信息。再次感谢您对图书馆的支持！', '2025-02-06 13:28:40', 1, '2025-02-06 13:27:29');
INSERT INTO `reader_proposal` VALUES (19, 18, '根据不同功能划分区域，比如设置安静的阅读区、小组讨论区、儿童阅读区等。在安静阅读区，要保证环境安静，桌椅舒适，适合个人阅读和学习；小组讨论区则可以配备白板、投影仪等设备，方便读者进行小组学习和讨论。', 0, '我们会尽快完成区域划分的规划，并逐步实施。在实施过程中，我们也会根据读者的反馈进行调整和优化，确保各个功能区都能发挥最大的效用。感谢您的建议，我们会努力让图书馆成为一个更加舒适、便捷、高效的学习和阅读空间！', '2025-02-06 13:29:01', 1, '2025-02-06 13:28:12');
INSERT INTO `reader_proposal` VALUES (20, 20, '我发现图书馆有些区域的灯光比较暗，而且桌椅有些陈旧。如果能更换一些更舒适的桌椅，增加一些照明设备，让环境更舒适，那会让我们更愿意在图书馆学习。', 1, '我们计划对图书馆的照明系统进行全面升级，采用高效节能的LED灯具，这些灯具不仅亮度更高、光线更柔和，还能有效减少眼睛疲劳。同时，我们会根据不同的功能区域（如阅读区、讨论区等）调整照明布局，确保光线均匀分布。此外，我们也会考虑在部分阅读桌上增加可调节亮度的台灯，以满足不同读者的需求。', '2025-02-06 13:52:25', 1, '2025-02-06 13:51:09');
INSERT INTO `reader_proposal` VALUES (21, 16, '图书馆的照明可以更加人性化，考虑自然光引入或采用更柔和舒适的灯具，减少阅读疲劳。增加绿植点缀，营造更轻松的阅读氛围。座椅布局可以更加多样化，提供不同高度和软硬度的选择，满足不同读者的需求，提升整体舒适度。', 1, '您的想法很有价值，我们会进行评估。', '2025-05-03 23:52:52', 1, '2025-05-03 23:42:42');
INSERT INTO `reader_proposal` VALUES (25, 21, '引入更多自助服务设备，如图书自助借还机、打印复印一体机等，提升服务效率，减少人工成本。探索AR/VR等新技术在阅读推广和信息展示中的应用，为读者带来更沉浸式的体验。建立完善的读者意见反馈平台，利用数据分析优化服务和资源配置。', 1, '收到，我们会认真考虑您的建议', '2025-05-05 15:27:26', 1, '2025-05-05 15:26:47');
INSERT INTO `reader_proposal` VALUES (26, 19, '利用社交媒体平台、网站等多种渠道，积极推广图书馆的资源和服务，吸引更多潜在读者。设计新颖有趣的宣传品，策划主题书展和阅读活动，提高图书馆的知名度和吸引力。与本地媒体合作，扩大宣传范围。', 0, '我们会将您的建议纳入未来的规划中。', '2025-05-05 15:32:28', 1, '2025-05-05 15:31:33');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rss_notification
-- ----------------------------
INSERT INTO `rss_notification` VALUES (1, 18, '您好，您订阅的由鲁迅创作的书籍【狂人日记】已经上线，可以借阅了', 0, '2025-04-28 21:39:16');
INSERT INTO `rss_notification` VALUES (2, 20, '您好，您订阅的由鲁迅创作的书籍【狂人日记】已经上线，可以借阅了', 1, '2025-04-28 21:39:16');
INSERT INTO `rss_notification` VALUES (3, 21, '您好，您订阅的由小岩井创作的书籍【诗经】已经上线，可以借阅了', 0, '2025-05-03 00:55:24');

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
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (16, 'xuetao', '薛涛', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=f73819243b6f791736485060550.jpg', '4638468@qq.com', 1, 0, 0, '2025-02-04 13:16:23');
INSERT INTO `user` VALUES (17, 'xiedaoyun', '谢道韫', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=a7f48541736421334907.jpeg', '1552933@qq.com', 1, 0, 0, '2025-02-04 13:17:56');
INSERT INTO `user` VALUES (18, 'liqingzhao', '李清照', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=1536d68TheCatandtheMaiden6.jpg', '6432864@qq.com', 2, 0, 0, '2025-02-04 13:30:44');
INSERT INTO `user` VALUES (19, 'banzhao', '班昭', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=f7b0d1bIMG_20250502_214459.png', '4628534@qq.com', 2, 0, 1, '2025-02-05 15:17:25');
INSERT INTO `user` VALUES (20, 'chenlin', '陈琳', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=ef3a37f3a31d3b1736421319612.jpeg', '5482342@qq.com', 2, 1, 1, '2025-02-06 12:51:51');
INSERT INTO `user` VALUES (21, 'caiwenji', '蔡文姬', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=cdd179fTheCatandtheMaiden1.jpg', '5432754@qq.com', 2, 0, 0, '2025-02-06 12:54:56');
INSERT INTO `user` VALUES (22, 'zhuowenjun', '卓文君', '14e1b600b1fd579f47433b88e8d85291', '/api/book-manage-sys-api/v1.0/file/getFile?fileName=eaded482521318.jpg', '764324@qq.com', 2, 0, 0, '2025-05-11 14:39:12');

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
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_operation_log
-- ----------------------------
INSERT INTO `user_operation_log` VALUES (57, 18, '向系统提交建议', '2025-02-05 01:45:40');
INSERT INTO `user_operation_log` VALUES (58, 21, '向系统提交建议', '2025-02-06 12:56:59');
INSERT INTO `user_operation_log` VALUES (59, 20, '向系统提交建议', '2025-02-06 12:58:04');
INSERT INTO `user_operation_log` VALUES (60, 20, '向系统提交建议', '2025-02-06 13:27:29');
INSERT INTO `user_operation_log` VALUES (61, 20, '向系统提交建议', '2025-02-06 13:28:04');
INSERT INTO `user_operation_log` VALUES (62, 18, '向系统提交建议', '2025-02-06 13:28:12');
INSERT INTO `user_operation_log` VALUES (63, 20, '向系统提交建议', '2025-02-06 13:51:09');
INSERT INTO `user_operation_log` VALUES (64, 20, '向系统提交建议', '2025-02-06 19:26:14');
INSERT INTO `user_operation_log` VALUES (65, 20, '向系统提交建议', '2025-02-06 19:27:40');
INSERT INTO `user_operation_log` VALUES (66, 20, '向系统提交建议', '2025-02-06 19:28:01');
INSERT INTO `user_operation_log` VALUES (67, 21, '借阅书籍', '2025-05-02 22:14:47');
INSERT INTO `user_operation_log` VALUES (68, 21, '借阅书籍', '2025-05-02 22:45:30');
INSERT INTO `user_operation_log` VALUES (69, 21, '归还书籍', '2025-05-02 22:45:37');
INSERT INTO `user_operation_log` VALUES (70, 16, '向系统提交建议', '2025-05-03 23:42:42');
INSERT INTO `user_operation_log` VALUES (71, 16, '向系统提交建议', '2025-05-03 23:43:26');
INSERT INTO `user_operation_log` VALUES (72, 19, '向系统提交建议', '2025-05-03 23:45:37');
INSERT INTO `user_operation_log` VALUES (73, 21, '向系统提交建议', '2025-05-05 15:25:00');
INSERT INTO `user_operation_log` VALUES (74, 21, '向系统提交建议', '2025-05-05 15:26:47');
INSERT INTO `user_operation_log` VALUES (75, 19, '向系统提交建议', '2025-05-05 15:30:23');
INSERT INTO `user_operation_log` VALUES (76, 19, '向系统提交建议', '2025-05-05 15:30:27');
INSERT INTO `user_operation_log` VALUES (77, 19, '向系统提交建议', '2025-05-05 15:30:30');
INSERT INTO `user_operation_log` VALUES (78, 19, '向系统提交建议', '2025-05-05 15:30:30');
INSERT INTO `user_operation_log` VALUES (79, 19, '向系统提交建议', '2025-05-05 15:31:11');
INSERT INTO `user_operation_log` VALUES (80, 19, '向系统提交建议', '2025-05-05 15:31:33');

SET FOREIGN_KEY_CHECKS = 1;
