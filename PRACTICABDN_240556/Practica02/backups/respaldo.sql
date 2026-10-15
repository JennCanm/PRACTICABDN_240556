-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 10.10.60.40    Database: db_test
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `consulta_verificacion`
--

DROP TABLE IF EXISTS `consulta_verificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consulta_verificacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `inserted_by` varchar(100) NOT NULL,
  `roles` varchar(50) DEFAULT NULL,
  `operation_description` text NOT NULL,
  `operation_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consulta_verificacion`
--

LOCK TABLES `consulta_verificacion` WRITE;
/*!40000 ALTER TABLE `consulta_verificacion` DISABLE KEYS */;
INSERT INTO `consulta_verificacion` VALUES (1,'marco','marco.ramirez@ubicotepec.edu.mx','root@localhost',NULL,'Usuario creado. ID=3, email=marco.ramirez@ubicotepec.edu.mx','2026-09-10 09:58:11'),(2,'vanessa','240270@ubicotepec.edu.mx','vanessa.vergara@PC-02',NULL,'Usuario creado. ID=6, email=240270@ubicotepec.edu.mx','2026-09-10 11:26:03'),(3,'samuel','samuel.vargas@DESKTOP-ACMH89I','samuel.vargas@DESKTOP-ACMH89I','support','Usuario creado. ID=10, email=samuel.vargas@DESKTOP-ACMH89I','2026-09-17 10:44:39');
/*!40000 ALTER TABLE `consulta_verificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(80) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') DEFAULT NULL,
  `db_user` varchar(80) NOT NULL,
  `table_description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (2,'tb_users','Create','root@localhost','Usuario creado. ID=13, email=240349@utxicotepec.edu.mx, nick=GAD, creation_date=2026-09-10 10:49:37, status=','2026-09-10 10:49:37',_binary ''),(3,'tb_users','Create','root@localhost','Usuario creado ID=13, email=240349@utxicotepec.edu.mx, nick=GAD, creation_date=2026-09-10 10:49:37, status=','2026-09-10 10:49:37',_binary ''),(4,'tb_users','Create','root@localhost','Usuario creado. ID=14, email=240556@utxicotepec.edu.mx, nick=JEN, creation_date=2026-09-10 10:50:34, status=','2026-09-10 10:50:34',_binary ''),(5,'tb_users','Create','root@localhost','Usuario creado ID=14, email=240556@utxicotepec.edu.mx, nick=JEN, creation_date=2026-09-10 10:50:34, status=','2026-09-10 10:50:34',_binary ''),(6,'tb_users','Create','root@localhost','Usuario creado. ID=15, email=240234@utxicotepec.edu.mx, nick=JEY, creation_date=2026-09-10 10:51:03, status=','2026-09-10 10:51:03',_binary ''),(7,'tb_users','Create','root@localhost','Usuario creado ID=15, email=240234@utxicotepec.edu.mx, nick=JEY, creation_date=2026-09-10 10:51:03, status=','2026-09-10 10:51:03',_binary ''),(8,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=16, email=240080@utxicotepec.edu.mx, nick=JEIG, creation_date=2026-09-10 11:27:34, status=','2026-09-10 11:27:34',_binary ''),(9,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=16, email=240080@utxicotepec.edu.mx, nick=JEIG, creation_date=2026-09-10 11:27:34, status=','2026-09-10 11:27:34',_binary ''),(10,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=17, email=240603@utxicotepec.edu.mx, nick=JILC, creation_date=2026-09-10 11:32:02, status=','2026-09-10 11:32:02',_binary ''),(11,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=17, email=240603@utxicotepec.edu.mx, nick=JILC, creation_date=2026-09-10 11:32:02, status=','2026-09-10 11:32:02',_binary ''),(12,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=18, email=240765@utxicotepec.edu.mx, nick=DGS, creation_date=2026-09-10 11:32:21, status=','2026-09-10 11:32:21',_binary ''),(13,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=18, email=240765@utxicotepec.edu.mx, nick=DGS, creation_date=2026-09-10 11:32:21, status=','2026-09-10 11:32:21',_binary ''),(14,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=4, SKU=PROD-004, name=Teclado Mecanico RGB, current_price=75.00, current_stock=20, status=ACTIVE','2026-09-23 16:22:29',_binary ''),(15,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=5, SKU=PROD-005, name=Mouse Gamer 16000DPI, current_price=45.00, current_stock=35, status=ACTIVE','2026-09-23 16:22:29',_binary ''),(16,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=6, SKU=PROD-006, name=Monitor 27 Pulgadas, current_price=230.00, current_stock=12, status=ACTIVE','2026-09-23 16:22:29',_binary ''),(17,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=7, SKU=PROD-007, name=Auriculares 7.1, current_price=55.00, current_stock=18, status=ACTIVE','2026-09-23 16:22:29',_binary ''),(18,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=8, SKU=PROD-008, name=Silla Ergonomica Gamer, current_price=190.00, current_stock=5, status=INACTIVE','2026-09-23 16:22:29',_binary ''),(19,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=9, SKU=PROD-004, name=Teclado Mecanico RGB, current_price=75.00, current_stock=20, status=ACTIVE','2026-09-23 16:22:39',_binary ''),(20,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=10, SKU=PROD-005, name=Mouse Gamer 16000DPI, current_price=45.00, current_stock=35, status=ACTIVE','2026-09-23 16:22:39',_binary ''),(21,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=11, SKU=PROD-006, name=Monitor 27 Pulgadas, current_price=230.00, current_stock=12, status=ACTIVE','2026-09-23 16:22:39',_binary ''),(22,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=12, SKU=PROD-007, name=Auriculares 7.1, current_price=55.00, current_stock=18, status=ACTIVE','2026-09-23 16:22:39',_binary ''),(23,'tb_products','Create','jenny.canales@DESKTOP-OCO5KIC','Producto creado. ID=13, SKU=PROD-008, name=Silla Ergonomica Gamer, current_price=190.00, current_stock=5, status=INACTIVE','2026-09-23 16:22:39',_binary ''),(24,'tb_products','Update','jenny.canales@DESKTOP-OCO5KIC','Producto actualizado. ID=2, SKU=PROD-002, name=Smart TV 32\" HD, precio_anterior=180.00, precio_nuevo=195.00, stock_anterior=30, stock_nuevo=25, status=ACTIVE','2026-09-23 16:22:54',_binary ''),(25,'tb_products','Delete','jenny.canales@DESKTOP-OCO5KIC','Producto eliminado. ID=8, SKU=PROD-008, name=Silla Ergonomica Gamer','2026-09-23 16:23:10',_binary ''),(26,'tb_products','Delete','jenny.canales@DESKTOP-OCO5KIC','Producto eliminado. ID=13, SKU=PROD-008, name=Silla Ergonomica Gamer','2026-09-23 16:23:10',_binary '');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL,
  `current_stock` int NOT NULL,
  `status` varchar(20) NOT NULL,
  `creation_date` datetime NOT NULL,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Smart TV 55\" 4K','Televisor LED UHD, HDR10, con funciones de Smart TV',450.00,15,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(2,'PROD-002','Smart TV 32\" HD','Televisor LED HD Ready, puertos HDMI y USB',195.00,25,'ACTIVE','2026-09-22 07:46:03','2026-09-23 16:22:54'),(3,'PROD-003','Smart TV 65\" OLED','Televisor 4K UHD, panel OLED, 120Hz para gaming',1200.00,8,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(4,'PROD-004','Teclado Mecanico RGB','Teclado con switches azules',75.00,20,'ACTIVE','2026-09-23 16:22:29','2026-09-23 16:22:29'),(5,'PROD-005','Mouse Gamer 16000DPI','Mouse optico ergonomico',45.00,35,'ACTIVE','2026-09-23 16:22:29','2026-09-23 16:22:29'),(6,'PROD-006','Monitor 27 Pulgadas','Monitor IPS 144Hz 1ms',230.00,12,'ACTIVE','2026-09-23 16:22:29','2026-09-23 16:22:29'),(7,'PROD-007','Auriculares 7.1','Audifonos envolventes con microfono',55.00,18,'ACTIVE','2026-09-23 16:22:29','2026-09-23 16:22:29'),(9,'PROD-004','Teclado Mecanico RGB','Teclado con switches azules',75.00,20,'ACTIVE','2026-09-23 16:22:39','2026-09-23 16:22:39'),(10,'PROD-005','Mouse Gamer 16000DPI','Mouse optico ergonomico',45.00,35,'ACTIVE','2026-09-23 16:22:39','2026-09-23 16:22:39'),(11,'PROD-006','Monitor 27 Pulgadas','Monitor IPS 144Hz 1ms',230.00,12,'ACTIVE','2026-09-23 16:22:39','2026-09-23 16:22:39'),(12,'PROD-007','Auriculares 7.1','Audifonos envolventes con microfono',55.00,18,'ACTIVE','2026-09-23 16:22:39','2026-09-23 16:22:39');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT(
            'Producto creado. ID=', NEW.ID,
            ', SKU=', NEW.SKU,
            ', name=', NEW.name,
            ', current_price=', NEW.current_price,
            ', current_stock=', NEW.current_stock,
            ', status=', NEW.status
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT(
            'Producto actualizado. ID=', NEW.ID,
            ', SKU=', NEW.SKU,
            ', name=', NEW.name,
            ', precio_anterior=', OLD.current_price, ', precio_nuevo=', NEW.current_price,
            ', stock_anterior=', OLD.current_stock, ', stock_nuevo=', NEW.current_stock,
            ', status=', NEW.status
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT(
            'Producto eliminado. ID=', OLD.ID,
            ', SKU=', OLD.SKU,
            ', name=', OLD.name
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nick` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (14,'240556@utxicotepec.edu.mx','JEN','b6b8870c2b130a562fbe89fb0bb9518a','2026-09-10 10:50:34',NULL,NULL,_binary ''),(15,'240234@utxicotepec.edu.mx','GADY','51676091c6366bd05da30f9e0fe59aa0','2026-09-10 10:51:03',NULL,NULL,_binary ''),(16,'240080@utxicotepec.edu.mx','JEIG','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:27:34',NULL,NULL,_binary ''),(17,'240603@utxicotepec.edu.mx','JILC','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:32:02',NULL,NULL,_binary ''),(18,'240765@utxicotepec.edu.mx','DGS','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:32:21',NULL,NULL,_binary '');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-23 16:26:25
