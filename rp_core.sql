CREATE TABLE
    IF NOT EXISTS `rp_core_shops` (
        `id` INT (11) NOT NULL AUTO_INCREMENT,
        `shop` VARCHAR(50) NOT NULL,
        `owner` VARCHAR(255) NOT NULL,
        PRIMARY KEY (`id`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8;