CREATE TABLE IF NOT EXISTS `marketplace_items` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) DEFAULT NULL,
    `price` varchar(50) DEFAULT 1,
    `item` varchar(50) DEFAULT NULL,
    `label` varchar(50) DEFAULT NULL,
    `quantity` varchar(50) DEFAULT 1,
    `image` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`)
)