CREATE TABLE IF NOT EXISTS `fast_ffa_pistolzone` (
  `playername` varchar(50) DEFAULT NULL,
  `citizenid` text DEFAULT NULL,
  `kill` int(11) DEFAULT 0,
  `death` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `fast_ffa_riflezone` (
  `playername` varchar(50) DEFAULT NULL,
  `citizenid` text DEFAULT NULL,
  `kill` int(11) DEFAULT 0,
  `death` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `fast_ffa_smgzone` (
  `playername` varchar(50) DEFAULT NULL,
  `citizenid` text DEFAULT NULL,
  `kill` int(11) DEFAULT 0,
  `death` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;