-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2020 at 11:44 AM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `samp`
--

-- --------------------------------------------------------

--
-- Table structure for table `arrestpoints`
--

CREATE TABLE `arrestpoints` (
  `arrestID` int(11) NOT NULL,
  `arrestX` float NOT NULL,
  `arrestY` float NOT NULL,
  `arrestZ` float NOT NULL,
  `arrestInterior` int(11) NOT NULL,
  `arrestWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `arrestpoints`
--

INSERT INTO `arrestpoints` (`arrestID`, `arrestX`, `arrestY`, `arrestZ`, `arrestInterior`, `arrestWorld`) VALUES
(1, 1568.49, -1691.11, 5.8906, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `atm`
--

CREATE TABLE `atm` (
  `atmID` int(11) NOT NULL,
  `atmX` float NOT NULL,
  `atmY` float NOT NULL,
  `atmZ` float NOT NULL,
  `atmA` float NOT NULL,
  `atmInterior` int(11) NOT NULL,
  `atmWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `atm`
--

INSERT INTO `atm` (`atmID`, `atmX`, `atmY`, `atmZ`, `atmA`, `atmInterior`, `atmWorld`) VALUES
(1, 1547.14, -1680.7, 13.5591, 266.581, 0, 0),
(2, 1186.41, -1292.74, 13.5495, 98.1101, 0, 0),
(6, 1206.86, -1820.56, 13.5944, 356.636, 0, 0),
(8, 1204.03, -1820.6, 13.5943, 6.0304, 0, 0),
(9, 1547.24, -1670.46, 13.5619, 269.726, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `BanID` int(10) NOT NULL,
  `Username` varchar(24) NOT NULL,
  `BannedBy` varchar(24) NOT NULL,
  `BanReason` varchar(128) NOT NULL,
  `IpAddress` varchar(17) NOT NULL,
  `Date` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `carID` int(12) NOT NULL,
  `carModel` int(12) DEFAULT 0,
  `carOwner` int(12) DEFAULT 0,
  `carPosX` float DEFAULT 0,
  `carPosY` float DEFAULT 0,
  `carPosZ` float DEFAULT 0,
  `carPosR` float DEFAULT 0,
  `carColor1` int(12) DEFAULT 0,
  `carColor2` int(12) DEFAULT 0,
  `carPaintjob` int(12) DEFAULT -1,
  `carLocked` smallint(4) DEFAULT 0,
  `carFaction` int(12) DEFAULT 0,
  `carFuel` float DEFAULT 0,
  `carMod1` int(12) DEFAULT 0,
  `carMod2` int(12) DEFAULT 0,
  `carMod3` int(12) DEFAULT 0,
  `carMod4` int(12) DEFAULT 0,
  `carMod5` int(12) DEFAULT 0,
  `carMod6` int(12) DEFAULT 0,
  `carMod7` int(12) DEFAULT 0,
  `carMod8` int(12) DEFAULT 0,
  `carMod9` int(12) DEFAULT 0,
  `carMod10` int(12) DEFAULT 0,
  `carMod11` int(12) DEFAULT 0,
  `carMod12` int(12) DEFAULT 0,
  `carMod13` int(12) DEFAULT 0,
  `carMod14` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `cars`
--

INSERT INTO `cars` (`carID`, `carModel`, `carOwner`, `carPosX`, `carPosY`, `carPosZ`, `carPosR`, `carColor1`, `carColor2`, `carPaintjob`, `carLocked`, `carFaction`, `carFuel`, `carMod1`, `carMod2`, `carMod3`, `carMod4`, `carMod5`, `carMod6`, `carMod7`, `carMod8`, `carMod9`, `carMod10`, `carMod11`, `carMod12`, `carMod13`, `carMod14`) VALUES
(1, 400, 1, 539.271, -1280.86, 17.3344, 122.49, 2, 2, -1, 0, -1, 77.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 429, 1, 529.231, -1287.09, 16.9216, 89.1231, 6, 6, -1, 1, -1, 64.9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 468, 1, 524.966, -1284.31, 16.9104, 107.966, 1, 1, -1, 0, -1, 39.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 522, 0, 531.925, -1263.12, 16.3058, 39.9738, 1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 522, 0, 527.75, -1265.67, 16.2096, 112.599, 1, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `carshop`
--

CREATE TABLE `carshop` (
  `carshopID` int(11) NOT NULL,
  `carshopModel` smallint(3) NOT NULL DEFAULT 0,
  `carshopPrice` int(11) NOT NULL DEFAULT 0,
  `carshopType` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `carshop`
--

INSERT INTO `carshop` (`carshopID`, `carshopModel`, `carshopPrice`, `carshopType`) VALUES
(10, 462, 10000, 1),
(11, 463, 20000, 1),
(12, 468, 30000, 1),
(13, 586, 40000, 1),
(14, 461, 50000, 1),
(15, 581, 60000, 1),
(17, 400, 80000, 2),
(18, 401, 90000, 2),
(19, 410, 100000, 2),
(20, 419, 200000, 2),
(21, 421, 300000, 2),
(22, 422, 400000, 2),
(23, 429, 500000, 2),
(24, 439, 600000, 2),
(25, 467, 700000, 2),
(26, 533, 800000, 2),
(27, 535, 900000, 2),
(28, 560, 1000000, 2),
(31, 562, 1000000, 2);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `ID` int(12) DEFAULT 0,
  `contactID` int(12) NOT NULL,
  `contactName` varchar(32) DEFAULT NULL,
  `contactNumber` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

-- --------------------------------------------------------

--
-- Table structure for table `entrances`
--

CREATE TABLE `entrances` (
  `entranceID` int(12) NOT NULL,
  `entranceName` varchar(32) DEFAULT NULL,
  `entranceIcon` int(12) DEFAULT 0,
  `entrancePosX` float DEFAULT 0,
  `entrancePosY` float DEFAULT 0,
  `entrancePosZ` float DEFAULT 0,
  `entrancePosA` float DEFAULT 0,
  `entranceIntX` float DEFAULT 0,
  `entranceIntY` float DEFAULT 0,
  `entranceIntZ` float DEFAULT 0,
  `entranceIntA` float DEFAULT 0,
  `entranceInterior` int(12) DEFAULT 0,
  `entranceExterior` int(12) DEFAULT 0,
  `entranceExteriorVW` int(12) DEFAULT 0,
  `entranceType` int(12) DEFAULT 0,
  `entrancePass` smallint(4) DEFAULT 0,
  `entranceLocked` int(12) DEFAULT 0,
  `entranceCustom` int(4) DEFAULT 0,
  `entranceWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `entrances`
--

INSERT INTO `entrances` (`entranceID`, `entranceName`, `entranceIcon`, `entrancePosX`, `entrancePosY`, `entrancePosZ`, `entrancePosA`, `entranceIntX`, `entranceIntY`, `entranceIntZ`, `entranceIntA`, `entranceInterior`, `entranceExterior`, `entranceExteriorVW`, `entranceType`, `entrancePass`, `entranceLocked`, `entranceCustom`, `entranceWorld`) VALUES
(1, 'กรมตำรวจ', 0, 1555.23, -1675.57, 16.1953, 266.806, 246.922, 62.3208, 1003.64, 1.371, 6, 0, 0, 0, 0, 0, 0, 7001),
(2, 'สถานที่สอบใบขับขี่', 0, 2045.04, -1918.66, 13.5469, 74.7805, -2029.55, -118.8, 1035.17, 0, 3, 0, 0, 1, 0, 0, 0, 7002),
(3, 'ร้านอาหาร', 0, 2105.49, -1806.49, 13.5547, 272.908, 372.41, -133.077, 1001.49, 191.146, 5, 0, 0, 0, 0, 0, 0, 7003),
(5, 'ร้านอาหาร', 0, 810.486, -1616.1, 13.5469, 129.124, 377.547, -192.564, 1000.63, 201.166, 17, 0, 0, 0, 0, 0, 0, 7005),
(6, 'สำนักงานนายกรัฐมนตรี', 0, 1122.71, -2037.08, 69.8942, 91.1367, 390.169, 173.807, 1008.38, 90, 3, 0, 0, 4, 0, 0, 0, 7006);

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `factionID` int(12) NOT NULL,
  `factionName` varchar(32) DEFAULT NULL,
  `factionColor` int(12) DEFAULT 0,
  `factionType` int(12) DEFAULT 0,
  `factionRanks` int(12) DEFAULT 0,
  `factionLockerX` float DEFAULT 0,
  `factionLockerY` float DEFAULT 0,
  `factionLockerZ` float DEFAULT 0,
  `factionLockerInt` int(12) DEFAULT 0,
  `factionLockerWorld` int(12) DEFAULT 0,
  `factionWeapon1` int(12) DEFAULT 0,
  `factionAmmo1` int(12) DEFAULT 0,
  `factionWeapon2` int(12) DEFAULT 0,
  `factionAmmo2` int(12) DEFAULT 0,
  `factionWeapon3` int(12) DEFAULT 0,
  `factionAmmo3` int(12) DEFAULT 0,
  `factionWeapon4` int(12) DEFAULT 0,
  `factionAmmo4` int(12) DEFAULT 0,
  `factionWeapon5` int(12) DEFAULT 0,
  `factionAmmo5` int(12) DEFAULT 0,
  `factionWeapon6` int(12) DEFAULT 0,
  `factionAmmo6` int(12) DEFAULT 0,
  `factionWeapon7` int(12) DEFAULT 0,
  `factionAmmo7` int(12) DEFAULT 0,
  `factionWeapon8` int(12) DEFAULT 0,
  `factionAmmo8` int(12) DEFAULT 0,
  `factionWeapon9` int(12) DEFAULT 0,
  `factionAmmo9` int(12) DEFAULT 0,
  `factionWeapon10` int(12) DEFAULT 0,
  `factionAmmo10` int(12) DEFAULT 0,
  `factionRank1` varchar(32) DEFAULT NULL,
  `factionRank2` varchar(32) DEFAULT NULL,
  `factionRank3` varchar(32) DEFAULT NULL,
  `factionRank4` varchar(32) DEFAULT NULL,
  `factionRank5` varchar(32) DEFAULT NULL,
  `factionRank6` varchar(32) DEFAULT NULL,
  `factionRank7` varchar(32) DEFAULT NULL,
  `factionRank8` varchar(32) DEFAULT NULL,
  `factionRank9` varchar(32) DEFAULT NULL,
  `factionRank10` varchar(32) DEFAULT NULL,
  `factionRank11` varchar(32) DEFAULT NULL,
  `factionRank12` varchar(32) DEFAULT NULL,
  `factionRank13` varchar(32) DEFAULT NULL,
  `factionRank14` varchar(32) DEFAULT NULL,
  `factionRank15` varchar(32) DEFAULT NULL,
  `factionSkin1` int(12) DEFAULT 0,
  `factionSkin2` int(12) DEFAULT 0,
  `factionSkin3` int(12) DEFAULT 0,
  `factionSkin4` int(12) DEFAULT 0,
  `factionSkin5` int(12) DEFAULT 0,
  `factionSkin6` int(12) DEFAULT 0,
  `factionSkin7` int(12) DEFAULT 0,
  `factionSkin8` int(12) DEFAULT 0,
  `SpawnX` float DEFAULT NULL,
  `SpawnY` float DEFAULT NULL,
  `SpawnZ` float DEFAULT NULL,
  `SpawnInterior` int(11) DEFAULT NULL,
  `SpawnVW` int(1) DEFAULT NULL,
  `factionEntrance` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `factions`
--

INSERT INTO `factions` (`factionID`, `factionName`, `factionColor`, `factionType`, `factionRanks`, `factionLockerX`, `factionLockerY`, `factionLockerZ`, `factionLockerInt`, `factionLockerWorld`, `factionWeapon1`, `factionAmmo1`, `factionWeapon2`, `factionAmmo2`, `factionWeapon3`, `factionAmmo3`, `factionWeapon4`, `factionAmmo4`, `factionWeapon5`, `factionAmmo5`, `factionWeapon6`, `factionAmmo6`, `factionWeapon7`, `factionAmmo7`, `factionWeapon8`, `factionAmmo8`, `factionWeapon9`, `factionAmmo9`, `factionWeapon10`, `factionAmmo10`, `factionRank1`, `factionRank2`, `factionRank3`, `factionRank4`, `factionRank5`, `factionRank6`, `factionRank7`, `factionRank8`, `factionRank9`, `factionRank10`, `factionRank11`, `factionRank12`, `factionRank13`, `factionRank14`, `factionRank15`, `factionSkin1`, `factionSkin2`, `factionSkin3`, `factionSkin4`, `factionSkin5`, `factionSkin6`, `factionSkin7`, `factionSkin8`, `SpawnX`, `SpawnY`, `SpawnZ`, `SpawnInterior`, `SpawnVW`, `factionEntrance`) VALUES
(1, 'กรมตำรวจ', 12117, 1, 5, 254.506, 76.7007, 1003.64, 6, 7001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Rank 1', 'Rank 2', 'Rank 3', 'Rank 4', 'Rank 5', 'Rank 6', 'Rank 7', 'Rank 8', 'Rank 9', 'Rank 10', 'Rank 11', 'Rank 12', 'Rank 13', 'Rank 14', 'Rank 15', 284, 280, 281, 282, 283, 288, 0, 0, 255.988, 67.2341, 1003.64, 6, 7001, 1),
(2, 'แพทย์', 11302272, 3, 5, 1172.15, -1324.04, 15.4045, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'แพทย์ฝึกหัด', 'แพทย์', 'นายแพทย์', 'รองหัวหน้าแพทย์', 'หัวหน้าแพทย์', 'Rank 6', 'Rank 7', 'Rank 8', 'Rank 9', 'Rank 10', 'Rank 11', 'Rank 12', 'Rank 13', 'Rank 14', 'Rank 15', 70, 71, 0, 0, 0, 0, 0, 0, 1172.08, -1323.78, 15.4039, 0, 0, 0),
(5, 'นาวิกโยทิน', 7691336, 1, 5, 2729.36, -2451.51, 17.5937, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'พลทหาร', 'จ่า', 'ผู้ช่วย', 'รองผบ.นาวิกโยทิน', 'ผบ.นาวิกโยทิน', 'Rank 6', 'Rank 7', 'Rank 8', 'Rank 9', 'Rank 10', 'Rank 11', 'Rank 12', 'Rank 13', 'Rank 14', 'Rank 15', 287, 0, 0, 0, 0, 0, 0, 0, 355.816, 173.859, 1008.38, 3, 7006, 6),
(7, 'สำนักนายกรัฐมนตรี', -256, 4, 5, 355.888, 173.919, 1008.38, 3, 7006, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Rank 1', 'Rank 2', 'Rank 3', 'Rank 4', 'Rank 5', 'Rank 6', 'Rank 7', 'Rank 8', 'Rank 9', 'Rank 10', 'Rank 11', 'Rank 12', 'Rank 13', 'Rank 14', 'Rank 15', 111, 113, 0, 0, 0, 0, 0, 0, 355.276, 173.044, 1008.39, 3, 7006, 6),
(8, 'สลัมด็อก', -256, 1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Rank 1', 'Rank 2', 'Rank 3', 'Rank 4', 'Rank 5', 'Rank 6', 'Rank 7', 'Rank 8', 'Rank 9', 'Rank 10', 'Rank 11', 'Rank 12', 'Rank 13', 'Rank 14', 'Rank 15', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `garages`
--

CREATE TABLE `garages` (
  `garageID` int(11) NOT NULL,
  `garageX` float NOT NULL,
  `garageY` float NOT NULL,
  `garageZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `garages`
--

INSERT INTO `garages` (`garageID`, `garageX`, `garageY`, `garageZ`) VALUES
(1, 90.1301, -165.465, 2.5938),
(2, 552.595, -1276.07, 17.2482);

-- --------------------------------------------------------

--
-- Table structure for table `gps`
--

CREATE TABLE `gps` (
  `gpsID` int(11) NOT NULL,
  `gpsName` varchar(32) DEFAULT NULL,
  `gpsX` float NOT NULL,
  `gpsY` float NOT NULL,
  `gpsZ` float NOT NULL,
  `gpsType` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `gps`
--

INSERT INTO `gps` (`gpsID`, `gpsName`, `gpsX`, `gpsY`, `gpsZ`, `gpsType`) VALUES
(9, 'งานเก็บหอย', 562.823, -1891.92, 3.4606, 2),
(10, 'งานเก็บส้ม', 18.8522, -2621.51, 40.3677, 2),
(11, 'งานฆ่าวัว', -925.629, -526.547, 25.9536, 2),
(12, 'จุดแร่เนื้อวัว', -955.501, -503.613, 27.4752, 2),
(13, 'งานฆ่าไก่', -1387.62, -1504.48, 101.975, 2),
(14, 'จุดแร่เนื้อไก่', -1336.28, -1452.43, 103.675, 2),
(15, 'งานตกปลา', 835.205, -2064.4, 12.8672, 2),
(16, 'อู่ซ่อมรถ', 95.1613, -164.797, 2.5938, 1),
(17, 'ร้านอาหาร', 2104.6, -1806.51, 13.5547, 1),
(18, 'โรงพยาบาล', 1186.29, -1324.87, 13.5593, 1),
(19, 'งานขุดเหมือง', 671.81, 911.212, -40.439, 2),
(20, 'ตลาด', 1129.08, -1413.71, 13.6053, 1),
(21, 'งานเก็บแอปเปิ้ล', -1103.37, -1270.89, 129.219, 2),
(22, 'งานตัดไม้', -512.394, -154.386, 73.9965, 2),
(23, 'จุดแปรรูปไม้', -533.552, -176.756, 78.4047, 2),
(24, 'จุดทำใบขับขี่', 2048.95, -1918.78, 13.5469, 1),
(25, 'จุดขนกัญชาที่1', -1423.33, -950.396, 201.094, 3),
(26, 'จุดขนกัญชาที่2', 1932.3, 234.666, 28.8345, 3),
(27, 'จุดขนกัญชาที่3', -1056.12, -996.067, 129.219, 3),
(28, 'ร้านขายรถส่วนตัว', 541.298, -1291.57, 17.2422, 1);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `invID` int(12) NOT NULL,
  `invOwner` int(11) NOT NULL DEFAULT 0,
  `invItem` varchar(32) DEFAULT NULL,
  `invQuantity` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`invID`, `invOwner`, `invItem`, `invQuantity`) VALUES
(3, 1, 'มือถือ', 1),
(5, 2, 'น้ำเปล่า', 3),
(6, 2, 'พิซซ่า', 3),
(7, 2, 'มือถือ', 1),
(70, 2, 'เหยื่อ', 1),
(71, 2, 'เนื้อวัว', 14),
(109, 1, 'ใบขับขี่รถยนต์', 1);

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `playerID` int(11) NOT NULL,
  `playerName` varchar(24) NOT NULL,
  `playerPassword` char(129) NOT NULL,
  `playerRegDate` char(90) NOT NULL DEFAULT 'None',
  `playerGender` tinyint(2) NOT NULL DEFAULT 0,
  `playerBirthday` char(24) NOT NULL DEFAULT 'แก้ไข',
  `playerAdmin` tinyint(2) NOT NULL DEFAULT 0,
  `playerKills` mediumint(8) NOT NULL DEFAULT 0,
  `playerDeaths` mediumint(8) NOT NULL DEFAULT 0,
  `playerMoney` int(11) NOT NULL DEFAULT 0,
  `playerBank` int(11) NOT NULL DEFAULT 0,
  `playerRedMoney` int(11) NOT NULL DEFAULT 0,
  `playerLevel` smallint(3) NOT NULL DEFAULT 0,
  `playerExp` int(11) NOT NULL DEFAULT 0,
  `playerMinutes` tinyint(2) NOT NULL DEFAULT 0,
  `playerHours` int(11) NOT NULL DEFAULT 0,
  `playerPosX` float NOT NULL DEFAULT 0,
  `playerPosY` float NOT NULL DEFAULT 0,
  `playerPosZ` float NOT NULL DEFAULT 0,
  `playerPosA` float NOT NULL DEFAULT 0,
  `playerSkin` smallint(3) NOT NULL DEFAULT 0,
  `playerInterior` tinyint(2) NOT NULL DEFAULT 0,
  `playerWorld` int(11) NOT NULL DEFAULT 0,
  `playerTutorial` tinyint(1) NOT NULL DEFAULT 0,
  `playerSpawn` tinyint(1) NOT NULL DEFAULT 0,
  `playerThirsty` float NOT NULL DEFAULT 0,
  `playerHungry` float NOT NULL DEFAULT 0,
  `playerHealth` float NOT NULL DEFAULT 0,
  `playerInjured` tinyint(1) NOT NULL DEFAULT 0,
  `playerInjuredTime` int(11) NOT NULL DEFAULT 0,
  `playerFaction` tinyint(2) NOT NULL DEFAULT -1,
  `playerFactionRank` tinyint(2) NOT NULL DEFAULT 0,
  `playerPrisoned` tinyint(1) NOT NULL DEFAULT 0,
  `playerPrisonOut` smallint(3) NOT NULL DEFAULT 0,
  `playerJailTime` smallint(3) NOT NULL DEFAULT 0,
  `playerEntrance` int(11) NOT NULL DEFAULT -1,
  `playerMaxItem` int(11) NOT NULL DEFAULT 8,
  `playerItemAmount` int(11) NOT NULL DEFAULT 20,
  `playerPhone` int(11) NOT NULL DEFAULT 0,
  `playerVIP` tinyint(1) NOT NULL DEFAULT 0,
  `playerQuest` smallint(5) NOT NULL DEFAULT 0,
  `playerQuestProgress` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`playerID`, `playerName`, `playerPassword`, `playerRegDate`, `playerGender`, `playerBirthday`, `playerAdmin`, `playerKills`, `playerDeaths`, `playerMoney`, `playerBank`, `playerRedMoney`, `playerLevel`, `playerExp`, `playerMinutes`, `playerHours`, `playerPosX`, `playerPosY`, `playerPosZ`, `playerPosA`, `playerSkin`, `playerInterior`, `playerWorld`, `playerTutorial`, `playerSpawn`, `playerThirsty`, `playerHungry`, `playerHealth`, `playerInjured`, `playerInjuredTime`, `playerFaction`, `playerFactionRank`, `playerPrisoned`, `playerPrisonOut`, `playerJailTime`, `playerEntrance`, `playerMaxItem`, `playerItemAmount`, `playerPhone`, `playerVIP`, `playerQuest`, `playerQuestProgress`) VALUES
(1, 'test12', '1682E8378C4E2BB77DEE9936479EE76CB601AEB8F4568336ADC77D13602A985E5D8A2077203153FBFDDF37AEE24643294EDEBEC5F0DAB1006B0D9D74CA65728C', '19-09-2020 01:18:24', 1, '17/06/1989', 6, 0, 1, 8854272, 0, 0, 1, 300, 2, 30, 512.552, -1298.98, 17.2422, 161.416, 299, 0, 0, 1, 2, 18.148, 26.112, 63, 0, 0, 1, 5, 0, 0, 0, -1, 14, 20, 905005, 3, 4, 0),
(2, 'Assbel', '3BE9960E4954A2366255DCD371C11401BED5324FAF05C30F5001258ED1DD7A596A53646A27BAE4DD0C00BF42115A7528773DA6A1EEA4D5499F0554E66308ED60', '19-09-2020 01:28:29', 1, '1/1/1987', 6, 0, 0, 1000117, 0, 1009, 1, 3, 46, 2, 1258.49, -1822.89, 13.4, 103.024, 299, 0, 0, 1, 0, 85.989, 89.467, 100, 0, 0, -1, 0, 0, 0, 0, -1, 14, 20, 993685, 3, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `pumps`
--

CREATE TABLE `pumps` (
  `pumpID` int(11) NOT NULL,
  `pumpX` float NOT NULL,
  `pumpY` float NOT NULL,
  `pumpZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `pumps`
--

INSERT INTO `pumps` (`pumpID`, `pumpX`, `pumpY`, `pumpZ`) VALUES
(7, 1945.03, -1774.58, 13.3906),
(8, 1937.53, -1774.7, 13.3828),
(9, -1673.03, 416.5, 7.1797),
(10, -1666.97, 409.198, 7.1797),
(11, -1679.87, 422.604, 7.1797),
(12, -90.5865, -1167.25, 2.4325),
(13, 540.772, -1285.86, 17.2422),
(14, 552.808, -1273.06, 17.2422),
(15, 626.523, -1329.77, 13.3797);

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `shopID` int(11) NOT NULL,
  `shopX` float NOT NULL,
  `shopY` float NOT NULL,
  `shopZ` float NOT NULL,
  `shopInterior` int(11) NOT NULL,
  `shopWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`shopID`, `shopX`, `shopY`, `shopZ`, `shopInterior`, `shopWorld`) VALUES
(2, 375.924, -119.336, 1001.5, 5, 7003),
(3, 379.049, -187.903, 1000.63, 17, 7005),
(4, 552.77, -1267.56, 17.2422, 0, 0),
(5, 832.088, -2062.38, 12.8672, 0, 0),
(6, -526.864, -175.137, 78.4047, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `weedactor`
--

CREATE TABLE `weedactor` (
  `weedID` int(11) NOT NULL,
  `weedX` float NOT NULL,
  `weedY` float NOT NULL,
  `weedZ` float NOT NULL,
  `weedA` float NOT NULL,
  `weedInterior` int(11) NOT NULL,
  `weedWorld` int(11) NOT NULL,
  `weedSkin` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;

--
-- Dumping data for table `weedactor`
--

INSERT INTO `weedactor` (`weedID`, `weedX`, `weedY`, `weedZ`, `weedA`, `weedInterior`, `weedWorld`, `weedSkin`) VALUES
(17, 526.078, -1281.13, 17.2422, 220.408, 0, 0, 265),
(18, 528.25, -1278.81, 17.2422, 220.094, 0, 0, 264),
(19, 533.177, -1274.81, 17.2422, 220.094, 0, 0, 263),
(20, 536.845, -1272.37, 17.2422, 220.094, 0, 0, 262);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `arrestpoints`
--
ALTER TABLE `arrestpoints`
  ADD PRIMARY KEY (`arrestID`);

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`atmID`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`BanID`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`carID`);

--
-- Indexes for table `carshop`
--
ALTER TABLE `carshop`
  ADD PRIMARY KEY (`carshopID`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contactID`);

--
-- Indexes for table `entrances`
--
ALTER TABLE `entrances`
  ADD PRIMARY KEY (`entranceID`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`factionID`);

--
-- Indexes for table `garages`
--
ALTER TABLE `garages`
  ADD PRIMARY KEY (`garageID`);

--
-- Indexes for table `gps`
--
ALTER TABLE `gps`
  ADD PRIMARY KEY (`gpsID`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`invID`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`playerID`),
  ADD UNIQUE KEY `Username` (`playerName`);

--
-- Indexes for table `pumps`
--
ALTER TABLE `pumps`
  ADD PRIMARY KEY (`pumpID`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`shopID`);

--
-- Indexes for table `weedactor`
--
ALTER TABLE `weedactor`
  ADD PRIMARY KEY (`weedID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `arrestpoints`
--
ALTER TABLE `arrestpoints`
  MODIFY `arrestID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `BanID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `carID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `carshop`
--
ALTER TABLE `carshop`
  MODIFY `carshopID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contactID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `entranceID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `garages`
--
ALTER TABLE `garages`
  MODIFY `garageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gps`
--
ALTER TABLE `gps`
  MODIFY `gpsID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `invID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `playerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `pumps`
--
ALTER TABLE `pumps`
  MODIFY `pumpID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `shopID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `weedactor`
--
ALTER TABLE `weedactor`
  MODIFY `weedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
