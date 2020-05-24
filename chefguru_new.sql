-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 24, 2020 at 12:37 PM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 7.4.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chefguru_new`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `adminDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `adminDetails` (IN `username` CHAR(6))  NO SQL
select * from `admin` where `id`=username AND `is_deleted` = 0 LIMIT 1$$

DROP PROCEDURE IF EXISTS `cashierDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cashierDetails` (IN `username` CHAR(6))  NO SQL
select * from `cashier` where `id`=username AND `is_deleted` = 0 LIMIT 1$$

DROP PROCEDURE IF EXISTS `changePassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `changePassword` (IN `username` CHAR(6), IN `password` VARCHAR(255))  NO SQL
UPDATE `user` SET `password`= password WHERE `id` = username$$

DROP PROCEDURE IF EXISTS `checkoutRoomId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkoutRoomId` ()  NO SQL
SELECT * FROM `room` WHERE (`status` = 1 OR `status` = 2) AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `createCheckInDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCheckInDetails` (IN `tId` INT, IN `gId` CHAR(12), IN `rId` INT, IN `checkinDate` DATE, IN `checkoutDate` DATE, IN `dId` INT, IN `advancePayment` FLOAT, IN `totalBalance` FLOAT)  NO SQL
BEGIN
	INSERT INTO `checkin`(`id`, `guest_id`, `room_id`, `checkin_date`, `checkout_date`, `discount_id`, `advance_payment`, `total_balance`) VALUES (tId, gId, rId, checkinDate, checkoutDate, dId, advancePayment, totalBalance);
	UPDATE `room` SET `status`= 2 WHERE `id` = rId;
END$$

DROP PROCEDURE IF EXISTS `createCheckoutDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCheckoutDetails` (IN `rId` INT)  NO SQL
BEGIN
	UPDATE `checkin` SET `is_checkout`= 1 WHERE `room_id` = rId AND `is_checkout` = 0 AND `is_deleted` = 0;
	UPDATE `room` SET `status`= 0 WHERE `id` = rId;
END$$

DROP PROCEDURE IF EXISTS `createDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createDiscountDetails` (IN `dId` INT, IN `dType` VARCHAR(20), IN `dRate` INT(3))  NO SQL
INSERT INTO `discount`(`id`, `type`, `rate`, `is_deleted`) VALUES (dId, dType, dRate, 0)$$

DROP PROCEDURE IF EXISTS `createGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createGuestDetails` (IN `gId` CHAR(12), IN `fName` VARCHAR(20), IN `lName` VARCHAR(20), IN `address` VARCHAR(200), IN `email` VARCHAR(100), IN `phone` CHAR(10))  NO SQL
INSERT INTO `guest`(`id`, `fName`, `lName`, `address`, `email`, `phone`) VALUES (gId, fName, lName, address, email, phone)$$

DROP PROCEDURE IF EXISTS `createRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createRoomDetails` (IN `rId` INT, IN `rType` CHAR(3), IN `rRate` INT, IN `rOccupancy` INT)  NO SQL
INSERT INTO `room`(`id`, `type`, `rate`, `noOfOccupancy`, `status`, `is_deleted`) VALUES (rId, rType, rRate, rOccupancy, 0, 0)$$

DROP PROCEDURE IF EXISTS `createUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUserDetails` (IN `username` CHAR(6), IN `fName` VARCHAR(20), IN `lName` VARCHAR(20), IN `email` VARCHAR(100), IN `phone` CHAR(10), IN `password` VARCHAR(255))  NO SQL
BEGIN
	INSERT INTO `cashier`(`id`, `firstName`, `lastName`, `email`, `mobile`, `is_deleted`) VALUES (username, fName, lName, email, phone, 0);
    INSERT INTO `user`(`id`, `password`, `role`, `is_deleted`) VALUES (username, password, 'cashier', 0);
END$$

DROP PROCEDURE IF EXISTS `deleteCheckoutDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCheckoutDetails` (IN `rId` INT)  NO SQL
BEGIN
	UPDATE `checkin` SET `is_deleted`= 1 WHERE `room_id` = rId;
	UPDATE `room` SET `status`= 0 WHERE `id` = rId;
END$$

DROP PROCEDURE IF EXISTS `deleteDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDiscountDetails` (IN `dId` INT)  NO SQL
UPDATE `discount` SET `is_deleted`= 1 WHERE `id` = dId$$

DROP PROCEDURE IF EXISTS `deleteGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGuestDetails` (IN `gId` CHAR(12))  NO SQL
UPDATE `guest` SET `is_deleted`= 1 WHERE `id` = gId$$

DROP PROCEDURE IF EXISTS `deleteRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoomDetails` (IN `rId` INT)  NO SQL
UPDATE `room` SET `is_deleted`= 1 WHERE `id` = rId$$

DROP PROCEDURE IF EXISTS `deleteUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUserDetails` (IN `username` CHAR(6))  BEGIN
	UPDATE `user` SET `is_deleted` = 1 WHERE `id` = username;
	UPDATE `admin` SET `is_deleted` = 1 WHERE `id` = username;
	UPDATE `cashier` SET `is_deleted` = 1 WHERE `id` = username;
END$$

DROP PROCEDURE IF EXISTS `discountTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `discountTypeDetails` ()  NO SQL
SELECT * FROM `discount` WHERE `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `getDiscountTypeId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDiscountTypeId` (IN `dType` VARCHAR(20))  NO SQL
SELECT * FROM `discount` WHERE `type` = dType AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `getRoomTypeId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRoomTypeId` (IN `rType` VARCHAR(20))  NO SQL
SELECT * FROM `room_type` WHERE `type` = rType AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `lastDiscountId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastDiscountId` ()  NO SQL
SELECT * FROM `discount` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastId` ()  NO SQL
SELECT * FROM `cashier` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastRoomId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastRoomId` ()  NO SQL
SELECT * FROM `room` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastTransactionId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastTransactionId` ()  NO SQL
SELECT * FROM `checkin` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `username` CHAR(6))  NO SQL
select * from `user` where `id`=username AND `is_deleted` = 0 LIMIT 1$$

DROP PROCEDURE IF EXISTS `roomIdDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `roomIdDetails` ()  NO SQL
SELECT r.`id`, t.`type`, r.`rate`, r.`noOfOccupancy` FROM `room` r, `room_type` t WHERE r.`type` = t.`id` AND r.`status` = 0 AND r.`is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `roomTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `roomTypeDetails` ()  NO SQL
SELECT * FROM `room_type` WHERE `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `updateDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDiscountDetails` (IN `dId` INT, IN `dType` VARCHAR(20), IN `dRate` INT(3))  NO SQL
BEGIN
    UPDATE `discount` SET `type`= dType,`rate`= dRate WHERE `id` = dId;
END$$

DROP PROCEDURE IF EXISTS `updateGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateGuestDetails` (IN `gId` CHAR(12), IN `fName` VARCHAR(20), IN `lName` VARCHAR(20), IN `address` VARCHAR(200), IN `email` VARCHAR(100), IN `phone` CHAR(10))  NO SQL
UPDATE `guest` SET `fName`= fName,`lName`= lName,`address`= address,`email`= email,`phone`= phone WHERE `id` = username$$

DROP PROCEDURE IF EXISTS `updateRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoomDetails` (IN `rId` INT, IN `rType` CHAR(3), IN `rRate` INT, IN `rOccupancy` INT)  NO SQL
UPDATE `room` SET `type`= rType,`rate`= rRate,`noOfOccupancy`= rOccupancy WHERE `id`= rId$$

DROP PROCEDURE IF EXISTS `updateUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserDetails` (IN `username` CHAR(6), IN `fName` VARCHAR(20), IN `lName` VARCHAR(20), IN `email` VARCHAR(100), IN `phone` CHAR(10))  NO SQL
BEGIN
	UPDATE `cashier` SET `firstName`=fName,`lastName`=lName,`email`=email,`mobile`=phone WHERE `id` = username;
    UPDATE `admin` SET `firstName`=fName,`lastName`=lName,`email`=email,`mobile`=phone WHERE `id` = username;
END$$

DROP PROCEDURE IF EXISTS `viewCheckoutDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewCheckoutDetails` ()  NO SQL
SELECT `room_id` AS 'Room ID', `id` AS 'Transaction ID', `guest_id` AS 'Guest ID', `checkin_date` AS 'Checkin Date', `checkout_date` AS 'Checkout Date', `total_balance` AS 'Total Balance', `advance_payment` AS 'Advance Payment' FROM `checkin` WHERE `is_checkout`  = 0 AND `is_deleted` = 0 ORDER BY `room_id`$$

DROP PROCEDURE IF EXISTS `viewDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewDiscountDetails` ()  NO SQL
SELECT `id` AS 'ID', `type` AS 'Discount Type', `rate` AS 'Discount Rate (%)' FROM `discount` WHERE `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `viewGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewGuestDetails` ()  NO SQL
SELECT `id` AS 'Id', `fName` AS 'First Name', `lName` AS 'Last Name', `address` AS 'Address', `email` AS 'Email', `phone` AS 'Phone' FROM `guest` WHERE `is_deleted` = 0 ORDER BY `id` ASC$$

DROP PROCEDURE IF EXISTS `viewRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRoomDetails` ()  NO SQL
SELECT r.`id` AS 'ID', t.`type` AS 'Room Type', r.`rate` AS 'Room Rate', r.`noOfOccupancy` AS 'No of Occupancy', IF(r.`status`=0, 'Available', IF(r.`status`=1, 'Booked', 'Occupied')) AS 'Room Status' FROM `room` r, `room_type` t WHERE r.`type` = t.`id` AND r.`is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `viewSelfDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewSelfDetails` (IN `username` CHAR(6))  NO SQL
SELECT `id` AS 'ID', `firstName` AS 'First Name', `lastName` AS 'Last Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `admin` WHERE `is_deleted` = 0 AND `id` = username
UNION
SELECT `id` AS 'ID', `firstName` AS 'First Name', `lastName` AS 'Last Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `cashier` WHERE `is_deleted` = 0 AND `id` = username$$

DROP PROCEDURE IF EXISTS `viewUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewUserDetails` ()  NO SQL
SELECT `id` AS 'ID', `firstName` AS 'First Name', `lastName` AS 'Last Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `admin` WHERE `is_deleted` = 0
UNION
SELECT `id` AS 'ID', `firstName` AS 'First Name', `lastName` AS 'Last Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `cashier` WHERE `is_deleted` = 0$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `id` char(6) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` char(10) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `email`, `mobile`, `is_deleted`) VALUES
('ADM001', 'Chef', 'tg2017233@gmail.com', '0771637551', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cashier`
--

DROP TABLE IF EXISTS `cashier`;
CREATE TABLE IF NOT EXISTS `cashier` (
  `id` char(6) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` char(10) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cashier`
--

INSERT INTO `cashier` (`id`, `name`, `email`, `mobile`, `is_deleted`) VALUES
('CSR001', 'Madushan', 'sandaru1wgm@gmail.com', '0718925949', 0);

-- --------------------------------------------------------

--
-- Table structure for table `checkin`
--

DROP TABLE IF EXISTS `checkin`;
CREATE TABLE IF NOT EXISTS `checkin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guest_id` char(12) NOT NULL,
  `room_id` int(11) NOT NULL,
  `checkin_date` date NOT NULL,
  `checkout_date` date NOT NULL,
  `discount_id` int(11) NOT NULL,
  `advance_payment` float NOT NULL,
  `total_balance` float NOT NULL,
  `is_checkout` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `checkin`
--

INSERT INTO `checkin` (`id`, `guest_id`, `room_id`, `checkin_date`, `checkout_date`, `discount_id`, `advance_payment`, `total_balance`, `is_checkout`, `is_deleted`) VALUES
(2, '980171329v', 2, '2020-02-09', '2020-02-17', 3, 26000, 26600, 0, 1),
(3, '980171329v', 2, '2020-02-09', '2020-02-10', 3, 1500, 3325, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `customer_message`
--

DROP TABLE IF EXISTS `customer_message`;
CREATE TABLE IF NOT EXISTS `customer_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `message` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_message`
--

INSERT INTO `customer_message` (`id`, `name`, `email`, `phone`, `message`) VALUES
(1, 'Madushan Sandaruwan Karunasena', 'madushansandaru1@gmail.com', '+94771637551', 'hiii');

-- --------------------------------------------------------

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
CREATE TABLE IF NOT EXISTS `discount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `rate` int(3) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `discount`
--

INSERT INTO `discount` (`id`, `type`, `rate`, `is_deleted`) VALUES
(1, 'holi', 1, 0),
(2, 'New Year - 2020', 3, 0),
(3, 'Christmas', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
CREATE TABLE IF NOT EXISTS `guest` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `identity` varchar(30) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(200) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` char(10) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`no`)
) ENGINE=MyISAM AUTO_INCREMENT=980171330 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`no`, `identity`, `name`, `address`, `email`, `phone`, `is_deleted`) VALUES
(1, '980171329V', 'madushan', 'hatton', 'tg2017233@gmail.com', '0771637551', 0),
(2, '', 'dul', 'k', 'bh@mk.co', '7854', 0),
(3, '', 'gd', 'rew`', 'g@hbj.j', '989', 0),
(4, '', 'mmm', 'hhhhh', 'mas@gm.co', '0741253698', 0);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
CREATE TABLE IF NOT EXISTS `room` (
  `id` int(11) NOT NULL,
  `type` char(3) NOT NULL,
  `rate` int(11) NOT NULL,
  `noOfOccupancy` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `type`, `rate`, `noOfOccupancy`, `status`, `is_deleted`) VALUES
(1, 'T01', 2000, 2, 0, 0),
(2, 'T02', 3500, 3, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `room_book`
--

DROP TABLE IF EXISTS `room_book`;
CREATE TABLE IF NOT EXISTS `room_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `check_in_date` date NOT NULL,
  `no_of_room` int(11) NOT NULL,
  `message` varchar(500) NOT NULL,
  `is_canceled` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room_book`
--

INSERT INTO `room_book` (`id`, `name`, `email`, `phone`, `check_in_date`, `no_of_room`, `message`, `is_canceled`, `is_deleted`) VALUES
(1, 'Madushan Sandaruwan Karunasena', 'madushansandaru1@gmail.com', '+94771637551', '2020-05-24', 2, 'hii hhhbsb sjkdksj', 0, 0),
(2, 'Madushan Sandaruwan Karunasena', 'madushansandaru1@gmail.com', '+94771637551', '2020-05-24', 2, 'hii hhhbsb sjkdksj', 0, 0),
(3, 'Madushan Sandaruwan Karunasena', 'madushansandaru1@gmail.com', '+94771637551', '2020-05-27', 3, 'fesf', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `room_type`
--

DROP TABLE IF EXISTS `room_type`;
CREATE TABLE IF NOT EXISTS `room_type` (
  `id` char(3) NOT NULL,
  `type` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `image` varchar(255) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room_type`
--

INSERT INTO `room_type` (`id`, `type`, `description`, `price`, `image`, `is_deleted`) VALUES
('T01', 'Single', 'A room assigned to one person. May have one or more beds.  The room size or area of Single Rooms are generally between 37 m to 45 m', 50, 'room_type_default.jpg', 0),
('T02', 'Double', 'A room assigned to one person. May have one or more beds.  The room size or area of Single Rooms are generally between 37 m to 45 m', 100, 'room_type_default.jpg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` char(6) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(7) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `password`, `role`, `is_deleted`) VALUES
('ADM001', '123', 'admin', 0),
('CSR001', '123', 'cashier', 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
