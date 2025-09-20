CREATE TABLE IF NOT EXISTS `gs_trucker_skills` (
  `citizenId` varchar(50) NOT NULL,
  `totalProfit` decimal(20,6) DEFAULT NULL,
  `totalPackage` int(11) DEFAULT NULL,
  `totalDistance` decimal(20,6) DEFAULT NULL,
  `exp` decimal(20,6) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`citizenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;