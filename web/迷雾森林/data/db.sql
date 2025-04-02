/*
 * db.sql 文件
 *
 * 此文件用于初始化你的 MySQL 数据库。
 * 它将在 Docker 容器启动时运行，
 * 并执行所有的 SQL 命令来设置你的数据库。
 *
 * 你可以在这里创建你的数据库，创建表，
 * 插入数据，或执行任何其他的 SQL 命令。
 *
 * 例如：
 *   CREATE DATABASE IF NOT EXISTS your_database;
 *   USE your_database;
 *   CREATE TABLE your_table (...);
 *   INSERT INTO your_table VALUES (...);
 *
 * 请根据你的需要修改此文件，
 */

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `emlog` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

GRANT all on emlog.* to 'gokuku'@'localhost' identified by 'tghs7^4He8&lA#3C';

USE `emlog`;

--
-- Table structure for table `emlog_attachment`
--

DROP TABLE IF EXISTS `emlog_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_attachment` (
  `aid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '资源文件表',
  `alias` varchar(64) NOT NULL DEFAULT '' COMMENT '资源别名',
  `author` int(11) unsigned NOT NULL DEFAULT 1 COMMENT '作者UID',
  `sortid` int(11) NOT NULL DEFAULT 0 COMMENT '分类ID',
  `blogid` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '文章ID（已废弃）',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT '文件名',
  `filesize` int(11) NOT NULL DEFAULT 0 COMMENT '文件大小',
  `filepath` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径',
  `addtime` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `width` int(11) NOT NULL DEFAULT 0 COMMENT '图片宽度',
  `height` int(11) NOT NULL DEFAULT 0 COMMENT '图片高度',
  `mimetype` varchar(40) NOT NULL DEFAULT '' COMMENT '文件mime类型',
  `thumfor` int(11) NOT NULL DEFAULT 0 COMMENT '缩略图的原资源ID（已废弃）',
  `download_count` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT '下载次数',
  PRIMARY KEY (`aid`),
  KEY `thum_uid` (`thumfor`,`author`),
  KEY `addtime` (`addtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_attachment`
--

LOCK TABLES `emlog_attachment` WRITE;
/*!40000 ALTER TABLE `emlog_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_blog`
--

DROP TABLE IF EXISTS `emlog_blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_blog` (
  `gid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章表',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章标题',
  `date` bigint(20) NOT NULL COMMENT '发布时间',
  `content` longtext NOT NULL COMMENT '文章内容',
  `excerpt` longtext NOT NULL COMMENT '文章摘要',
  `cover` varchar(255) NOT NULL DEFAULT '' COMMENT '封面图',
  `alias` varchar(255) NOT NULL DEFAULT '' COMMENT '文章别名',
  `author` int(11) NOT NULL DEFAULT 1 COMMENT '作者UID',
  `sortid` int(11) NOT NULL DEFAULT -1 COMMENT '分类ID',
  `type` varchar(20) NOT NULL DEFAULT 'blog' COMMENT '文章OR页面',
  `views` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '阅读量',
  `comnum` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '评论数量',
  `like_count` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '点赞量',
  `attnum` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '附件数量（已废弃）',
  `top` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '置顶',
  `sortop` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '分类置顶',
  `hide` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '草稿y',
  `checked` enum('n','y') NOT NULL DEFAULT 'y' COMMENT '文章是否审核',
  `allow_remark` enum('n','y') NOT NULL DEFAULT 'y' COMMENT '允许评论y',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '访问密码',
  `template` varchar(255) NOT NULL DEFAULT '' COMMENT '模板',
  `tags` text DEFAULT NULL COMMENT '标签',
  `link` varchar(255) NOT NULL DEFAULT '' COMMENT '文章跳转链接',
  `feedback` varchar(2048) NOT NULL DEFAULT '' COMMENT 'audit feedback',
  `parent_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT '文章层级关系-父级ID',
  PRIMARY KEY (`gid`),
  KEY `author` (`author`),
  KEY `views` (`views`),
  KEY `comnum` (`comnum`),
  KEY `sortid` (`sortid`),
  KEY `top` (`top`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_blog`
--

LOCK TABLES `emlog_blog` WRITE;
/*!40000 ALTER TABLE `emlog_blog` DISABLE KEYS */;
INSERT INTO `emlog_blog` VALUES (1,'第七日 雾月',-22063859503,'浓雾吞没了最后一丝天光，树影在雾气中扭曲成鬼魅。指南针在这里疯了似的打转，我只好用剑在树干刻下记号。黄昏时分，发现所有刻痕竟出现在同一棵树上——这森林在移动。夜里听见女人啜泣声，循声找到的却是倒挂在枯枝上的风铃草，花瓣滴着猩红汁液。','','','',1,-1,'blog',0,0,0,0,'n','n','n','y','n','','','','','',0),(2,'第九日 血月',-22061918443,'沼泽吞掉了半袋干粮，腐水里突然伸出藤蔓缠住脚踝。用星辰之刃斩断时，刃身沾到的藤汁竟在雾中发出荧光。顺着荧光找到树洞，里面堆着前人骸骨与半张羊皮卷，上面画着用月相推算隐士木屋方位的公式。','','','',1,-1,'blog',0,0,0,0,'n','n','n','y','n','','','','','',0),(3,'第十三日 影月',-22060818283,'追踪鹿群脚印时误入石阵，每块巨石都映出我死去的模样：被冰狼撕裂、坠入岩浆、在龙焰中哀嚎……最可怕的幻象是父亲举着铁锤骂我逞英雄。当星辰之刃刺向幻影父亲的刹那，剑锋突然被无形之力定格——原来破解方法是拥抱恐惧。幻象消散后，石阵中央升起青苔覆盖的木门。','','','',1,-1,'blog',0,0,0,0,'n','n','n','y','n','','','','','',0),(4,'终章·星光诞生之日',-22058949643,'隐士的白袍比雾更苍白，他桌上的水晶球里翻涌着整片森林的雾气。“能走到这里，说明你已学会用眼睛以外的器官看世界。”他敲碎水晶球，星光罗盘从碎片里浮出时，森林忽然有了风。现在我能听见雾在罗盘指针上滑过的簌簌声，像母亲纺线的节奏。跟着这声音走，晨露未干时，我已站在森林边缘，身后浓雾正在朝阳下蒸发成金色的纱。','','','',1,-1,'blog',0,0,0,0,'n','n','n','y','n','','','','','',0);
/*!40000 ALTER TABLE `emlog_blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_blog_fields`
--

DROP TABLE IF EXISTS `emlog_blog_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_blog_fields` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `gid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `field_key` varchar(255) DEFAULT '',
  `field_value` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gid` (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_blog_fields`
--

LOCK TABLES `emlog_blog_fields` WRITE;
/*!40000 ALTER TABLE `emlog_blog_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_blog_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_comment`
--

DROP TABLE IF EXISTS `emlog_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_comment` (
  `cid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '评论表',
  `gid` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '文章ID',
  `pid` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '父级评论ID',
  `top` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '置顶',
  `poster` varchar(20) NOT NULL DEFAULT '' COMMENT '发布人昵称',
  `avatar` varchar(512) NOT NULL DEFAULT '' COMMENT '头像URL',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '发布人UID',
  `comment` text NOT NULL COMMENT '评论内容',
  `mail` varchar(60) NOT NULL DEFAULT '' COMMENT 'email',
  `url` varchar(75) NOT NULL DEFAULT '' COMMENT 'homepage',
  `ip` varchar(128) NOT NULL DEFAULT '' COMMENT 'ip address',
  `agent` varchar(512) NOT NULL DEFAULT '' COMMENT 'user agent',
  `hide` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '是否审核',
  `date` bigint(20) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`cid`),
  KEY `gid` (`gid`),
  KEY `date` (`date`),
  KEY `hide` (`hide`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_comment`
--

LOCK TABLES `emlog_comment` WRITE;
/*!40000 ALTER TABLE `emlog_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_like`
--

DROP TABLE IF EXISTS `emlog_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_like` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '点赞表',
  `gid` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '文章ID',
  `poster` varchar(20) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(512) NOT NULL DEFAULT '' COMMENT '头像URL',
  `uid` int(11) NOT NULL DEFAULT 0,
  `ip` varchar(128) NOT NULL DEFAULT '',
  `agent` varchar(512) NOT NULL DEFAULT '',
  `date` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gid` (`gid`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_like`
--

LOCK TABLES `emlog_like` WRITE;
/*!40000 ALTER TABLE `emlog_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_link`
--

DROP TABLE IF EXISTS `emlog_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_link` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '链接表',
  `sitename` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `siteurl` varchar(255) NOT NULL DEFAULT '' COMMENT '地址',
  `icon` varchar(512) NOT NULL DEFAULT '' COMMENT '图标URL',
  `description` varchar(512) NOT NULL DEFAULT '' COMMENT '备注信息',
  `hide` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '是否隐藏',
  `taxis` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '排序序号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_link`
--

LOCK TABLES `emlog_link` WRITE;
/*!40000 ALTER TABLE `emlog_link` DISABLE KEYS */;
INSERT INTO `emlog_link` VALUES (1,'EMLOG','https://www.emlog.net','','emlog官方主页','n',0);
/*!40000 ALTER TABLE `emlog_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_media_sort`
--

DROP TABLE IF EXISTS `emlog_media_sort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_media_sort` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '资源分类表',
  `sortname` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_media_sort`
--

LOCK TABLES `emlog_media_sort` WRITE;
/*!40000 ALTER TABLE `emlog_media_sort` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_media_sort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_navi`
--

DROP TABLE IF EXISTS `emlog_navi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_navi` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '导航表',
  `naviname` varchar(30) NOT NULL DEFAULT '' COMMENT '导航名称',
  `url` varchar(512) NOT NULL DEFAULT '' COMMENT '导航地址',
  `newtab` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '在新窗口打开',
  `hide` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '是否隐藏',
  `taxis` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '排序序号',
  `pid` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '父级ID',
  `isdefault` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '是否系统默认导航，如首页',
  `type` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '导航类型 0自定义 1首页 2微语 3后台管理 4分类 5页面',
  `type_id` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '导航类型对应ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_navi`
--

LOCK TABLES `emlog_navi` WRITE;
/*!40000 ALTER TABLE `emlog_navi` DISABLE KEYS */;
INSERT INTO `emlog_navi` VALUES (1,'首页','','n','n',1,0,'y',1,0),(3,'登录','admin','n','n',3,0,'y',3,0);
/*!40000 ALTER TABLE `emlog_navi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_options`
--

DROP TABLE IF EXISTS `emlog_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_options` (
  `option_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '站点配置信息表',
  `option_name` varchar(75) NOT NULL COMMENT '配置项',
  `option_value` longtext NOT NULL COMMENT '配置项值',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name_uindex` (`option_name`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_options`
--

LOCK TABLES `emlog_options` WRITE;
/*!40000 ALTER TABLE `emlog_options` DISABLE KEYS */;
INSERT INTO `emlog_options` VALUES (1,'blogname','迷雾森林日记·残页'),(2,'bloginfo','在迷雾森林发现的日记'),(3,'site_title',''),(4,'site_description',''),(5,'site_key','emlog'),(6,'log_title_style','0'),(7,'blogurl','http://127.0.0.1:8080/'),(8,'icp',''),(9,'footer_info','艾尔文大陆屠龙试炼'),(10,'rss_output_num','10'),(11,'rss_output_fulltext','y'),(12,'index_lognum','10'),(13,'isfullsearch','n'),(14,'index_comnum','10'),(15,'index_newlognum','5'),(16,'index_hotlognum','5'),(17,'comment_subnum','20'),(18,'nonce_templet','default'),(19,'admin_style','default'),(20,'tpl_sidenum','1'),(21,'comment_code','n'),(22,'comment_needchinese','n'),(23,'comment_interval','60'),(24,'isgravatar','y'),(25,'isthumbnail','n'),(26,'att_maxsize','2048'),(27,'att_type','jpg,jpeg,png,gif,zip,rar'),(28,'att_imgmaxw','600'),(29,'att_imgmaxh','370'),(30,'comment_paging','n'),(31,'comment_pnum','10'),(32,'comment_order','newer'),(33,'iscomment','n'),(34,'login_comment','n'),(35,'ischkcomment','n'),(36,'isurlrewrite','0'),(37,'isalias','n'),(38,'isalias_html','n'),(39,'timezone','Asia/Shanghai'),(40,'active_plugins','a:2:{i:0;s:13:\"tips/tips.php\";i:1;s:27:\"tpl_options/tpl_options.php\";}'),(41,'widget_title','a:12:{s:7:\"blogger\";s:12:\"个人资料\";s:8:\"calendar\";s:6:\"日历\";s:3:\"tag\";s:6:\"标签\";s:7:\"twitter\";s:6:\"微语\";s:4:\"sort\";s:6:\"分类\";s:7:\"archive\";s:6:\"存档\";s:7:\"newcomm\";s:12:\"最新评论\";s:6:\"newlog\";s:12:\"最新文章\";s:6:\"hotlog\";s:12:\"热门文章\";s:4:\"link\";s:6:\"链接\";s:6:\"search\";s:6:\"搜索\";s:11:\"custom_text\";s:15:\"自定义组件\";}'),(42,'custom_widget','a:0:{}'),(43,'widgets1','a:3:{i:0;s:7:\"blogger\";i:1;s:7:\"newcomm\";i:2;s:6:\"search\";}'),(44,'detect_url','y'),(45,'emkey',''),(46,'login_code','n'),(47,'email_code','n'),(48,'is_signup','n'),(49,'ischkarticle','y'),(50,'article_uneditable','n'),(51,'forbid_user_upload','n'),(52,'posts_per_day','10'),(53,'smtp_mail',''),(54,'smtp_pw',''),(55,'smtp_server',''),(56,'smtp_port',''),(57,'is_openapi','n'),(58,'apikey','647933ecf505318bbab79a1ba7d5fb7f'),(59,'panel_menu_title',''),(60,'admin_article_perpage_num','20'),(61,'admin_user_perpage_num','20'),(62,'admin_comment_perpage_num','20'),(64,'emkey_type',''),(101,'posts_name','');
/*!40000 ALTER TABLE `emlog_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_order`
--

DROP TABLE IF EXISTS `emlog_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_order` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单表',
  `app_name` varchar(32) NOT NULL COMMENT '应用英文别名',
  `order_id` varchar(64) NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_uid` int(10) unsigned NOT NULL COMMENT '用户id',
  `out_trade_no` varchar(255) DEFAULT '' COMMENT '支付平台流水号',
  `pay_type` varchar(64) NOT NULL DEFAULT '' COMMENT '支付方式（alipay/wechat）',
  `sku_name` varchar(64) NOT NULL DEFAULT '' COMMENT '商品类型',
  `sku_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL COMMENT '应付金额',
  `pay_price` decimal(10,2) DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  `update_time` int(10) unsigned NOT NULL COMMENT '更新时间',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `idx_uid_ctime` (`order_uid`,`create_time`),
  KEY `idx_ctime` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_order`
--

LOCK TABLES `emlog_order` WRITE;
/*!40000 ALTER TABLE `emlog_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_sort`
--

DROP TABLE IF EXISTS `emlog_sort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_sort` (
  `sid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类表',
  `sortname` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名',
  `alias` varchar(255) NOT NULL DEFAULT '' COMMENT '别名',
  `taxis` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '排序序号',
  `pid` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '父分类ID',
  `description` text NOT NULL COMMENT '备注',
  `kw` varchar(2048) NOT NULL DEFAULT '' COMMENT '关键词',
  `title` varchar(2048) NOT NULL DEFAULT '' COMMENT '页面标题',
  `template` varchar(255) NOT NULL DEFAULT '' COMMENT '分类模板',
  `sortimg` varchar(512) NOT NULL DEFAULT '' COMMENT '分类图像',
  `page_count` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '每页文章数量',
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_sort`
--

LOCK TABLES `emlog_sort` WRITE;
/*!40000 ALTER TABLE `emlog_sort` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_sort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_storage`
--

DROP TABLE IF EXISTS `emlog_storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_storage` (
  `sid` int(8) NOT NULL AUTO_INCREMENT COMMENT '对象存储表',
  `plugin` varchar(32) NOT NULL COMMENT '插件名',
  `name` varchar(32) NOT NULL COMMENT '对象名',
  `type` varchar(8) NOT NULL COMMENT '对象数据类型',
  `value` text NOT NULL COMMENT '对象值',
  `createdate` int(11) NOT NULL COMMENT '创建时间',
  `lastupdate` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`sid`),
  UNIQUE KEY `plugin` (`plugin`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_storage`
--

LOCK TABLES `emlog_storage` WRITE;
/*!40000 ALTER TABLE `emlog_storage` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_tag`
--

DROP TABLE IF EXISTS `emlog_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_tag` (
  `tid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '标签表',
  `tagname` varchar(60) NOT NULL DEFAULT '' COMMENT '标签名',
  `description` varchar(2048) NOT NULL DEFAULT '' COMMENT '页面描述',
  `title` varchar(2048) NOT NULL DEFAULT '' COMMENT '页面标题',
  `kw` varchar(2048) NOT NULL DEFAULT '' COMMENT '关键词',
  `gid` text NOT NULL COMMENT '文章ID',
  PRIMARY KEY (`tid`),
  KEY `tagname` (`tagname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_tag`
--

LOCK TABLES `emlog_tag` WRITE;
/*!40000 ALTER TABLE `emlog_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_tpl_options_data`
--

DROP TABLE IF EXISTS `emlog_tpl_options_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_tpl_options_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `template` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `depend` varchar(64) NOT NULL DEFAULT '',
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `template` (`template`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_tpl_options_data`
--

LOCK TABLES `emlog_tpl_options_data` WRITE;
/*!40000 ALTER TABLE `emlog_tpl_options_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_tpl_options_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_twitter`
--

DROP TABLE IF EXISTS `emlog_twitter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_twitter` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '微语笔记表',
  `content` text NOT NULL COMMENT '微语内容',
  `img` varchar(255) DEFAULT NULL COMMENT '图片',
  `author` int(11) NOT NULL DEFAULT 1 COMMENT '作者UID',
  `date` bigint(20) NOT NULL COMMENT '创建时间',
  `replynum` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '回复数量',
  `private` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '是否私密',
  PRIMARY KEY (`id`),
  KEY `author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_twitter`
--

LOCK TABLES `emlog_twitter` WRITE;
/*!40000 ALTER TABLE `emlog_twitter` DISABLE KEYS */;
/*!40000 ALTER TABLE `emlog_twitter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emlog_user`
--

DROP TABLE IF EXISTS `emlog_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emlog_user` (
  `uid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户表',
  `username` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '用户密码',
  `nickname` varchar(20) NOT NULL DEFAULT '' COMMENT '昵称',
  `role` varchar(60) NOT NULL DEFAULT '' COMMENT '用户组',
  `ischeck` enum('n','y') NOT NULL DEFAULT 'n' COMMENT '内容是否需要管理员审核',
  `photo` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `email` varchar(60) NOT NULL DEFAULT '' COMMENT '邮箱',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `ip` varchar(128) NOT NULL DEFAULT '' COMMENT 'ip地址',
  `state` tinyint(4) NOT NULL DEFAULT 0 COMMENT '用户状态 0正常 1禁用',
  `credits` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '用户积分',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`uid`),
  KEY `username` (`username`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emlog_user`
--

LOCK TABLES `emlog_user` WRITE;
/*!40000 ALTER TABLE `emlog_user` DISABLE KEYS */;
INSERT INTO `emlog_user` VALUES (1,'gokuku','$P$B0L..O9/3PG5JTthAgf3KC.3wCGLhn0','goku','admin','n','','gokuku@emlog.me','艾尔文大陆上伟大的先知','172.18.0.1',0,0,1742390220,1743094952);
/*!40000 ALTER TABLE `emlog_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-27 17:15:16
