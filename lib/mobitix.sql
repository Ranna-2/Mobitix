-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 10, 2025 at 01:45 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mobitix`
--

-- --------------------------------------------------------

--
-- Table structure for table `buses`
--

CREATE TABLE `buses` (
  `id` int(11) NOT NULL,
  `bus_name` varchar(255) NOT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `route` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buses`
--

INSERT INTO `buses` (`id`, `bus_name`, `departure_time`, `arrival_time`, `route`) VALUES
(1, 'Express Bus 1', '2023-10-01 08:00:00', '2023-10-01 12:00:00', 'Colombo-Kandy'),
(2, 'Luxury Bus 2', '2023-10-01 09:00:00', '2023-10-01 13:00:00', 'Kandy-Jaffna'),
(3, 'AC Bus 3', '2023-10-01 10:00:00', '2023-10-01 14:00:00', 'Colombo-Jaffna'),
(4, 'Express Bus 4', '2025-04-23 18:45:11', '2025-04-22 23:45:11', 'Colombo-Kandy'),
(5, 'Luxury Bus 5', '2025-04-24 18:45:11', '2025-04-24 22:45:11', 'Kandy-Jaffna'),
(6, 'AC Bus 6', '2025-04-25 18:45:11', '2025-04-26 00:45:11', 'Colombo-Jaffna'),
(7, 'Night Bus 7', '2025-04-29 22:00:00', '2025-04-30 06:00:00', 'Colombo-Kandy'),
(8, 'City Bus 1', '2025-04-25 07:00:00', '2025-04-25 11:00:00', 'Colombo-Galle'),
(9, 'City Bus 2', '2025-04-26 08:30:00', '2025-04-26 12:30:00', 'Galle-Colombo'),
(10, 'Express Bus 3', '2025-04-27 09:15:00', '2025-04-27 13:15:00', 'Kandy-Colombo'),
(11, 'Luxury Bus 4', '2025-04-28 10:00:00', '2025-04-28 14:00:00', 'Colombo-Negombo'),
(12, 'AC Bus 5', '2025-04-29 11:30:00', '2025-04-29 15:30:00', 'Kandy-Negombo'),
(13, 'Night Bus 6', '2025-04-30 22:00:00', '2025-05-01 06:00:00', 'Colombo-Jaffna'),
(14, 'City Bus 7', '2025-05-01 06:30:00', '2025-05-01 10:30:00', 'Jaffna-Colombo'),
(15, 'Express Bus 8', '2025-05-02 07:45:00', '2025-05-02 11:45:00', 'Colombo-Matara'),
(16, 'Luxury Bus 9', '2025-05-03 08:00:00', '2025-05-03 12:00:00', 'Matara-Colombo'),
(17, 'AC Bus 10', '2025-05-04 09:00:00', '2025-05-04 13:00:00', 'Kandy-Hambantota'),
(18, 'City Bus 11', '2025-05-05 10:15:00', '2025-05-05 14:15:00', 'Hambantota-Kandy'),
(19, 'Express Bus 12', '2025-05-06 11:30:00', '2025-05-06 15:30:00', 'Colombo-Batticaloa'),
(20, 'Luxury Bus 13', '2025-05-07 12:00:00', '2025-05-07 16:00:00', 'Batticaloa-Colombo'),
(21, 'AC Bus 14', '2025-05-08 13:15:00', '2025-05-08 17:15:00', 'Kandy-Batticaloa'),
(22, 'City Bus 15', '2025-05-09 14:30:00', '2025-05-09 18:30:00', 'Batticaloa-Kandy'),
(23, 'Express Bus 16', '2025-05-10 15:45:00', '2025-05-10 19:45:00', 'Colombo-Anuradhapura'),
(24, 'Luxury Bus 17', '2025-05-11 16:00:00', '2025-05-11 20:00:00', 'Anuradhapura-Colombo'),
(25, 'AC Bus 18', '2025-05-12 17:15:00', '2025-05-12 21:15:00', 'Kandy-Anuradhapura'),
(26, 'City Bus 19', '2025-05-13 18:30:00', '2025-05-13 22:30:00', 'Anuradhapura-Kandy'),
(27, 'Express Bus 20', '2025-05-14 19:45:00', '2025-05-14 23:45:00', 'Colombo-Dambulla'),
(28, 'Express Bus 1', '2025-05-09 18:30:00', '2025-05-09 22:30:00', 'Kandy-Colombo'),
(29, 'Express Bus 1', '2025-05-09 09:00:00', '2025-05-09 01:30:00', 'Kandy-Colombo'),
(30, 'Express Bus 1', '2025-05-10 09:00:00', '2025-05-10 13:30:00', 'Kandy-Colombo'),
(31, 'City Bus 1', '2025-05-10 04:30:00', '2025-05-10 08:30:00', 'Kandy-Colombo'),
(32, 'Night Bus', '2025-05-10 19:00:00', '2025-05-10 11:30:00', 'Kandy-Colombo'),
(33, 'Express Bus 1', '2025-05-10 09:00:00', '2025-05-09 10:00:00', 'Kandy-Matale'),
(34, 'Express Bus 1', '2025-05-09 07:00:00', '2025-05-09 01:30:00', 'Matale-Jaffna'),
(35, 'City Travels', '2025-05-10 14:00:00', '2025-05-10 18:00:00', 'kandy-colombo'),
(36, 'City Travels', '2025-05-11 14:00:00', '2025-05-10 18:00:00', 'kandy-colombo');

-- --------------------------------------------------------

--
-- Table structure for table `bus_locations`
--

CREATE TABLE `bus_locations` (
  `id` int(11) NOT NULL,
  `bus_id` int(11) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bus_locations`
--

INSERT INTO `bus_locations` (`id`, `bus_id`, `latitude`, `longitude`, `updated_at`) VALUES
(1, 7, 7.29008700, 80.63302300, '2025-04-22 21:50:36');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reference_id` varchar(100) NOT NULL,
  `passenger_name` varchar(100) NOT NULL,
  `seats` varchar(255) NOT NULL,
  `boarding_point` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `payment_method`, `amount`, `reference_id`, `passenger_name`, `seats`, `boarding_point`, `destination`, `email`, `mobile`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Koko', 1500.00, 'koko_1745618037960', 'test 1', '10, 9, 23', 'colombo', 'kandy', 'ririmaharoof@gmail.com', '0753565859', 'success', '2025-04-25 21:53:57', '2025-04-25 21:53:57'),
(2, 'eZcash', 1000.00, 'ezcash_1745618113721', 'amaranth ', '10, 9', 'kandy', 'colombo ', 'Farzana.abdeen11@gmail.com', '0775122851', 'failed', '2025-04-25 21:55:15', '2025-04-25 21:55:15'),
(3, 'eZcash', 1000.00, 'ezcash_1745618121676', 'amaranth ', '10, 9', 'kandy', 'colombo ', 'Farzana.abdeen11@gmail.com', '0775122851', 'success', '2025-04-25 21:55:23', '2025-04-25 21:55:23'),
(4, 'eZcash', 4500.00, 'ezcash_1746810920916', 'Farzana, Rina, Ilma', '10, 6, 9', 'Kandy Bus Station', 'Colombo Bus Station', 'Farzanaaabdeen11gmaiil.com', '0766665629', 'success', '2025-05-09 17:15:24', '2025-05-09 17:15:24');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Role` enum('admin','user') NOT NULL DEFAULT 'user',
  `PhoneNo` varchar(20) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `Password` varchar(255) NOT NULL,
  `is_verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `FullName`, `Email`, `Role`, `PhoneNo`, `CreatedAt`, `Password`, `is_verified`) VALUES
(1, 'Saman Perera', 'Samanperera@gmail.com', 'user', '0766665629', '2025-04-24 19:52:39', '$2y$10$6SRXTPRJlOhcBNvanSXNZOzRwRBYeV2ALTrouh4COqJAmNv1Xqikm', 0),
(2, 'Barani Imasha', 'Bimsha@gmail.com', 'user', '0727224451', '2025-04-24 22:25:43', '$2y$10$4cB3m0Wor1HPfi24EXfjouHeD0xjoLaQdmeHCv44asw.tlq8p1ecS', 0),
(3, 'Savindya Rajanayake', 'Savhashini@gmail.com', 'user', '0775123835', '2025-04-24 22:46:39', '$2y$10$pAv2.2a1PlNLGpegzpiebew3/lKJEVySpuRSV7WlON7Cjo0.kUmpK', 0),
(4, 'Ilma Maharoof', 'ilmamaharoof@gmail.com', 'user', '0783343243', '2025-04-24 23:03:13', '$2y$10$y1q/zvnoVr0IfuVWrGwQj.7Y2qom6ROHnabzZhHHit1mJxrrHVFd6', 0),
(5, 'Amaya Raj', 'Amayarah@yahoo.com', 'user', '0714435234', '2025-04-24 23:28:06', '$2y$10$X6J9l2aZ3C4Mh5tNSfX9xu.BBOEpYaYNWUWeD5orshJGE7/rQL952', 1),
(6, 'Amila Nishantha', 'Amila@gmail.com', 'user', '0775665454', '2025-04-24 23:49:15', '$2y$10$vd12EA4WqHc3PF/67wL.nObVnu6sivsRinNhJtEus7oQPFe1pZfde', 1),
(7, 'Himaya', 'Nihari', 'user', '0773351485', '2025-05-09 14:44:13', '$2y$10$ys6RJ7e9dPyfE2Gd1OnwbO7E.p815H0tFthmPSEOqoIq35KJo8aSC', 0),
(8, 'Farzana Abdeen', 'Farzanaabdeen11@gmail.com', 'user', '0775123835', '2025-05-09 16:20:13', '$2y$10$e8r5djbME7lgem1pyW61a.01mtLWWHvApHfTt3B49/TsKxNsdjoi2', 1),
(9, 'Saman perera', 'samanperere@gmail.com', 'user', '0766665629', '2025-05-10 00:16:30', '$2y$10$pfs6nM.S9EYa5kBRQgWtlOLgEqO.YmoB0.ixOUkD8/k0ymEZK8Rpe', 1),
(10, 'Saman Perera', 'Samanperera1@gmail.com', 'user', '0766665629', '2025-05-10 02:38:27', '$2y$10$XxPsvqUkb4/nLcXdPXiSFeEnp0Zgsj5VLNflDeV0ZH1kYZjMf6y3a', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buses`
--
ALTER TABLE `buses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bus_locations`
--
ALTER TABLE `bus_locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bus_id` (`bus_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buses`
--
ALTER TABLE `buses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `bus_locations`
--
ALTER TABLE `bus_locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bus_locations`
--
ALTER TABLE `bus_locations`
  ADD CONSTRAINT `bus_locations_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
