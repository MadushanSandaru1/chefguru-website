-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 27, 2020 at 11:39 AM
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
-- Database: `chefguru`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `adminDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `adminDetails` (IN `username` CHAR(6))  NO SQL
select * from `admin` where `id`=username AND `is_deleted` = 0 LIMIT 1$$

DROP PROCEDURE IF EXISTS `cancelAutoTimeoutBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelAutoTimeoutBooking` ()  NO SQL
UPDATE `room_book` SET `is_canceled` = 1 WHERE `is_canceled` = 0 AND `is_deleted` = 0 AND `check_in_date` < CURRENT_DATE()$$

DROP PROCEDURE IF EXISTS `cancelBookingDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelBookingDetails` (IN `bId` INT)  NO SQL
UPDATE `room_book` SET `is_canceled` = 1 WHERE `id` = bId$$

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCheckInDetails` (IN `tId` INT, IN `gId` VARCHAR(20), IN `rId` INT, IN `checkinDate` DATETIME, IN `checkoutDate` DATETIME, IN `dId` INT, IN `advancePayment` FLOAT)  NO SQL
BEGIN
	INSERT INTO `checkin`(`id`, `guest_id`, `room_id`, `checkin_date`, `checkout_date`, `discount_id`, `advance_payment`) VALUES (tId, gId, rId, checkinDate, checkoutDate, dId, advancePayment);
	UPDATE `room` SET `status`= 2 WHERE `id` = rId;
    INSERT INTO `transaction`(`type`, `amount`) VALUES ('R',advancePayment);
END$$

DROP PROCEDURE IF EXISTS `createCheckoutByGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCheckoutByGuestDetails` (IN `gId` VARCHAR(20), IN `pendingAmount` FLOAT)  NO SQL
BEGIN
	UPDATE `room` SET `status`= 0 WHERE `id` IN (SELECT `room_id` FROM `checkin` WHERE `guest_id` = gId AND `is_checkout` = 0 AND `is_deleted` = 0);
    UPDATE `room_food` SET `is_deleted`= 1 WHERE `room_id` IN (SELECT `room_id` FROM `checkin` WHERE `guest_id` = gId AND `is_checkout` = 0 AND `is_deleted` = 0);
    UPDATE `checkin` SET `is_checkout`= 1 WHERE `guest_id` = gId AND `is_checkout` = 0 AND `is_deleted` = 0;
	INSERT INTO `transaction`(`type`, `amount`) VALUES ('R',pendingAmount);
END$$

DROP PROCEDURE IF EXISTS `createCheckoutByRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCheckoutByRoomDetails` (IN `rId` INT, IN `pendingAmount` FLOAT)  NO SQL
BEGIN
	UPDATE `checkin` SET `is_checkout`= 1 WHERE `room_id` = rId AND `is_checkout` = 0 AND `is_deleted` = 0;
	UPDATE `room` SET `status`= 0 WHERE `id` = rId;
    UPDATE `room_food` SET `is_deleted`= 1 WHERE `room_id` = rId;
    INSERT INTO `transaction`(`type`, `amount`) VALUES ('R',pendingAmount);
END$$

DROP PROCEDURE IF EXISTS `createDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createDiscountDetails` (IN `dId` INT, IN `dType` VARCHAR(15), IN `dRate` INT(3))  NO SQL
INSERT INTO `discount`(`id`, `type`, `rate`, `is_deleted`) VALUES (dId, dType, dRate, 0)$$

DROP PROCEDURE IF EXISTS `createGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createGuestDetails` (IN `gId` CHAR(20), IN `gName` VARCHAR(30), IN `gAddress` VARCHAR(200), IN `gEmail` VARCHAR(50), IN `gPhone` CHAR(20), IN `gNo` INT)  NO SQL
INSERT INTO `guest`(`no`, `identity`, `name`, `address`, `email`, `phone`) VALUES (gNo,gId, gName, gAddress, gEmail, gPhone)$$

DROP PROCEDURE IF EXISTS `createRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createRoomDetails` (IN `rId` INT, IN `rType` CHAR(3))  NO SQL
INSERT INTO `room`(`id`, `type`, `status`, `is_deleted`) VALUES (rId, rType, 0, 0)$$

DROP PROCEDURE IF EXISTS `createRoomTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createRoomTypeDetails` (IN `rId` CHAR(3), IN `rType` VARCHAR(20), IN `rDescription` VARCHAR(255), IN `rRate` FLOAT, IN `rImage` VARCHAR(255))  NO SQL
INSERT INTO `room_type`(`id`, `type`, `description`, `rate`, `image`, `is_deleted`) VALUES (rId, rType, rDescription, rRate, rImage, 0)$$

DROP PROCEDURE IF EXISTS `createUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUserDetails` (IN `username` CHAR(6), IN `uName` VARCHAR(30), IN `email` VARCHAR(50), IN `phone` CHAR(20), IN `password` VARCHAR(255))  NO SQL
BEGIN
	INSERT INTO `cashier`(`id`, `name`, `email`, `mobile`, `is_deleted`) VALUES (username, uName, email, phone, 0);
    INSERT INTO `user`(`id`, `password`, `role`, `is_deleted`) VALUES (username, password, 'cashier', 0);
END$$

DROP PROCEDURE IF EXISTS `deleteBookingDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBookingDetails` (IN `bId` INT)  NO SQL
UPDATE `room_book` SET `is_deleted` = 1 WHERE `id` = bId$$

DROP PROCEDURE IF EXISTS `deleteCheckoutDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCheckoutDetails` (IN `rId` INT)  NO SQL
BEGIN
	UPDATE `checkin` SET `is_deleted`= 1 WHERE `room_id` = rId;
	UPDATE `room` SET `status`= 0 WHERE `id` = rId;
END$$

DROP PROCEDURE IF EXISTS `deleteDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDiscountDetails` (IN `dId` INT)  NO SQL
BEGIN
UPDATE `discount` SET `is_deleted`= 1 WHERE `id` = dId;
UPDATE `checkin` SET `discount_id` = 0 WHERE `discount_id` = dId;
END$$

DROP PROCEDURE IF EXISTS `deleteGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGuestDetails` (IN `gId` CHAR(20))  NO SQL
UPDATE `guest` SET `is_deleted`= 1 WHERE `identity` = gId$$

DROP PROCEDURE IF EXISTS `deleteRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoomDetails` (IN `rId` INT)  NO SQL
UPDATE `room` SET `is_deleted`= 1 WHERE `id` = rId$$

DROP PROCEDURE IF EXISTS `deleteRoomTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoomTypeDetails` (IN `rId` CHAR(3))  NO SQL
UPDATE `room_type` SET `is_deleted`= 1 WHERE `id` = rId$$

DROP PROCEDURE IF EXISTS `deleteUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUserDetails` (IN `username` CHAR(6))  BEGIN
	UPDATE `user` SET `is_deleted` = 1 WHERE `id` = username;
	UPDATE `admin` SET `is_deleted` = 1 WHERE `id` = username;
	UPDATE `cashier` SET `is_deleted` = 1 WHERE `id` = username;
END$$

DROP PROCEDURE IF EXISTS `discountDetailsByType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `discountDetailsByType` ()  NO SQL
SELECT * FROM `discount` WHERE `id` != 0 AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `filterTransactionDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterTransactionDetails` (IN `search_key` VARCHAR(30))  NO SQL
SELECT `bill_id` AS 'Bill Id', IF(`type`='R','Room', 'Food') AS 'Type', `date` AS 'Date', `amount` AS 'Amount (Rs.)' FROM `transaction` WHERE `date` LIKE search_key ORDER BY `date` DESC$$

DROP PROCEDURE IF EXISTS `getDiscountIdByType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDiscountIdByType` (IN `dType` VARCHAR(15))  NO SQL
SELECT * FROM `discount` WHERE `type` = dType AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `getRoomTypeId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRoomTypeId` (IN `rType` VARCHAR(20))  NO SQL
SELECT * FROM `room_type` WHERE `type` = rType AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `getTransactionYears`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTransactionYears` ()  NO SQL
SELECT DISTINCT YEAR(`date`) AS 'year' FROM `transaction` ORDER BY `date` ASC$$

DROP PROCEDURE IF EXISTS `lastBillId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastBillId` ()  NO SQL
SELECT `bill_id` AS 'lastBillId' FROM `transaction` ORDER BY `bill_id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastCheckInId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastCheckInId` ()  NO SQL
SELECT * FROM `checkin` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastDiscountId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastDiscountId` ()  NO SQL
SELECT * FROM `discount` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastGuestNo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastGuestNo` ()  NO SQL
SELECT `no` FROM `guest` ORDER BY `no` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastId` ()  NO SQL
SELECT * FROM `cashier` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastRoomId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastRoomId` ()  NO SQL
SELECT * FROM `room` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `lastRoomTypeId`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lastRoomTypeId` ()  NO SQL
SELECT * FROM `room_type` ORDER BY `id` DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `username` CHAR(6))  NO SQL
select * from `user` where `id`=username AND `is_deleted` = 0 LIMIT 1$$

DROP PROCEDURE IF EXISTS `newFoodBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newFoodBill` (IN `foodAmount` FLOAT)  NO SQL
INSERT INTO `transaction`(`type`, `amount`) VALUES ('F', foodAmount)$$

DROP PROCEDURE IF EXISTS `roomDetailsById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `roomDetailsById` ()  NO SQL
SELECT r.`id`, t.`type`, t.`rate` FROM `room` r, `room_type` t WHERE r.`type` = t.`id` AND r.`status` = 0 AND r.`is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `roomIdForFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `roomIdForFood` ()  NO SQL
SELECT `id` FROM `room` WHERE `is_deleted` = 0 AND `status` = 2$$

DROP PROCEDURE IF EXISTS `roomTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `roomTypeDetails` ()  NO SQL
SELECT * FROM `room_type` WHERE `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `sumFoodAmountByGuest`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sumFoodAmountByGuest` (IN `guestId` VARCHAR(20))  NO SQL
SELECT SUM(rf.`amount`) AS 'foodAmount' FROM `room_food` rf, `checkin` c WHERE rf.`is_deleted` = 0 AND rf.`room_id` = c.`room_id` AND c.`is_checkout` = 0 AND c.`is_deleted` = 0 AND c.`guest_id` = guestId$$

DROP PROCEDURE IF EXISTS `sumFoodAmountByRoom`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sumFoodAmountByRoom` (IN `roomId` INT)  NO SQL
BEGIN
SELECT SUM(`amount`) AS 'foodAmount' FROM `room_food` WHERE `room_id` = roomId AND `is_deleted` = 0;
END$$

DROP PROCEDURE IF EXISTS `sumRoomAmountByGuest`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sumRoomAmountByGuest` (IN `guestId` VARCHAR(20))  NO SQL
SELECT rt.`rate` * DATEDIFF(IF(CURRENT_TIMESTAMP()<`checkout_date`,`checkout_date`,CURRENT_TIMESTAMP()),c.`checkin_date`) AS 'roomAmount',d.`rate` AS 'discountRate' FROM `checkin` c, `discount` d, `room` r, `room_type` rt WHERE c.`guest_id` = guestId AND c.`discount_id` = d.`id` AND r.`id` = c.`room_id` AND r.`type` = rt.`id` AND c.`is_checkout` = 0 AND c.`is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `sumRoomAmountByRoom`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sumRoomAmountByRoom` (IN `roomId` INT)  NO SQL
SELECT rt.`rate` * DATEDIFF(IF(CURRENT_TIMESTAMP()<`checkout_date`,`checkout_date`,CURRENT_TIMESTAMP()),c.`checkin_date`) AS 'roomAmount',d.`rate` AS 'discountRate' FROM `checkin` c, `discount` d, `room` r, `room_type` rt WHERE c.`room_id` = roomId AND c.`discount_id` = d.`id` AND r.`id` = c.`room_id` AND r.`type` = rt.`id` AND c.`is_checkout` = 0 AND c.`is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `updateDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDiscountDetails` (IN `dId` INT, IN `dType` VARCHAR(15), IN `dRate` INT(3))  NO SQL
BEGIN
    UPDATE `discount` SET `type`= dType,`rate`= dRate WHERE `id` = dId;
END$$

DROP PROCEDURE IF EXISTS `updateFoodBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFoodBill` (IN `roomId` INT, IN `foodAmount` FLOAT)  NO SQL
INSERT INTO `room_food`(`room_id`, `amount`) VALUES (roomId, foodAmount)$$

DROP PROCEDURE IF EXISTS `updateGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateGuestDetails` (IN `gId` CHAR(12), IN `gName` VARCHAR(50), IN `gAddress` VARCHAR(200), IN `gEmail` VARCHAR(100), IN `gPhone` CHAR(20))  NO SQL
UPDATE `guest` SET `name`= gName, `address`= gAddress, `email`= gEmail, `phone`= gPhone WHERE `identity` = gId$$

DROP PROCEDURE IF EXISTS `updateMessageDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMessageDetails` (IN `mId` TINYINT(1))  NO SQL
UPDATE `customer_message` SET `is_replied`= 1 WHERE `id` = mId$$

DROP PROCEDURE IF EXISTS `updateRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoomDetails` (IN `rId` INT, IN `rType` CHAR(3))  NO SQL
UPDATE `room` SET `type`= rType WHERE `id`= rId$$

DROP PROCEDURE IF EXISTS `updateRoomTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoomTypeDetails` (IN `rId` CHAR(3), IN `rType` VARCHAR(20), IN `rDescription` VARCHAR(255), IN `rRate` FLOAT)  NO SQL
UPDATE `room_type` SET `type` = rType, `description` = rDescription, `rate`= rRate WHERE `id` = rId AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `updateUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserDetails` (IN `username` CHAR(6), IN `uName` VARCHAR(30), IN `email` VARCHAR(50), IN `phone` CHAR(20))  NO SQL
BEGIN
	UPDATE `cashier` SET `name`=uName,`email`=email,`mobile`=phone WHERE `id` = username;
    UPDATE `admin` SET `name`=uName,`email`=email,`mobile`=phone WHERE `id` = username;
END$$

DROP PROCEDURE IF EXISTS `viewBookingDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewBookingDetails` ()  NO SQL
SELECT `id` AS 'Id', `name` AS 'Name', `email` AS 'Email', `phone` AS 'Phone No', `check_in_date` AS 'Check In Date', `no_of_room` AS 'No of Room', `message` AS 'Message' FROM `room_book` WHERE `is_canceled` = 0 AND `is_deleted` = 0 ORDER BY `check_in_date` ASC$$

DROP PROCEDURE IF EXISTS `viewCheckinDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewCheckinDetails` ()  NO SQL
SELECT `guest_id` AS 'Guest Id', `room_id` AS 'Room Id', `checkin_date` AS 'Check In', `checkout_date` AS 'Check Out', IF(`discount_id`=0,'-',`discount_id`) AS 'Discount Id', `advance_payment` AS 'Advance Payment' FROM `checkin` WHERE `is_checkout` = 0 AND `is_deleted` = 0 ORDER BY `checkin_date` DESC$$

DROP PROCEDURE IF EXISTS `viewCheckoutDetailsByGuest`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewCheckoutDetailsByGuest` ()  NO SQL
SELECT  `guest_id` AS 'Guest ID',GROUP_CONCAT(`room_id`) AS 'Room IDs', SUM(`advance_payment`) AS 'Total of Advance Payments' FROM `checkin` WHERE `is_checkout`  = 0 AND `is_deleted` = 0 GROUP BY `guest_id`$$

DROP PROCEDURE IF EXISTS `viewCheckoutDetailsByRoom`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewCheckoutDetailsByRoom` ()  NO SQL
SELECT  `id` AS 'No',`room_id` AS 'Room ID', `guest_id` AS 'Guest ID', `checkin_date` AS 'Checkin Date', `checkout_date` AS 'Checkout Date', `advance_payment` AS 'Advance Payment' FROM `checkin` WHERE `is_checkout`  = 0 AND `is_deleted` = 0 ORDER BY `room_id`$$

DROP PROCEDURE IF EXISTS `viewDiscountDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewDiscountDetails` ()  NO SQL
SELECT `id` AS 'ID', `type` AS 'Discount Type', `rate` AS 'Discount Rate (%)' FROM `discount` WHERE `id` != 0 AND `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `viewGuestDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewGuestDetails` ()  NO SQL
SELECT `identity` AS 'Id', `name` AS 'Name', `address` AS 'Address', `email` AS 'Email', `phone` AS 'Phone' FROM `guest` WHERE `is_deleted` = 0 ORDER BY `id` ASC$$

DROP PROCEDURE IF EXISTS `viewMessageDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewMessageDetails` ()  NO SQL
SELECT `id` AS 'Id',`name` AS 'Name', `email` AS 'Email', `phone` AS 'Phone No', `message` AS 'Message', `received_time` AS 'Received Time', IF(`is_replied` = 0, 'No', 'Yes') AS 'Is Replied' FROM `customer_message` ORDER BY `is_replied` ASC, `received_time` DESC$$

DROP PROCEDURE IF EXISTS `viewRoomDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRoomDetails` ()  NO SQL
SELECT r.`id` AS 'ID', t.`type` AS 'Room Type', IF(r.`status`=0, 'Available', IF(r.`status`=1, 'Booked', 'Occupied')) AS 'Room Status' FROM `room` r, `room_type` t WHERE r.`type` = t.`id` AND r.`is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `viewRoomTypeDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRoomTypeDetails` ()  NO SQL
SELECT `id` AS 'Id', `type` AS 'Room Type', `description` AS 'Description', `rate` AS 'Room Rate ($)' FROM `room_type` WHERE `is_deleted` = 0$$

DROP PROCEDURE IF EXISTS `viewSelfDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewSelfDetails` (IN `username` CHAR(6))  NO SQL
SELECT `id` AS 'Id', `name` AS 'Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `admin` WHERE `is_deleted` = 0 AND `id` = username
UNION
SELECT `id` AS 'Id', `name` AS 'Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `cashier` WHERE `is_deleted` = 0 AND `id` = username$$

DROP PROCEDURE IF EXISTS `viewTransactionDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewTransactionDetails` ()  NO SQL
SELECT `bill_id` AS 'Bill Id', IF(`type`='R','Room', 'Food') AS 'Type', `date` AS 'Date', `amount` AS 'Amount (Rs.)' FROM `transaction` ORDER BY `date` DESC$$

DROP PROCEDURE IF EXISTS `viewUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewUserDetails` ()  NO SQL
SELECT `id` AS 'ID', `name` AS 'Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `admin` WHERE `is_deleted` = 0
UNION
SELECT `id` AS 'ID', `name` AS 'Name', `email` AS 'Email', `mobile` AS 'Phone No' FROM `cashier` WHERE `is_deleted` = 0$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `id` char(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `mobile` char(20) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `email`, `mobile`, `is_deleted`) VALUES
('ADM001', 'Chefguru', 'admin@chefguru.com', '0712345678', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cashier`
--

DROP TABLE IF EXISTS `cashier`;
CREATE TABLE IF NOT EXISTS `cashier` (
  `id` char(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `mobile` char(20) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cashier`
--

INSERT INTO `cashier` (`id`, `name`, `email`, `mobile`, `is_deleted`) VALUES
('CSR001', 'Madushan', 'masha@chefguru.com', '0718925949', 0),
('CSR002', 'Sandaru', 'sandaru@chefguru.com', '0778321006', 0),
('CSR003', 'Karunasena', 'karunasena@chefguru.com', '0748596321', 0);

-- --------------------------------------------------------

--
-- Table structure for table `checkin`
--

DROP TABLE IF EXISTS `checkin`;
CREATE TABLE IF NOT EXISTS `checkin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guest_id` varchar(20) NOT NULL,
  `room_id` int(11) NOT NULL,
  `checkin_date` datetime NOT NULL DEFAULT current_timestamp(),
  `checkout_date` datetime NOT NULL,
  `discount_id` int(11) NOT NULL DEFAULT 0,
  `advance_payment` float NOT NULL,
  `is_checkout` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `checkin`
--

INSERT INTO `checkin` (`id`, `guest_id`, `room_id`, `checkin_date`, `checkout_date`, `discount_id`, `advance_payment`, `is_checkout`, `is_deleted`) VALUES
(1, '980171329V', 3, '2020-05-27 17:01:07', '2020-05-30 00:00:00', 0, 2000, 1, 0),
(2, '654128501V', 7, '2020-05-27 17:02:23', '2020-05-31 00:00:00', 2, 10000, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `customer_message`
--

DROP TABLE IF EXISTS `customer_message`;
CREATE TABLE IF NOT EXISTS `customer_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `message` varchar(500) NOT NULL,
  `received_time` datetime NOT NULL DEFAULT current_timestamp(),
  `is_replied` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_message`
--

INSERT INTO `customer_message` (`id`, `name`, `email`, `phone`, `message`, `received_time`, `is_replied`) VALUES
(9, 'Tester', 'test@test.com', '0774521839', 'What is the difference between a Double room and a Twin room', '2020-05-27 16:59:33', 0),
(10, 'Tester', 'test@test.com', '0774521839', 'What is the difference between a Double room and a Twin room', '2020-05-27 16:59:57', 0);

-- --------------------------------------------------------

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
CREATE TABLE IF NOT EXISTS `discount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(15) NOT NULL,
  `rate` float NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `discount`
--

INSERT INTO `discount` (`id`, `type`, `rate`, `is_deleted`) VALUES
(0, 'do_not_delete', 0, 0),
(1, 'New Year', 3, 0),
(2, 'Holi', 2, 0),
(3, 'Christmas', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
CREATE TABLE IF NOT EXISTS `guest` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `identity` varchar(20) NOT NULL,
  `name` varchar(30) NOT NULL,
  `address` varchar(200) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` char(20) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`no`)
) ENGINE=MyISAM AUTO_INCREMENT=980171333 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`no`, `identity`, `name`, `address`, `email`, `phone`, `is_deleted`) VALUES
(1, '980171329V', 'Madushan', 'Bambaragala, Koththallena, Hatton', 'tg2017233@gmail.com', '0771637551', 0),
(2, '654128501V', 'Test', 'Kamburupitiya, Matara', 'test@test.com', '0524136710', 0);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
CREATE TABLE IF NOT EXISTS `room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(3) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `type`, `status`, `is_deleted`) VALUES
(1, 'T01', 0, 0),
(2, 'T01', 0, 0),
(3, 'T01', 0, 0),
(4, 'T01', 0, 0),
(5, 'T02', 0, 0),
(6, 'T02', 0, 0),
(7, 'T03', 2, 0),
(8, 'T03', 0, 0),
(9, 'T03', 0, 0),
(10, 'T04', 0, 0),
(11, 'T04', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `room_book`
--

DROP TABLE IF EXISTS `room_book`;
CREATE TABLE IF NOT EXISTS `room_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `check_in_date` date NOT NULL,
  `no_of_room` int(11) NOT NULL,
  `message` varchar(500) NOT NULL,
  `is_canceled` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room_book`
--

INSERT INTO `room_book` (`id`, `name`, `email`, `phone`, `check_in_date`, `no_of_room`, `message`, `is_canceled`, `is_deleted`) VALUES
(1, 'Sandun Chamara', 'sandun@gmail.com', '0789645123', '2020-05-30', 1, '2 adult and 1 child', 0, 0),
(2, 'Kawindu', 'kawindu@gmail.com', '0798541749', '2020-05-29', 1, '1 adult', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `room_food`
--

DROP TABLE IF EXISTS `room_food`;
CREATE TABLE IF NOT EXISTS `room_food` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `amount` int(11) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room_food`
--

INSERT INTO `room_food` (`id`, `room_id`, `date`, `amount`, `is_deleted`) VALUES
(5, 7, '2020-05-27 17:04:56', 1433, 0),
(6, 7, '2020-05-27 17:05:13', 2810, 0);

-- --------------------------------------------------------

--
-- Table structure for table `room_type`
--

DROP TABLE IF EXISTS `room_type`;
CREATE TABLE IF NOT EXISTS `room_type` (
  `id` char(3) NOT NULL,
  `type` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `rate` float NOT NULL DEFAULT 0,
  `image` varchar(255) NOT NULL DEFAULT 'room_type_default.jpg',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room_type`
--

INSERT INTO `room_type` (`id`, `type`, `description`, `rate`, `image`, `is_deleted`) VALUES
('T01', 'Single', 'A room with the facility of single bed. It is meant for single occupancy. It has an attached bathroom, a small dressing table, a small bedside table, and a small writing table. Sometimes it has a single chair too.', 1500, 'room_type_default.jpg', 0),
('T02', 'Double', 'A room with the facility of double bed. There are two variants in this type depending upon the size of the bed.', 2500, 'room_type_default.jpg', 0),
('T03', 'Deluxe', 'They are available in Single Deluxe and Double Deluxe variants. Deluxe room is well furnished. Some amenities are attached bathroom, a dressing table, a bedside table, a small writing table, a TV, and a small fridge.', 4500, 'room_type_default.jpg', 0),
('T04', 'Twin Double', 'This room provides two double beds with separate headboards. It is ideal for a family with two children below 12 years.', 6000, 'room_type_default.jpg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
CREATE TABLE IF NOT EXISTS `transaction` (
  `bill_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(1) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `amount` float NOT NULL,
  PRIMARY KEY (`bill_id`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`bill_id`, `type`, `date`, `amount`) VALUES
(34, 'F', '2020-05-27 16:41:04', 6540),
(35, 'R', '2020-05-27 17:01:43', 2000),
(36, 'R', '2020-05-27 17:03:07', 10000),
(37, 'R', '2020-05-27 17:04:16', 2500),
(38, 'F', '2020-05-27 17:05:28', 3600);

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
('CSR001', '123', 'cashier', 0),
('CSR002', '123', 'cashier', 0),
('CSR003', '123', 'cashier', 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
