-- MySQL dump 10.17  Distrib 10.3.18-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: zabbix
-- ------------------------------------------------------
-- Server version       10.3.18-MariaDB-1:10.3.18+maria~bionic-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--
use zabbix;

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `userid` bigint(20) unsigned NOT NULL,
  `username` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT '',
  `name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `surname` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `passwd` varchar(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `url` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `autologin` int(11) NOT NULL DEFAULT 0,
  `autologout` varchar(32) COLLATE utf8_bin NOT NULL DEFAULT '15m',
  `lang` varchar(7) COLLATE utf8_bin NOT NULL DEFAULT 'default',
  `refresh` varchar(32) COLLATE utf8_bin NOT NULL DEFAULT '30s',
  `theme` varchar(128) COLLATE utf8_bin NOT NULL DEFAULT 'default',
  `attempt_failed` int(11) NOT NULL DEFAULT 0,
  `attempt_ip` varchar(39) COLLATE utf8_bin NOT NULL DEFAULT '',
  `attempt_clock` int(11) NOT NULL DEFAULT 0,
  `rows_per_page` int(11) NOT NULL DEFAULT 50,
  `timezone` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT 'default',
  `roleid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `users_1` (`username`),
  KEY `c_users_1` (`roleid`),
  CONSTRAINT `c_users_1` FOREIGN KEY (`roleid`) REFERENCES `role` (`roleid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','Zabbix','Administrator','a65932019e6c1a5d4b38373ed2862d0e','',1,'0','en_US','30s','default',0,'10.67.216.93',1647840703,50,'default',3),(2,'guest','','','d41d8cd98f00b204e9800998ecf8427e','',0,'15m','default','30s','default',0,'',0,50,'default',1),(4,'H7108579','森','陳','$2y$10$sD.8KqAYtrC2lLzzfZgcXeEzEiBWZfPKVoT99VG/iXG3ysZp18nxy','',0,'0','en_GB','30s','default',4,'10.67.216.93',1655359551,50,'default',3),(5,'H7101057','玉雪','邵','30ee7a5435cc9f837a1b74642de1b8cc','',1,'0','zh_CN','30s','default',0,'10.67.216.100',1665362189,50,'default',3),(6,'H7104398','智勇','鄧','1bbd886460827015e5d605ed44252251','',1,'0','zh_CN','30s','default',0,'',0,50,'default',3),(9,'F4350394','家森','陳','202cb962ac59075b964b07152d234b70','',0,'0','en_GB','30s','default',0,'10.67.124.171',1599197847,50,'default',2),(11,'IG1499','其宏','侯','30ee7a5435cc9f837a1b74642de1b8cc','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(12,'IG1540','玉璽','黃','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(13,'IG1498','德林','鄧','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(14,'IG1527','佳鴻','吳','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(15,'IG0887','晉斌','黃','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(16,'IG0895','耀賢','蔣','$2y$10$KOft.K/qubjR7R7MRxeUH.ZIlZgPJ8a4gek2zkHcsggAIVMykUfmu','',1,'0','en_US','30s','default',3,'10.67.217.106',1649638953,50,'default',1),(17,'IG1526','美芳','薛','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(18,'IG1568','富元','譚','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(19,'IG1561','凱琳','陳','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(22,'H7112596','超','王','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(23,'H7102528','威振','劉','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(24,'H7108584','俊雅','孫','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(28,'H7207733','景哲','胡','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(34,'H7104620','二軍','趙','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(37,'F1011887','偉偉','但','30ee7a5435cc9f837a1b74642de1b8cc','',1,'0','en_US','30s','default',0,'10.67.124.158',1597307620,50,'default',2),(38,'F4004106','磊','張','30ee7a5435cc9f837a1b74642de1b8cc','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(39,'H7107462','悅','李','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(40,'H7112276','會福','高','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(43,'H7109018','超','張','30ee7a5435cc9f837a1b74642de1b8cc','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(44,'H7108734','紅葉','姚','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(46,'H7112301','雅斌','王','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(47,'H7112236','婷玉','孫','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(48,'H7112333','丹鳳','孫','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(49,'F2157712','宗龍','張','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(53,'H7108643','磊','李','89915ec71950245f75b6ea96718d1e28','',1,'0','en_US','30s','default',0,'10.67.124.210',1597135963,50,'default',1),(57,'H7112531','慶','任','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(62,'H7106764','營','劉','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(64,'H7108916','文龍','李','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(66,'H7112295','運娟','郭','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(72,'H7102562','東','劉','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(76,'H7109008','東松','王','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(77,'F7470367','小翠','孫','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(79,'H7109525','艷紅','皇甫','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(80,'H7109530','衡','于','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(84,'H7108610','金燕','臧','','',1,'0','en_US','30s','default',0,'10.67.124.100',1606275064,50,'default',1),(86,'H7112599','紅嫻','郝','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(87,'H7112640','金帥','李','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(88,'H7112641','瑞華','韓','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(90,'H7112347','瑤','雷','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(91,'H7108943','亞麗','張','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(92,'H7111969','曉晗','付','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(97,'H7112229','爽','李','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(98,'H7112230','敬賢','高','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(100,'H7109554','立麗','楊','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(101,'H7109586','鑫','劉','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(104,'F1001265','殿偉','高','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(105,'H7112605','耀忠','郭','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(106,'H7108437','全昌','代','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(107,'H7107156','婧','蔡','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(110,'H7112250','天宇','曹','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(112,'H7112258','順夢','何','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(113,'H7108446','奕博','李','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(114,'H7108425','鑫','姚','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(116,'H7111978','西晶','舒','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(118,'H7112252','濤','劉','','',1,'0','en_US','30s','default',0,'',0,50,'default',1),(124,'H7113229','振業','崔','07a01a4ffd22c8a763830d7ea044e3fa','',1,'0','zh_CN','30s','default',0,'10.67.217.94',1624496327,50,'default',3),(125,'H7113074','佳偉','孫','30ee7a5435cc9f837a1b74642de1b8cc','',1,'0','en_US','30s','default',0,'10.67.216.135',1641522090,50,'default',3),(128,'H7112675','中','楊','30ee7a5435cc9f837a1b74642de1b8cc','',0,'0','en_GB','30s','default',0,'',0,50,'default',1),(129,'H7113862','博','张','$2y$10$9AQbF26TuMC4QioRftDLSeYhSWZcX6ev8rLEGDzWsap8eAhs.8ro.','',1,'0','zh_CN','30s','default',0,'10.67.217.214',1666145245,50,'default',3),(130,'IG0515','ZhenTai','','$2y$10$juhBEDtqb4xv981FVVsT5.1a3h9jq6lGADBegDcagYGHNMhQlCuQy','',1,'0','default','30s','default',0,'10.62.33.12',1648170680,50,'default',4),(131,'chensen','chensen','','$2y$10$WF7ERq5optfUPAWASW..mO8gOgmy7FEa4qPORBLrrlFgkcGZV5lQC','',0,'0','default','30s','default',1,'10.67.216.135',1655359912,50,'default',3),(132,'IG1859','文謀','許','$2y$10$KR0HTt.ohB.QLarA5bFsGebXRM/3etqYEM2n6qvl06pEnEfY/gX1a','',1,'0','zh_CN','30s','default',0,'10.66.5.181',1665567232,50,'default',3),(133,'IG1977','曉東','劉','$2y$10$.xcYwdowyWhl/2KVLqkJ0uxwPAnxSDKZjgj4VQlOa59ZPq0/yRuQ2','',1,'0','default','30s','default',4,'10.67.217.214',1666146061,50,'default',5),(134,'H7114368','禹釗','張','$2y$10$KeXkan4kuR0dBXtCKAUM2Oa0AyTcSGlWitE2jvtxgDMLjc.o4SJHy','',1,'0','zh_CN','30s','default',0,'',0,50,'default',5);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-19 15:42:32

