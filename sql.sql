
CREATE TABLE IF NOT EXISTS `space_trucker_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `applicant_identifier` varchar(50) NOT NULL,
  `applicant_name` varchar(255) NOT NULL,
  `status` enum('PENDING','ACCEPTED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `poster_identifier` varchar(50) NOT NULL,
  `accepter_identifier` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `post_id` (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_chat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `author_identifier` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `owner_identifier` varchar(100) NOT NULL,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `logo_url` text DEFAULT 'https://i.imgur.com/7nLz43G.png',
  `level` int(11) NOT NULL DEFAULT 1,
  `reputation` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `permissions` text DEFAULT '{}',
  `salary_payment_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `garage_location` text DEFAULT NULL,
  `is_npc` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `owner_identifier` (`owner_identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_company_industries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `purchase_price` int(11) NOT NULL,
  `purchase_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `investment_level` int(11) NOT NULL DEFAULT 0,
  `npc_workers` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `industry_name` (`industry_name`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'worker',
  `is_npc` tinyint(1) NOT NULL DEFAULT 0,
  `rank` varchar(50) NOT NULL DEFAULT 'Motorista',
  `hired_at` timestamp NULL DEFAULT current_timestamp(),
  `salary` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `space_trucker_employees_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `space_trucker_companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_fleet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `plate` varchar(10) NOT NULL,
  `model` varchar(50) NOT NULL,
  `damage` text DEFAULT '{}',
  `status` varchar(50) NOT NULL DEFAULT 'Na Garagem',
  `last_driver` varchar(100) DEFAULT NULL,
  `rent_expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `space_trucker_fleet_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `space_trucker_companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_fleet_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fleet_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `player_name` varchar(100) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fleet_id` (`fleet_id`),
  CONSTRAINT `space_trucker_fleet_logs_ibfk_1` FOREIGN KEY (`fleet_id`) REFERENCES `space_trucker_fleet` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_industry_management` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `investment_level` int(11) NOT NULL DEFAULT 1,
  `npc_workers` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_industry` (`company_id`,`industry_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_industry_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_stock_item` (`company_id`,`industry_name`,`item_name`)
) ENGINE=InnoDB AUTO_INCREMENT=14988 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_logistics_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_identifier` varchar(100) NOT NULL,
  `creator_name` varchar(255) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_label` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `reward` int(11) NOT NULL DEFAULT 0,
  `cargo_value` int(11) NOT NULL DEFAULT 0,
  `pickup_industry_name` varchar(100) NOT NULL,
  `pickup_location` text NOT NULL,
  `dropoff_location` text NOT NULL,
  `dropoff_details` varchar(255) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'OPEN',
  `taker_identifier` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1667 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_identifier` varchar(50) NOT NULL,
  `post_type` enum('LOOKING_FOR_JOB','HIRING','GIG_OFFER') NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `gig_payment` int(11) DEFAULT NULL,
  `gig_taker_identifier` varchar(50) DEFAULT NULL,
  `status` enum('OPEN','CLOSED') NOT NULL DEFAULT 'OPEN',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `author_identifier` (`author_identifier`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(100) NOT NULL,
  `profile_name` varchar(100) NOT NULL,
  `profile_picture` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_skills` (
  `citizenId` varchar(50) NOT NULL,
  `totalProfit` decimal(20,6) DEFAULT NULL,
  `totalPackage` int(11) DEFAULT NULL,
  `totalDistance` decimal(20,6) DEFAULT NULL,
  `exp` decimal(20,6) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`citizenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `space_trucker_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `description` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `space_trucker_transactions_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `space_trucker_companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=757 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `space_trucker_player_stats` (
  `identifier` varchar(50) NOT NULL,
  `total_profit` bigint(20) NOT NULL DEFAULT 0,
  `total_distance` float NOT NULL DEFAULT 0,
  `total_packages` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
);

CREATE TABLE IF NOT EXISTS `space_trucker_mission_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `mission_id` varchar(50) NOT NULL,
  `source_industry` varchar(50) NOT NULL,
  `destination_business` varchar(50) NOT NULL,
  `item` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL,
  `profit` int(11) NOT NULL,
  `distance` float NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);
ALTER TABLE `space_trucker_logistics_orders`
ADD COLUMN `source_industry_name` VARCHAR(100) NULL DEFAULT NULL AFTER `dropoff_location`,
ADD COLUMN `destination_industry_name` VARCHAR(100) NULL DEFAULT NULL AFTER `source_industry_name`;


INSERT INTO `space_trucker_companies` (`id`, `name`, `owner_identifier`, `balance`, `logo_url`, `level`, `reputation`, `created_at`, `permissions`, `salary_payment_enabled`, `garage_location`, `is_npc`) VALUES (6, 'Sistema', 'npc_system', 999999999, 'https://i.imgur.com/7nLz43G.png', 1, 0, '2025-09-30 14:31:02', '{}', 0, NULL, 1);
