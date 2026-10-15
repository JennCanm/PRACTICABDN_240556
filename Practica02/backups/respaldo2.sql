CREATE DATABASE  IF NOT EXISTS `db_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_test`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: db_test
-- ------------------------------------------------------
-- Server version	8.0.44

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'Create','root@localhost','2026-09-10 10:28:41','Usuario creado. ID=4, email=240556@utxicotepec.edu.mx, nick=JACM, creation_date=2026-09-10 10:28:41, status= ',_binary '','tb_users'),(2,'Create','root@localhost','2026-09-10 10:29:18','Usuario creado. ID=5, email=240080@utxicotepec.edu.mx, nick=Jeig, creation_date=2026-09-10 10:29:18, status= ',_binary '','tb_users'),(3,'Create','root@localhost','2026-09-10 10:30:03','Usuario creado. ID=7, email=240349@utxicotepec.edu.mx, nick=RGBG, creation_date=2026-09-10 10:30:03, status= ',_binary '','tb_users'),(4,'Create','Jhonathan.Gonzalez@DESKTOP-CP9O4BF','2026-09-10 12:48:03','Usuario creado. ID=8, email=240242@utxicotepec.edu.mx, nick=MAGO, creation_date=2026-09-10 12:48:03, status= ',_binary '','tb_users'),(5,'Create','Jhonathan.Gonzalez@DESKTOP-CP9O4BF','2026-09-10 12:50:32','Usuario creado. ID=9, email=240755@utxicotepec.edu.mx, nick=SARA, creation_date=2026-09-10 12:50:32, status= ',_binary '','tb_users'),(6,'Create','Jhonathan.Gonzalez@DESKTOP-CP9O4BF','2026-09-10 12:51:50','Usuario creado. ID=10, email=240615@utxicotepec.edu.mx, nick=OLIVER, creation_date=2026-09-10 12:51:50, status= ',_binary '','tb_users'),(7,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=11, email=carlos.perez@utxicotepec.edu.mx, nick=CPER, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(8,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=12, email=ana.lopez@utxicotepec.edu.mx, nick=ALOP, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(9,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=13, email=luis.gomez@utxicotepec.edu.mx, nick=LGOM, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(10,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=14, email=sofia.martinez@utxicotepec.edu.mx, nick=SMAR, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users'),(11,'Create','Gadiel.Bobadilla@10.10.60.40','2026-09-23 16:23:46','Usuario creado. ID=15, email=jorge.torres@utxicotepec.edu.mx, nick=JTOR, creation_date=2026-09-23 16:23:46, status=',_binary '','tb_users');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Smart TV 55\" 4K','Televisor LED UHD, HDR10, con funciones de Smart TV',450.00,15,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(2,'PROD-002','Smart TV 32\" HD','Televisor LED HD Ready, puertos HDMI y USB',180.00,30,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(3,'PROD-003','Smart TV 65\" OLED','Televisor 4K UHD, panel OLED, 120Hz para gaming',1200.00,8,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (4,'240556@utxicotepec.edu.mx','JACM','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 10:28:41',NULL,NULL,_binary ''),(5,'240080@utxicotepec.edu.mx','Jeig','8db1d4a631a6e9a24e2c0e842e1f1772','2026-09-10 10:29:18',NULL,NULL,_binary ''),(7,'240349@utxicotepec.edu.mx','RGBG','d93591bdf7860e1e4ee2fca799911215','2026-09-10 10:30:03',NULL,NULL,_binary ''),(8,'240242@utxicotepec.edu.mx','MAGO','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:48:03',NULL,NULL,_binary ''),(9,'240755@utxicotepec.edu.mx','SARA','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:50:32',NULL,NULL,_binary ''),(10,'240615@utxicotepec.edu.mx','OLIVER','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:51:50',NULL,NULL,_binary ''),(11,'carlos.perez@utxicotepec.edu.mx','CPER','b4af804009cb036a4ccdc33431ef9ac9','2026-09-23 16:23:46',NULL,NULL,_binary ''),(12,'ana.lopez@utxicotepec.edu.mx','ALOP','ee8ef2f5441316e0305ae007372de337','2026-09-23 16:23:46',NULL,NULL,_binary ''),(13,'luis.gomez@utxicotepec.edu.mx','LGOM','8dc7a6d78876351aad2ab8c4944f4267','2026-09-23 16:23:46',NULL,NULL,_binary ''),(14,'sofia.martinez@utxicotepec.edu.mx','JEEENY','04515132b580e3186112757fc9564de0','2026-09-23 16:23:46',NULL,NULL,_binary '');
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-23 16:30:57
