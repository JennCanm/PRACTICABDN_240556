-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_test
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
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
  `table_operation` enum('Create','Read','Update','Delete') DEFAULT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `table_description` text NOT NULL,
  `operation_status` bit(1) DEFAULT b'1',
  `table_name` varchar(80) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'Create','root@localhost','2026-09-10 10:28:41','Usuario creado. ID=4, email=240556@utxicotepec.edu.mx, nick=JACM, creation_date=2026-09-10 10:28:41, status= ',_binary '','tb_users'),(2,'Create','root@localhost','2026-09-10 10:29:18','Usuario creado. ID=5, email=240080@utxicotepec.edu.mx, nick=Jeig, creation_date=2026-09-10 10:29:18, status= ',_binary '','tb_users'),(3,'Create','root@localhost','2026-09-10 10:30:03','Usuario creado. ID=7, email=240349@utxicotepec.edu.mx, nick=RGBG, creation_date=2026-09-10 10:30:03, status= ',_binary '','tb_users'),(4,'Create','Jhonathan.Gonzalez@DESKTOP-CP9O4BF','2026-09-10 12:48:03','Usuario creado. ID=8, email=240242@utxicotepec.edu.mx, nick=MAGO, creation_date=2026-09-10 12:48:03, status= ',_binary '','tb_users'),(5,'Create','Jhonathan.Gonzalez@DESKTOP-CP9O4BF','2026-09-10 12:50:32','Usuario creado. ID=9, email=240755@utxicotepec.edu.mx, nick=SARA, creation_date=2026-09-10 12:50:32, status= ',_binary '','tb_users'),(6,'Create','Jhonathan.Gonzalez@DESKTOP-CP9O4BF','2026-09-10 12:51:50','Usuario creado. ID=10, email=240615@utxicotepec.edu.mx, nick=OLIVER, creation_date=2026-09-10 12:51:50, status= ',_binary '','tb_users'),(7,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=11, email=carlos.perez@utxicotepec.edu.mx, nick=CPER, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(8,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=12, email=ana.lopez@utxicotepec.edu.mx, nick=ALOP, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(9,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=13, email=luis.gomez@utxicotepec.edu.mx, nick=LGOM, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(10,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=14, email=sofia.martinez@utxicotepec.edu.mx, nick=SMAR, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(11,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=15, email=jorge.torres@utxicotepec.edu.mx, nick=JTOR, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(12,'Create','Gadiel.Bobadilla@PC-15','2026-09-24 10:59:03','Producto creado. ID=4, SKU=PROD-004, name=Audifonos Bluetooth In Ear, current_price=350.50, current_stock=25, status=ACTIVE',_binary '','tb_products'),(13,'Create','Gadiel.Bobadilla@PC-15','2026-09-24 10:59:03','Producto creado. ID=5, SKU=PROD-005, name=Teclado Mecanico RGB, current_price=650.00, current_stock=12, status=ACTIVE',_binary '','tb_products'),(14,'Create','Gadiel.Bobadilla@PC-15','2026-09-24 10:59:03','Producto creado. ID=6, SKU=PROD-006, name=Mouse Ergonomico Inalambrico, current_price=220.00, current_stock=40, status=ACTIVE',_binary '','tb_products'),(15,'Create','Gadiel.Bobadilla@PC-15','2026-09-24 10:59:03','Producto creado. ID=7, SKU=PROD-007, name=Monitor Gamer 24 FHD, current_price=3200.00, current_stock=7, status=ACTIVE',_binary '','tb_products'),(16,'Create','Gadiel.Bobadilla@PC-15','2026-09-24 10:59:03','Producto creado. ID=8, SKU=PROD-008, name=Mousepad XL para Escritorio, current_price=150.00, current_stock=50, status=ACTIVE',_binary '','tb_products'),(17,'Update','Gadiel.Bobadilla@PC-15','2026-09-24 11:01:37','Producto actualizado. ID=4, SKU=PROD-004, name=Audifonos Bluetooth In Ear, precio_anterior=350.50, precio_nuevo=399.00, stock_anterior=25, stock_nuevo=30, status=ACTIVE',_binary '','tb_products'),(18,'Delete','Gadiel.Bobadilla@PC-15','2026-09-24 11:02:17','Producto eliminado. ID=8, SKU=PROD-008, name=Mousepad XL para Escritorio',_binary '','tb_products'),(19,'Create','Dara.Gomez@PC-18','2026-09-24 11:21:32','Usuario creado. ID=16, email=carlos.navarro@example.com, nick=carlosnavarro, creation_date=2026-09-24 11:21:32, status=',_binary '','tb_users'),(20,'Create','Dara.Gomez@PC-18','2026-09-24 11:21:32','Usuario creado. ID=17, email=maria.torres@example.com, nick=mariatorres, creation_date=2026-09-24 11:21:32, status=',_binary '','tb_users'),(21,'Create','Dara.Gomez@PC-18','2026-09-24 11:21:32','Usuario creado. ID=18, email=sofia.mendoza@example.com, nick=sofiamendoza, creation_date=2026-09-24 11:21:32, status=',_binary '','tb_users'),(22,'Create','root@localhost','2026-09-24 11:47:00','Producto insertado correctamente con ID=1. SKU: PROD-001',_binary '','tb_products'),(23,'Create','root@localhost','2026-09-24 11:50:53','Producto creado. ID=9, SKU=JENNY-201, name=Hub USB-C 7 en 1, current_price=780.00, current_stock=25, status=1',_binary '','tb_products'),(24,'Create','root@localhost','2026-09-24 11:50:53','Producto creado. ID=10, SKU=JENNY-202, name=Lámpara LED de Escritorio, current_price=490.00, current_stock=18, status=1',_binary '','tb_products'),(25,'Create','root@localhost','2026-09-24 11:50:59','Producto insertado correctamente con ID=1. SKU: PROD-001',_binary '','tb_products'),(26,'Create','Dara.Gomez@PC-18','2026-09-24 12:01:07','Usuario creado. ID=19, email=roberto.silva@example.com, nick=robertosilva, creation_date=2026-09-24 12:01:07, status=',_binary '','tb_users'),(27,'Create','Gadiel.Bobadilla@PC-15','2026-09-24 12:39:29','Producto creado. ID=11, SKU=PROD-014, name=Audifonos Bluetooth  APPLE, current_price=4350.50, current_stock=25, status=ACTIVE',_binary '','tb_products');
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
  `creation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Smart TV 55\" 4K','Televisor LED UHD, HDR10, con funciones de Smart TV',450.00,15,'ACTIVE','2026-09-22 13:46:03','2026-09-22 13:46:03'),(2,'PROD-002','Smart TV 32\" HD','Televisor LED HD Ready, puertos HDMI y USB',180.00,30,'ACTIVE','2026-09-22 13:46:03','2026-09-22 13:46:03'),(3,'PROD-003','Smart TV 65\" OLED','Televisor 4K UHD, panel OLED, 120Hz para gaming',1200.00,8,'ACTIVE','2026-09-22 13:46:03','2026-09-22 13:46:03'),(4,'PROD-004','Audifonos Bluetooth In Ear','Audifonos inalambricos con estuche de carga y cancelacion de ruido',399.00,30,'ACTIVE','2026-09-24 16:59:03','2026-09-24 17:01:37'),(5,'PROD-005','Teclado Mecanico RGB','Teclado gamer mecanico con switches red y iluminacion personalizable',650.00,12,'ACTIVE','2026-09-24 16:59:03','2026-09-24 16:59:03'),(6,'PROD-006','Mouse Ergonomico Inalambrico','Mouse optico vertical con conexion inalambrica de 2.4GHz',220.00,40,'ACTIVE','2026-09-24 16:59:03','2026-09-24 16:59:03'),(7,'PROD-007','Monitor Gamer 24 FHD','Monitor LED de 24 pulgadas con tasa de refresco de 144Hz',3200.00,7,'ACTIVE','2026-09-24 16:59:03','2026-09-24 16:59:03'),(9,'JENNY-201','Hub USB-C 7 en 1','Adaptador HDMI 4K, Lectora SD y puertos USB 3.0',780.00,25,'1','2026-09-24 17:50:53','2026-09-24 17:50:53'),(10,'JENNY-202','Lámpara LED de Escritorio','Control táctil, luz regulable y puerto de carga USB',490.00,18,'1','2026-09-24 17:50:53','2026-09-24 17:50:53'),(11,'PROD-014','Audifonos Bluetooth  APPLE','Audifonos inalambricos con estuche de carga y cancelacion de ruido',4350.50,25,'ACTIVE','2026-09-24 18:39:29','2026-09-24 18:39:29');
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
INSERT INTO `tb_users` VALUES (4,'240556@utxicotepec.edu.mx','JACM','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 10:28:41',NULL,NULL,_binary ''),(5,'240080@utxicotepec.edu.mx','Jeig','8db1d4a631a6e9a24e2c0e842e1f1772','2026-09-10 10:29:18',NULL,NULL,_binary ''),(7,'240349@utxicotepec.edu.mx','RGBG','d93591bdf7860e1e4ee2fca799911215','2026-09-10 10:30:03',NULL,NULL,_binary ''),(8,'240242@utxicotepec.edu.mx','MAGO','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:48:03',NULL,NULL,_binary ''),(9,'240755@utxicotepec.edu.mx','SARA','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:50:32',NULL,NULL,_binary ''),(10,'240615@utxicotepec.edu.mx','OLIVER','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:51:50',NULL,NULL,_binary ''),(16,'carlos.actualizado@example.com','carlosactualizado','29ca17391c0888e34dfb075f4c2fd1fe','2026-09-24 11:21:32','2026-09-24 11:21:45',NULL,_binary ''),(17,'maria.torres@example.com','mariatorres','fa43b79adf05205e333640aa43ef356d','2026-09-24 11:21:32','2026-09-24 11:21:32',NULL,_binary ''),(19,'roberto.silva@example.com','robertosilva','781ec245b17d2cf179610e4282546d8a','2026-09-24 12:01:07',NULL,NULL,_binary '');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
     INSERT INTO tb_logs (
     table_name,
     table_operation,
     db_user,
     table_description,
     operation_date,
     operation_status
     )
    VALUES (
              'tb_users',
              'Create',
     USER(),
     CONCAT(
     'Usuario creado. ID=', NEW.ID,
     ', email=', NEW.email,
     ', nick=', NEW.nick,
     ', creation_date=', NEW.creation_date,
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

--
-- Temporary view structure for view `vw_trazabilidad_productos`
--

DROP TABLE IF EXISTS `vw_trazabilidad_productos`;
/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_productos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_trazabilidad_productos` AS SELECT 
 1 AS `id`,
 1 AS `sku`,
 1 AS `name`,
 1 AS `description`,
 1 AS `current_price`,
 1 AS `current_stock`,
 1 AS `status`,
 1 AS `inserted_by`,
 1 AS `roles`,
 1 AS `operation_description`,
 1 AS `operation_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_trazabilidad_usuarios`
--

DROP TABLE IF EXISTS `vw_trazabilidad_usuarios`;
/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_usuarios`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_trazabilidad_usuarios` AS SELECT 
 1 AS `ID`,
 1 AS `nick`,
 1 AS `email`,
 1 AS `status`,
 1 AS `inserted_by`,
 1 AS `roles`,
 1 AS `table_description`,
 1 AS `operation_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_trazabilidad_productos`
--

/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_productos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_trazabilidad_productos` AS select `p`.`ID` AS `id`,`p`.`SKU` AS `sku`,`p`.`name` AS `name`,`p`.`description` AS `description`,`p`.`current_price` AS `current_price`,`p`.`current_stock` AS `current_stock`,`p`.`status` AS `status`,`b`.`db_user` AS `inserted_by`,coalesce(group_concat(distinct `re`.`FROM_USER` order by `re`.`FROM_USER` ASC separator ', '),'Sin rol') AS `roles`,`b`.`table_description` AS `operation_description`,`b`.`operation_date` AS `operation_date` from ((`tb_products` `p` left join `tb_logs` `b` on((`b`.`ID` = (select min(`l`.`ID`) from `tb_logs` `l` where ((`l`.`table_name` = 'tb_products') and (`l`.`table_operation` in ('Create','INSERT')) and ((`l`.`table_description` like concat('%ID=',`p`.`ID`,',%')) or (`l`.`table_description` like concat('%ID=',`p`.`ID`,'.%')) or (`l`.`table_description` like concat('%ID=',`p`.`ID`,' %')))))))) left join `mysql`.`role_edges` `re` on((lower(`re`.`TO_USER`) = lower(substring_index(`b`.`db_user`,'@',1))))) group by `p`.`ID`,`p`.`SKU`,`p`.`name`,`p`.`description`,`p`.`current_price`,`p`.`current_stock`,`p`.`status`,`b`.`db_user`,`b`.`table_description`,`b`.`operation_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_trazabilidad_usuarios`
--

/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_usuarios`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_trazabilidad_usuarios` AS select `u`.`ID` AS `ID`,`u`.`nick` AS `nick`,`u`.`email` AS `email`,`u`.`status` AS `status`,`b`.`db_user` AS `inserted_by`,coalesce(group_concat(distinct `re`.`FROM_USER` order by `re`.`FROM_USER` ASC separator ', '),'Sin roles asignados') AS `roles`,`b`.`table_description` AS `table_description`,`b`.`operation_date` AS `operation_date` from ((`tb_users` `u` left join `tb_logs` `b` on((((`b`.`table_description` like concat('%',`u`.`nick`,'%')) or (`b`.`table_description` like concat('%',`u`.`email`,'%')) or (`b`.`table_description` like concat('%ID=',`u`.`ID`,'%'))) and (`b`.`table_name` = 'tb_users') and (`b`.`table_operation` in ('Create','INSERT'))))) left join `mysql`.`role_edges` `re` on((`re`.`TO_USER` = substring_index(`b`.`db_user`,'@',1)))) group by `u`.`ID`,`u`.`nick`,`u`.`email`,`u`.`status`,`b`.`db_user`,`b`.`table_description`,`b`.`operation_date` order by `b`.`operation_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-29  8:56:04
