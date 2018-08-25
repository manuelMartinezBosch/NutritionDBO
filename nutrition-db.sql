-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 25, 2018 at 06:23 PM
-- Server version: 10.1.34-MariaDB
-- PHP Version: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nutrition`
--
DROP DATABASE IF EXISTS `nutrition`;
CREATE DATABASE IF NOT EXISTS `nutrition` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `nutrition`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMeals` (IN `userId` INT, IN `mealsDay` DATE)  BEGIN
    SELECT mety.mety_name AS `meal-type`, al.al_id AS `id`, al.al_name AS `name`, meal.quantity AS `quantity`, 
        un.un_name AS `unit`, ROUND((((al.al_hydrates * meal.quantity * alun.grams_per_unit) / 100) * 4) +
        (((al.al_proteins * meal.quantity * alun.grams_per_unit) / 100) * 4) + 
        (((al.al_fat * meal.quantity * alun.grams_per_unit) / 100) * 9)) AS `calories` 
        FROM MEAL_TYPE mety
            INNER JOIN MEAL me ON me.mety_id = mety.mety_id
            INNER JOIN MEAL_ALIMENT meal ON meal.me_id = me.me_id
            INNER JOIN UNIT un ON un.un_id = meal.un_id 
            INNER JOIN ALIMENT al ON al.al_id = meal.al_id
            INNER JOIN ALIMENT_UNIT alun ON alun.al_id = al.al_id AND alun.un_id = meal.un_id
        WHERE me.us_id = userId AND me.me_date = mealsDay
    UNION
    SELECT mety.mety_name AS `meal-type`, re.re_id AS `id`, re.re_name AS `name`, NULL AS `quantity`, NULL AS `unit`, 
        ROUND(SUM((((al.al_hydrates * ral.quantity * alun.grams_per_unit) / 100) * 4) +
        (((al.al_proteins * ral.quantity * alun.grams_per_unit) / 100) * 4) +
        (((al.al_fat * ral.quantity * alun.grams_per_unit) / 100) * 9))) AS `calories`
        FROM MEAL_TYPE mety
            INNER JOIN MEAL me ON me.mety_id = mety.mety_id
            INNER JOIN MEAL_RECIPE mere ON mere.me_id = me.me_id
            INNER JOIN RECIPE re ON re.re_id = mere.re_id
            INNER JOIN RECIPE_ALIMENT ral ON ral.re_id = re.re_id
            INNER JOIN ALIMENT al ON al.al_id = ral.al_id
            INNER JOIN ALIMENT_UNIT alun ON alun.al_id = al.al_id AND alun.un_id = ral.un_id
        WHERE me.us_id = userId AND me.me_date = mealsDay
            GROUP BY re.re_id
    ORDER BY `name` ASC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ALIMENT`
--

CREATE TABLE `ALIMENT` (
  `al_id` int(11) NOT NULL,
  `al_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `al_barcode` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `al_hydrates` decimal(4,1) NOT NULL,
  `al_proteins` decimal(4,1) NOT NULL,
  `al_fat` decimal(4,1) NOT NULL,
  `al_calcium` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ALIMENT`
--

INSERT INTO `ALIMENT` (`al_id`, `al_name`, `al_barcode`, `al_hydrates`, `al_proteins`, `al_fat`, `al_calcium`) VALUES
(1, 'Pechuga de pollo', NULL, '10.2', '13.4', '2.2', 320),
(2, 'Brocoli', NULL, '10.2', '13.4', '2.2', 320),
(3, 'Pavo', NULL, '10.2', '13.4', '2.2', 320),
(4, 'Escarola', NULL, '10.2', '13.4', '2.2', 320),
(5, 'Manzana', NULL, '10.2', '13.4', '2.2', 320);

-- --------------------------------------------------------

--
-- Table structure for table `ALIMENT_UNIT`
--

CREATE TABLE `ALIMENT_UNIT` (
  `al_id` int(11) NOT NULL,
  `un_id` int(11) NOT NULL,
  `grams_per_unit` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ALIMENT_UNIT`
--

INSERT INTO `ALIMENT_UNIT` (`al_id`, `un_id`, `grams_per_unit`) VALUES
(1, 1, 40),
(2, 1, 20),
(2, 2, 150),
(3, 1, 5),
(4, 1, 10);

-- --------------------------------------------------------

--
-- Table structure for table `MEAL`
--

CREATE TABLE `MEAL` (
  `me_id` int(11) NOT NULL,
  `us_id` int(11) NOT NULL,
  `mety_id` int(11) NOT NULL,
  `me_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MEAL`
--

INSERT INTO `MEAL` (`me_id`, `us_id`, `mety_id`, `me_date`) VALUES
(1, 1, 1, '2018-08-24');

-- --------------------------------------------------------

--
-- Table structure for table `MEAL_ALIMENT`
--

CREATE TABLE `MEAL_ALIMENT` (
  `al_id` int(11) NOT NULL,
  `me_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `un_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MEAL_ALIMENT`
--

INSERT INTO `MEAL_ALIMENT` (`al_id`, `me_id`, `quantity`, `un_id`) VALUES
(2, 1, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `MEAL_RECIPE`
--

CREATE TABLE `MEAL_RECIPE` (
  `me_id` int(11) NOT NULL,
  `re_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MEAL_RECIPE`
--

INSERT INTO `MEAL_RECIPE` (`me_id`, `re_id`) VALUES
(1, 1),
(1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `MEAL_TYPE`
--

CREATE TABLE `MEAL_TYPE` (
  `mety_id` int(11) NOT NULL,
  `mety_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MEAL_TYPE`
--

INSERT INTO `MEAL_TYPE` (`mety_id`, `mety_name`) VALUES
(1, 'Desayuno');

-- --------------------------------------------------------

--
-- Table structure for table `RECIPE`
--

CREATE TABLE `RECIPE` (
  `re_id` int(11) NOT NULL,
  `us_id` int(11) NOT NULL,
  `re_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `re_person_quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `RECIPE`
--

INSERT INTO `RECIPE` (`re_id`, `us_id`, `re_name`, `re_person_quantity`) VALUES
(1, 1, 'Verduras con pollo', 4),
(2, 1, 'Verduras con pavo', 2);

-- --------------------------------------------------------

--
-- Table structure for table `RECIPE_ALIMENT`
--

CREATE TABLE `RECIPE_ALIMENT` (
  `al_id` int(11) NOT NULL,
  `re_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `un_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `RECIPE_ALIMENT`
--

INSERT INTO `RECIPE_ALIMENT` (`al_id`, `re_id`, `quantity`, `un_id`) VALUES
(1, 1, 2, 1),
(2, 1, 1, 1),
(3, 2, 2, 1),
(4, 1, 3, 1),
(4, 2, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `UNIT`
--

CREATE TABLE `UNIT` (
  `un_id` int(11) NOT NULL,
  `un_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `UNIT`
--

INSERT INTO `UNIT` (`un_id`, `un_name`) VALUES
(1, 'Loncha'),
(2, 'Unidad');

-- --------------------------------------------------------

--
-- Table structure for table `USER`
--

CREATE TABLE `USER` (
  `us_id` int(11) NOT NULL,
  `us_password` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `us_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `us_mail` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `us_age` int(11) NOT NULL,
  `us_weight` decimal(4,1) NOT NULL,
  `us_height` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`us_id`, `us_password`, `us_name`, `us_mail`, `us_age`, `us_weight`, `us_height`) VALUES
(1, '12345', 'Manuel Martinez', 'manuel@manuel.com', 24, '69.0', 170);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ALIMENT`
--
ALTER TABLE `ALIMENT`
  ADD PRIMARY KEY (`al_id`);

--
-- Indexes for table `ALIMENT_UNIT`
--
ALTER TABLE `ALIMENT_UNIT`
  ADD PRIMARY KEY (`al_id`,`un_id`),
  ADD KEY `un_id` (`un_id`);

--
-- Indexes for table `MEAL`
--
ALTER TABLE `MEAL`
  ADD PRIMARY KEY (`me_id`),
  ADD KEY `us_id` (`us_id`),
  ADD KEY `mety_id` (`mety_id`);

--
-- Indexes for table `MEAL_ALIMENT`
--
ALTER TABLE `MEAL_ALIMENT`
  ADD PRIMARY KEY (`al_id`,`me_id`),
  ADD KEY `me_id` (`me_id`),
  ADD KEY `un_id` (`un_id`);

--
-- Indexes for table `MEAL_RECIPE`
--
ALTER TABLE `MEAL_RECIPE`
  ADD PRIMARY KEY (`me_id`,`re_id`),
  ADD KEY `re_id` (`re_id`);

--
-- Indexes for table `MEAL_TYPE`
--
ALTER TABLE `MEAL_TYPE`
  ADD PRIMARY KEY (`mety_id`);

--
-- Indexes for table `RECIPE`
--
ALTER TABLE `RECIPE`
  ADD PRIMARY KEY (`re_id`),
  ADD KEY `us_id` (`us_id`);

--
-- Indexes for table `RECIPE_ALIMENT`
--
ALTER TABLE `RECIPE_ALIMENT`
  ADD PRIMARY KEY (`al_id`,`re_id`),
  ADD KEY `re_id` (`re_id`),
  ADD KEY `un_id` (`un_id`);

--
-- Indexes for table `UNIT`
--
ALTER TABLE `UNIT`
  ADD PRIMARY KEY (`un_id`);

--
-- Indexes for table `USER`
--
ALTER TABLE `USER`
  ADD PRIMARY KEY (`us_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ALIMENT`
--
ALTER TABLE `ALIMENT`
  MODIFY `al_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `MEAL`
--
ALTER TABLE `MEAL`
  MODIFY `me_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `MEAL_TYPE`
--
ALTER TABLE `MEAL_TYPE`
  MODIFY `mety_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `RECIPE`
--
ALTER TABLE `RECIPE`
  MODIFY `re_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `UNIT`
--
ALTER TABLE `UNIT`
  MODIFY `un_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `USER`
--
ALTER TABLE `USER`
  MODIFY `us_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ALIMENT_UNIT`
--
ALTER TABLE `ALIMENT_UNIT`
  ADD CONSTRAINT `ALIMENT_UNIT_ibfk_1` FOREIGN KEY (`al_id`) REFERENCES `ALIMENT` (`al_id`),
  ADD CONSTRAINT `ALIMENT_UNIT_ibfk_2` FOREIGN KEY (`un_id`) REFERENCES `UNIT` (`un_id`);

--
-- Constraints for table `MEAL`
--
ALTER TABLE `MEAL`
  ADD CONSTRAINT `MEAL_ibfk_1` FOREIGN KEY (`us_id`) REFERENCES `USER` (`us_id`),
  ADD CONSTRAINT `MEAL_ibfk_2` FOREIGN KEY (`mety_id`) REFERENCES `MEAL_TYPE` (`mety_id`);

--
-- Constraints for table `MEAL_ALIMENT`
--
ALTER TABLE `MEAL_ALIMENT`
  ADD CONSTRAINT `MEAL_ALIMENT_ibfk_1` FOREIGN KEY (`al_id`) REFERENCES `ALIMENT` (`al_id`),
  ADD CONSTRAINT `MEAL_ALIMENT_ibfk_2` FOREIGN KEY (`me_id`) REFERENCES `MEAL` (`me_id`),
  ADD CONSTRAINT `MEAL_ALIMENT_ibfk_3` FOREIGN KEY (`un_id`) REFERENCES `UNIT` (`un_id`);

--
-- Constraints for table `MEAL_RECIPE`
--
ALTER TABLE `MEAL_RECIPE`
  ADD CONSTRAINT `MEAL_RECIPE_ibfk_1` FOREIGN KEY (`me_id`) REFERENCES `MEAL` (`me_id`),
  ADD CONSTRAINT `MEAL_RECIPE_ibfk_2` FOREIGN KEY (`re_id`) REFERENCES `RECIPE` (`re_id`);

--
-- Constraints for table `RECIPE`
--
ALTER TABLE `RECIPE`
  ADD CONSTRAINT `RECIPE_ibfk_1` FOREIGN KEY (`us_id`) REFERENCES `USER` (`us_id`);

--
-- Constraints for table `RECIPE_ALIMENT`
--
ALTER TABLE `RECIPE_ALIMENT`
  ADD CONSTRAINT `RECIPE_ALIMENT_ibfk_1` FOREIGN KEY (`al_id`) REFERENCES `ALIMENT` (`al_id`),
  ADD CONSTRAINT `RECIPE_ALIMENT_ibfk_2` FOREIGN KEY (`re_id`) REFERENCES `RECIPE` (`re_id`),
  ADD CONSTRAINT `RECIPE_ALIMENT_ibfk_3` FOREIGN KEY (`un_id`) REFERENCES `UNIT` (`un_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
