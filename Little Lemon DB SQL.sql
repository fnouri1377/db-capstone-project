-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `little_lemon_db` DEFAULT CHARACTER SET utf8 ;
USE `little_lemon_db` ;

-- -----------------------------------------------------
-- Table `little_lemon_db`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`Bookings` (
  `booking_id` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NULL,
  `table_number` INT NULL,
  PRIMARY KEY (`booking_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`Customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  `contact_details` VARCHAR(255) NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`Orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NULL,
  `quantity` INT NULL,
  `total_cost` DECIMAL(2) NULL,
  `booking_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_Orders_Bookings_idx` (`booking_id` ASC) VISIBLE,
  INDEX `fk_Orders_Customer_Details1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Bookings`
    FOREIGN KEY (`booking_id`)
    REFERENCES `little_lemon_db`.`Bookings` (`booking_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Customer_Details1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `little_lemon_db`.`Customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`Order_Delivery_Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`Order_Delivery_Status` (
  `status_id` INT NOT NULL AUTO_INCREMENT,
  `delivary_date` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`status_id`),
  INDEX `fk_Order_Delivery_Status_Orders1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Delivery_Status_Orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `little_lemon_db`.`Orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`Menu` (
  `menu_id` INT NOT NULL AUTO_INCREMENT,
  `cuisine` VARCHAR(255) NULL,
  `menu_name` VARCHAR(45) NULL,
  PRIMARY KEY (`menu_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`Staff_Information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`Staff_Information` (
  `staff_id` INT NOT NULL AUTO_INCREMENT,
  `role` VARCHAR(255) NULL,
  `salary` DECIMAL(2) NULL,
  PRIMARY KEY (`staff_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`MenuItems` (
  `MenuItems_id` INT NOT NULL AUTO_INCREMENT,
  `CourseName` VARCHAR(255) NULL,
  `StarterName` VARCHAR(255) NULL,
  `DessertName` VARCHAR(255) NULL,
  `menu_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`MenuItems_id`),
  INDEX `fk_MenuItems_Menu1_idx` (`menu_id` ASC) VISIBLE,
  INDEX `fk_MenuItems_Orders1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_MenuItems_Menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `little_lemon_db`.`Menu` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MenuItems_Orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `little_lemon_db`.`Orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
