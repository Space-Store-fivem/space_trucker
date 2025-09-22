-- =====================================
-- Space Trucker Database - Consolidated
-- =====================================

-- Profiles
CREATE TABLE IF NOT EXISTS `Space_trucker_profiles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(100) NOT NULL UNIQUE,
  `profile_name` VARCHAR(100) NOT NULL,
  `profile_picture` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Posts
CREATE TABLE IF NOT EXISTS `Space_trucker_posts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `author_identifier` VARCHAR(50) NOT NULL,
  `post_type` ENUM('LOOKING_FOR_JOB','HIRING','GIG_OFFER') NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `content` TEXT NOT NULL,
  `company_id` INT(11) DEFAULT NULL,
  `gig_payment` INT(11) DEFAULT NULL,
  `gig_taker_identifier` VARCHAR(50) DEFAULT NULL,
  `status` ENUM('OPEN','CLOSED') NOT NULL DEFAULT 'OPEN',
  `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  INDEX `author_identifier` (`author_identifier`),
  INDEX `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Applications
CREATE TABLE IF NOT EXISTS `Space_trucker_applications` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_id` INT(11) NOT NULL,
  `post_id` INT(11) NOT NULL,
  `applicant_identifier` VARCHAR(50) NOT NULL,
  `applicant_name` VARCHAR(255) NOT NULL,
  `status` ENUM('PENDING','ACCEPTED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  INDEX `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Employees
CREATE TABLE IF NOT EXISTS `Space_trucker_employees` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_id` INT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `role` VARCHAR(50) NOT NULL DEFAULT 'worker',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Chats
CREATE TABLE IF NOT EXISTS `Space_trucker_chats` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `post_id` INT(11) NOT NULL,
  `poster_identifier` VARCHAR(50) NOT NULL,
  `accepter_identifier` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `post_id` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Space_trucker_chat_messages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `chat_id` INT(11) NOT NULL,
  `author_identifier` VARCHAR(50) NOT NULL,
  `message` TEXT NOT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  INDEX `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Companies
CREATE TABLE IF NOT EXISTS `Space_trucker_companies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `permissions` TEXT DEFAULT '{}',
  `salary_payment_enabled` BOOLEAN NOT NULL DEFAULT 0,
  `garage_location` TEXT DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fleet
DROP TABLE IF EXISTS `Space_trucker_fleet`;
CREATE TABLE IF NOT EXISTS `Space_trucker_fleet` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `company_id` INT NOT NULL,
  `plate` VARCHAR(10) NOT NULL UNIQUE,
  `model` VARCHAR(50) NOT NULL,
  `damage` TEXT DEFAULT '{}',
  `status` VARCHAR(50) NOT NULL DEFAULT 'Na Garagem',
  `last_driver` VARCHAR(100) DEFAULT NULL,
  FOREIGN KEY (`company_id`) REFERENCES `Space_trucker_companies`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `Space_trucker_fleet_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `fleet_id` INT NOT NULL,
  `company_id` INT NOT NULL,
  `player_name` VARCHAR(100) NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`fleet_id`) REFERENCES `Space_trucker_fleet`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Company Industries
CREATE TABLE IF NOT EXISTS `Space_trucker_company_industries` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_id` INT(11) NOT NULL,
  `industry_name` VARCHAR(50) NOT NULL,
  `purchase_price` INT(11) NOT NULL,
  `purchase_timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `industry_name` (`industry_name`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Industry Management
CREATE TABLE IF NOT EXISTS `Space_trucker_industry_management` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_id` INT(11) NOT NULL,
  `industry_name` VARCHAR(50) NOT NULL,
  `investment_level` INT(11) NOT NULL DEFAULT 1,
  `npc_workers` INT(11) NOT NULL DEFAULT 0,
  `last_updated` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_industry` (`company_id`,`industry_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Skills
CREATE TABLE IF NOT EXISTS `Space_trucker_skills` (
  `citizenId` VARCHAR(50) NOT NULL,
  `totalProfit` DECIMAL(20,6) DEFAULT NULL,
  `totalPackage` INT(11) DEFAULT NULL,
  `totalDistance` DECIMAL(20,6) DEFAULT NULL,
  `exp` DECIMAL(20,6) DEFAULT NULL,
  `level` INT(11) DEFAULT NULL,
  PRIMARY KEY (`citizenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Tabela para registar quais empresas são donas de quais indústrias
CREATE TABLE `space_trucker_company_industries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `purchase_price` int(11) NOT NULL,
  `purchase_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `industry_name` (`industry_name`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela para guardar os dados de gestão (investimento, NPCs) de cada indústria possuída
CREATE TABLE `space_trucker_industry_management` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `investment_level` int(11) NOT NULL DEFAULT 1,
  `npc_workers` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_industry` (`company_id`,`industry_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
