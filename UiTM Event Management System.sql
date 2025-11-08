CREATE DATABASE  IF NOT EXISTS `s9946_UEMS` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `s9946_UEMS`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 139.99.124.197    Database: s9946_UEMS
-- ------------------------------------------------------
-- Server version	5.5.5-10.3.39-MariaDB-0ubuntu0.20.04.2

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
-- Table structure for table `EVENT`
--

DROP TABLE IF EXISTS `EVENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EVENT` (
  `eventID` varchar(6) NOT NULL,
  `organiserID` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `eventName` varchar(100) NOT NULL,
  `eventDate` date NOT NULL,
  `eventTime` time NOT NULL,
  `eventLocation` varchar(100) NOT NULL,
  `eventPrice` decimal(8,2) NOT NULL,
  `eventStatus` varchar(10) NOT NULL,
  `maxParticipant` decimal(5,0) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`eventID`),
  KEY `EVENT_ibfk_1` (`organiserID`),
  CONSTRAINT `EVENT_ibfk_1` FOREIGN KEY (`organiserID`) REFERENCES `ORGANISER` (`organiserID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EVENT`
--

LOCK TABLES `EVENT` WRITE;
/*!40000 ALTER TABLE `EVENT` DISABLE KEYS */;
INSERT INTO `EVENT` VALUES ('EV0001','ORG003','PROGRAM ZERO TO MASTER IN CANVA','2024-12-07','08:00:00','Microsoft Teams',3.00,'Ended',200,'Program yang akan membantu para pelajar dalam menguasai penggunaan Canva dengan memberi tips dan teknik yang berguna'),('EV0002','ORG001','QUEST FOR KNOWLEDGE ISLAMIC REALMS EXPLORACE','2024-12-07','09:00:00','Padang  Alpha',10.00,'Ended',40,'Explorace bertemakan ilmu tentang agama Islam yang mampu menguji minda'),('EV0003','ORG001','5KM INTERNATIONAL FUN WALK FOR WORLD PEACE NEGERI PERAK','2023-12-16','07:30:00','UITM Kampus Tapah',60.00,'Ended',500,''),('EV0004','ORG003','ANUGERAH DEKAN BASCO 2024','2024-11-26','10:00:00','Auditorium Bangunan Zeta',0.00,'Ended',250,''),('EV0005','ORG002','JSP COLOUR RUN 2025','2025-02-07','08:00:00','Sekitar UiTM Kampus Tapah',45.00,'Ongoing',99999,'Sometimes All You Need Is A Little Splash Of Colour'),('EV0006','ORG002','BRISK GLOW @ SPORTING CAMPUS','2023-11-27','20:30:00','Sekitar UiTM Kampus Tapah',30.00,'Ended',99999,'Get Your Glow On'),('EV0007','ORG001','TECH SUMMIT 2025','2025-02-04','10:00:00','Auditorium Bangunan Zeta',0.00,'Ended',300,'A summit for tech enthusiasts and industry leaders.'),('EV0008','ORG002','FOOD CARNIVAL 2025','2025-02-04','12:00:00','Kawasan Parking Blok Pensyarah',5.00,'Ended',400,'A variety of food stalls and live cooking shows.'),('EV0009','ORG003','GAMING EXPO 2025','2025-02-04','08:00:00','Green House, Uitm Tapah',0.00,'Ended',500,'The latest games, tournaments, and tech showcases.'),('EV0010','ORG001','FESMA 6.0','2025-02-09','10:00:00','Plaza Pentadbiran',10.00,'Upcoming',99999,'Festival Seni Budaya Mahasiswa'),('EV0011','ORG001','Example Event for MPP','2025-10-28','11:00:00','greenhouse',0.00,'Upcoming',100,'Example Description for MPP');
/*!40000 ALTER TABLE `EVENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FEEDBACK_REPORT`
--

DROP TABLE IF EXISTS `FEEDBACK_REPORT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FEEDBACK_REPORT` (
  `feedbackID` varchar(6) NOT NULL,
  `eventID` varchar(6) NOT NULL,
  `rating` decimal(1,0) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` varchar(100) DEFAULT NULL,
  `feedbackID_int` int(11) DEFAULT 0,
  PRIMARY KEY (`feedbackID`),
  KEY `FEEDBACK_REPORT_ibfk_1` (`eventID`),
  CONSTRAINT `FEEDBACK_REPORT_ibfk_1` FOREIGN KEY (`eventID`) REFERENCES `EVENT` (`eventID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FEEDBACK_REPORT`
--

LOCK TABLES `FEEDBACK_REPORT` WRITE;
/*!40000 ALTER TABLE `FEEDBACK_REPORT` DISABLE KEYS */;
INSERT INTO `FEEDBACK_REPORT` VALUES ('F00001','EV0001',3,'Quite draggy session wish that the speaker can get straight to the point',1),('F00002','EV0001',4,'Very informative session ',2),('F00003','EV0002',3,'Kawasan explorace tidak dikawal oleh polis bantuan',3),('F00004','EV0002',3,'Program yang sangat bermanfaat',4),('F00005','EV0003',4,'A very good and healthy program',5),('F00006','EV0003',2,'Sesi pendaftaran agak tidak teratur ',6),('F00007','EV0004',1,'Tempat yang tidak sesuai dan membosankan ',7),('F00008','EV0004',4,'Well done program',8),('F00009','EV0001',5,'Speaker is good at doing his job know how to entertain the audience',9),('F00010','EV0002',5,'Permainan yang menguji minda dan kecergasan',10),('F00011','EV0003',5,'kepala butuh',11),('F00012','EV0003',5,'kepala butuh',12),('F00013','EV0001',5,'Very mindful!',13),('F00014','EV0001',5,'very mindful event',14),('F00015','EV0009',5,'Very mindful event',15);
/*!40000 ALTER TABLE `FEEDBACK_REPORT` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u9946_V6ind91OVj`@`%`*/ /*!50003 TRIGGER before_insert_feedback
BEFORE INSERT ON FEEDBACK_REPORT
FOR EACH ROW
BEGIN
    -- Increment the feedbackID_int value by 1
    SET NEW.feedbackID_int = (SELECT COALESCE(MAX(feedbackID_int), 0) + 1 FROM FEEDBACK_REPORT);
    
    -- Generate feedbackID as F00001, F00002, etc.
    SET NEW.feedbackID = CONCAT('F', LPAD(NEW.feedbackID_int, 5, '0'));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ORGANISER`
--

DROP TABLE IF EXISTS `ORGANISER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORGANISER` (
  `organiserID` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `organiserPassword` varchar(10) NOT NULL,
  `organiserName` varchar(50) NOT NULL,
  `organiserEmail` varchar(50) NOT NULL,
  `organiserNoTel` varchar(11) NOT NULL,
  `postCaption` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`organiserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORGANISER`
--

LOCK TABLES `ORGANISER` WRITE;
/*!40000 ALTER TABLE `ORGANISER` DISABLE KEYS */;
INSERT INTO `ORGANISER` VALUES ('ORG001','mpp002','MAJLIS PERWAKILAN PELAJAR (MPP)','mppuitm@gmail.com','0128172911','Bilik Gerakan MPP (Aras 2 : Pusat Pelajar UiTM Tapah)'),('ORG002','jsp998','JAWATANKUASA SUKA PELAJAR (JSP)','jsptapah@gmail.com ','0139271939 ','Waktu Operasi : 12PM - 9:45PM'),('ORG003','basco556 ','PERSATUAN BACHELOR OF COMPUTER SCIENCE (BASCO) ','bascotapah@gmail.com ','0162917218 ','Selamat datang ke laman rasmi Bachelor of Computer Science Society (BASCO) UiTM Tapah ');
/*!40000 ALTER TABLE `ORGANISER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PARTICIPANT`
--

DROP TABLE IF EXISTS `PARTICIPANT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PARTICIPANT` (
  `participantID` varchar(10) NOT NULL,
  `participantName` varchar(50) NOT NULL,
  `participantEmail` varchar(50) NOT NULL,
  `participantPassword` varchar(10) NOT NULL,
  `participantNoTel` varchar(11) NOT NULL,
  PRIMARY KEY (`participantID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PARTICIPANT`
--

LOCK TABLES `PARTICIPANT` WRITE;
/*!40000 ALTER TABLE `PARTICIPANT` DISABLE KEYS */;
INSERT INTO `PARTICIPANT` VALUES ('2024108785','Zainal Bin Abidin','2024938885@student.uitm.edu.my','zainal8027','0193262532'),('2024122345','Ali Bin Abu','ali.abu@gmail.com','aliabu1234','01112345678'),('2024123456','Syaeef Bin Safiq','syaeef.safiq@gmail.com','syaeef2811','0172918312'),('2024129128','Siti Haliza Binti Mad','siti.mad@gmail.com','sitimad235','0132849100'),('2024188332','Bunga Binti Che Wan','bunga.wan@gmail.com','bunga8023','0121103913'),('2024190881','Zaleha Binti Asri','zaleha.asri@gmail.com','zaleha028','0128103221'),('2024198983','Kamelia binti Harun','kamelia.harun@gmail.com','kamelia89','0142916433'),('2024392393','Noah Bin Ryan','noahryan@gmail.com','noahryan1','0140911233'),('2024393012','Mastura Binti Mahmod','mastura.mahmod@gmail.com','mastura302','0183927482'),('2024811392','Irsyad bin Halim','irsyad.halim@gmail.com','irsyad1023','0172916409'),('2024891321','Mohamad Bin Nuh','mohamad.nuh@gmail.com','mohamad103','0172981276'),('2024910231','Arman bin Aesrul','haikals600@gmail.com','arman0022','0139210076');
/*!40000 ALTER TABLE `PARTICIPANT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PAYMENT_REPORT`
--

DROP TABLE IF EXISTS `PAYMENT_REPORT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PAYMENT_REPORT` (
  `paymentID` varchar(6) NOT NULL,
  `eventID` varchar(6) NOT NULL,
  `dateGenerate` date NOT NULL,
  `timeGenerate` time NOT NULL,
  `totalAmount` decimal(8,2) NOT NULL,
  PRIMARY KEY (`paymentID`),
  KEY `PAYMENT_REPORT_ibfk_1` (`eventID`),
  CONSTRAINT `PAYMENT_REPORT_ibfk_1` FOREIGN KEY (`eventID`) REFERENCES `EVENT` (`eventID`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PAYMENT_REPORT`
--

LOCK TABLES `PAYMENT_REPORT` WRITE;
/*!40000 ALTER TABLE `PAYMENT_REPORT` DISABLE KEYS */;
INSERT INTO `PAYMENT_REPORT` VALUES ('P00001','EV0001','2024-12-27','09:00:00',9.00),('P00002','EV0002','2024-12-25','07:30:20',80.00),('P00003','EV0003','2023-11-30','11:39:20',120.00),('P00004','EV0004','2024-12-12','14:17:49',0.00);
/*!40000 ALTER TABLE `PAYMENT_REPORT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REGISTRATION`
--

DROP TABLE IF EXISTS `REGISTRATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REGISTRATION` (
  `registrationID` varchar(6) NOT NULL,
  `participantID` varchar(10) NOT NULL,
  `eventID` varchar(6) NOT NULL,
  `registrationDate` date NOT NULL,
  PRIMARY KEY (`registrationID`),
  KEY `REGISTRATION_ibfk_1` (`participantID`),
  KEY `REGISTRATION_ibfk_2` (`eventID`),
  CONSTRAINT `REGISTRATION_ibfk_1` FOREIGN KEY (`participantID`) REFERENCES `PARTICIPANT` (`participantID`) ON DELETE NO ACTION,
  CONSTRAINT `REGISTRATION_ibfk_2` FOREIGN KEY (`eventID`) REFERENCES `EVENT` (`eventID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REGISTRATION`
--

LOCK TABLES `REGISTRATION` WRITE;
/*!40000 ALTER TABLE `REGISTRATION` DISABLE KEYS */;
INSERT INTO `REGISTRATION` VALUES ('RG0001','2024188332','EV0003','2023-10-27'),('RG0002','2024108785','EV0003','2023-10-02'),('RG0003','2024129128','EV0002','2024-11-26'),('RG0004','2024811392','EV0001','2024-11-21'),('RG0005','2024198983','EV0004','2023-11-20'),('RG0006','2024393012','EV0002','2024-11-19'),('RG0007','2024891321','EV0004','2024-10-30'),('RG0008','2024122345','EV0001','2024-12-01'),('RG0009','2024910231','EV0005','2025-01-31'),('RG0010','2024190881','EV0006','2025-01-20'),('RG0011','2024108785','EV0004','2025-02-01'),('RG0012','2024108785','EV0005','2025-02-01'),('RG0013','2024108785','EV0006','2025-02-01'),('RG0014','2024910231','EV0007','2025-02-03'),('RG0016','2024108785','EV0007','2025-02-05'),('RG0019','2024108785','EV0009','2025-02-05'),('RG0035','2024108785','EV0001','2025-02-06'),('RG0036','2024123456','EV0009','2025-02-06'),('RG0038','2024123456','EV0008','2025-02-07'),('RG0039','2024123456','EV0007','2025-02-07'),('RG0040','2024108785','EV0010','2025-02-08'),('RG0041','2024392393','EV0010','2025-02-08');
/*!40000 ALTER TABLE `REGISTRATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 's9946_UEMS'
--

--
-- Dumping routines for database 's9946_UEMS'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-09 21:46:38
