CREATE TABLE IF NOT EXISTS `gs_trucker_profiles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(100) NOT NULL UNIQUE,
  `profile_name` VARCHAR(100) NOT NULL,
  `profile_picture` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `gs_trucker_posts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `author_identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
  `post_type` ENUM('LOOKING_FOR_JOB','HIRING','GIG_OFFER') NOT NULL COLLATE 'utf8mb4_general_ci',
  `title` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
  `content` TEXT NOT NULL COLLATE 'utf8mb4_general_ci',
  `company_id` INT(11) NULL DEFAULT NULL,
  `gig_payment` INT(11) NULL DEFAULT NULL,
  `gig_taker_identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
  `status` ENUM('OPEN','CLOSED') NOT NULL DEFAULT 'OPEN' COLLATE 'utf8mb4_general_ci',
  `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_identifier` (`author_identifier`) USING BTREE,
  INDEX `company_id` (`company_id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

CREATE TABLE `gs_trucker_applications` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_id` INT(11) NOT NULL,
  `post_id` INT(11) NOT NULL,
  `applicant_identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
  `applicant_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
  `status` ENUM('PENDING','ACCEPTED','REJECTED') NOT NULL DEFAULT 'PENDING' COLLATE 'utf8mb4_general_ci',
  `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `company_id` (`company_id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

ALTER TABLE `gs_trucker_employees`
ADD COLUMN `role` VARCHAR(50) NOT NULL DEFAULT 'worker' AFTER `name`;

CREATE TABLE `gs_trucker_chats` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `post_id` INT(11) NOT NULL,
  `poster_identifier` VARCHAR(50) NOT NULL,
  `accepter_identifier` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `post_id` (`post_id`)
) ENGINE=InnoDB;
CREATE TABLE `gs_trucker_chat_messages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `chat_id` INT(11) NOT NULL,
  `author_identifier` VARCHAR(50) NOT NULL,
  `message` TEXT NOT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  INDEX `chat_id` (`chat_id`)
) ENGINE=InnoDB;
ALTER TABLE `gs_trucker_companies`
ADD COLUMN `permissions` TEXT DEFAULT '{}';

ALTER TABLE `gs_trucker_companies`
ADD COLUMN `salary_payment_enabled` BOOLEAN NOT NULL DEFAULT 0;

-- Adiciona a coluna para a localização da garagem na tabela de empresas
ALTER TABLE `gs_trucker_companies`
ADD COLUMN `garage_location` TEXT DEFAULT NULL;

-- Apaga a tabela de frota antiga, se existir, para ser recriada com a nova estrutura
DROP TABLE IF EXISTS `gs_trucker_fleet`;

-- Cria a nova tabela de frota com todos os campos necessários
CREATE TABLE IF NOT EXISTS `gs_trucker_fleet` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `company_id` INT NOT NULL,
  `plate` VARCHAR(10) NOT NULL UNIQUE,
  `model` VARCHAR(50) NOT NULL,
  `damage` TEXT DEFAULT '{}',
  `status` VARCHAR(50) NOT NULL DEFAULT 'Na Garagem',
  `last_driver` VARCHAR(100) DEFAULT NULL,
  FOREIGN KEY (`company_id`) REFERENCES `gs_trucker_companies`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Cria a tabela para o log de utilização dos veículos
CREATE TABLE IF NOT EXISTS `gs_trucker_fleet_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `fleet_id` INT NOT NULL,
  `company_id` INT NOT NULL,
  `player_name` VARCHAR(100) NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`fleet_id`) REFERENCES `gs_trucker_fleet`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
ALTER TABLE `gs_trucker_fleet` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `gs_trucker_company_industries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `purchase_price` int(11) NOT NULL,
  `purchase_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `industry_name` (`industry_name`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `gs_trucker_industry_management` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `industry_name` varchar(50) NOT NULL,
  `investment_level` int(11) NOT NULL DEFAULT 1,
  `npc_workers` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_industry` (`company_id`,`industry_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `gs_trucker_company_industries`
ADD COLUMN `investment_level` INT(11) NOT NULL DEFAULT 0,
ADD COLUMN `npc_workers` INT(11) NOT NULL DEFAULT 0;

CREATE TABLE `gs_trucker_industry_stock` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company_id` INT(11) NOT NULL,
  `industry_name` VARCHAR(50) NOT NULL,
  `item_name` VARCHAR(50) NOT NULL,
  `stock` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_stock_item` (`company_id`,`industry_name`,`item_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE gs_trucker_employees
ADD COLUMN salary INT DEFAULT 0;

ALTER TABLE `gs_trucker_fleet` ADD COLUMN `rent_expires_at` DATETIME NULL DEFAULT NULL;