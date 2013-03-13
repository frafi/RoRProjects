SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `EPRA` ;
CREATE SCHEMA IF NOT EXISTS `EPRA` ;
USE `EPRA` ;

-- -----------------------------------------------------
-- Table `EPRA`.`AGGREGATION_METHOD`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`AGGREGATION_METHOD` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`AGGREGATION_METHOD` (
  `aggreg_method` VARCHAR(255) NOT NULL ,
  `aggreg_name` VARCHAR(50) NULL ,
  `aggreg_description` VARCHAR(255) NULL ,
  PRIMARY KEY (`aggreg_method`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`CORRELATION_MATRIX`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`CORRELATION_MATRIX` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`CORRELATION_MATRIX` (
  `corr_matrix_id` INT NOT NULL AUTO_INCREMENT ,
  `corr_group` VARCHAR(12) NULL ,
  `corr_code1` VARCHAR(10) NULL ,
  `corr_code2` VARCHAR(10) NULL ,
  `corr_type` INT NULL ,
  `id1_name` VARCHAR(50) NULL ,
  `id2_name` VARCHAR(50) NULL ,
  `correlation` DECIMAL(5,4) NULL ,
  PRIMARY KEY (`corr_matrix_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`CORRELATION_TYPE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`CORRELATION_TYPE` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`CORRELATION_TYPE` (
  `corr_type_id` INT NOT NULL AUTO_INCREMENT ,
  `corr_type` INT NULL ,
  `corr_type_description` VARCHAR(255) NULL ,
  PRIMARY KEY (`corr_type_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`REF_VIEW_TYPE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`REF_VIEW_TYPE` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`REF_VIEW_TYPE` (
  `view_type` VARCHAR(12) NOT NULL ,
  `view_type_name` VARCHAR(50) NULL ,
  `view_type_description` LONGTEXT NULL ,
  PRIMARY KEY (`view_type`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`ORG_VIEW`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`ORG_VIEW` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`ORG_VIEW` (
  `view_id` VARCHAR(12) NOT NULL ,
  `view_name` VARCHAR(60) NULL ,
  `view_descr` VARCHAR(255) NULL ,
  `view_order` INT NULL ,
  `view_turnover_ccy` INT NULL ,
  `view_assets` INT NULL ,
  `view_assets_ccy` VARCHAR(3) NULL ,
  `view_date` DATETIME NULL ,
  `corr_group` INT NULL ,
  `view_size` DECIMAL(5,2) NULL ,
  `view_size_ccy` VARCHAR(3) NULL ,
  `view_label` VARCHAR(5) NULL ,
  `view_type` VARCHAR(12) NOT NULL ,
  PRIMARY KEY (`view_id`, `view_type`) ,
  INDEX `fk_ORG_VIEW_REF_VIEW_TYPE1` (`view_type` ASC) ,
  CONSTRAINT `fk_ORG_VIEW_REF_VIEW_TYPE1`
    FOREIGN KEY (`view_type` )
    REFERENCES `EPRA`.`REF_VIEW_TYPE` (`view_type` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`EVCINDEX`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`EVCINDEX` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`EVCINDEX` (
  `evc_index_id` VARCHAR(12) NOT NULL ,
  `index_name` VARCHAR(100) NULL ,
  `index_date` DATETIME NULL ,
  `index_owner` VARCHAR(70) NULL ,
  `index_thres_lower` DECIMAL(7,4) NULL ,
  `index_thres_upper` DECIMAL(7,4) NULL ,
  `index_threshold1` DECIMAL(7,4) NULL ,
  `index_threshold2` DECIMAL(7,4) NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  PRIMARY KEY (`evc_index_id`, `view_id`) ,
  INDEX `fk_EVCINDEX_ORG_VIEW1` (`view_id` ASC, `evc_index_id` ASC) ,
  CONSTRAINT `fk_EVCINDEX_ORG_VIEW1`
    FOREIGN KEY (`view_id` , `evc_index_id` )
    REFERENCES `EPRA`.`ORG_VIEW` (`view_id` , `view_id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`DIMENSION`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`DIMENSION` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`DIMENSION` (
  `dimension_id` VARCHAR(12) NOT NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  `dimension_type` INT NULL ,
  `corr_code` VARCHAR(2) NULL ,
  `dimension_name` VARCHAR(50) NULL ,
  `dimension_description` VARCHAR(255) NULL ,
  `dimension_owner` VARCHAR(70) NULL ,
  `dim_thres_lower` DECIMAL(7,4) NULL ,
  `dim_thres_upper` DECIMAL(7,4) NULL ,
  `dimension_weight` DECIMAL(7,4) NULL ,
  `dimension_threshold1` DECIMAL(7,4) NULL ,
  `dimension_threshold2` DECIMAL(7,4) NULL ,
  `aggreg_method` VARCHAR(255) NOT NULL ,
  `evc_index_id` VARCHAR(12) NOT NULL ,
  PRIMARY KEY (`dimension_id`, `view_id`) ,
  INDEX `fk_DIMENSION_AGGREGATION_METHOD` (`aggreg_method` ASC) ,
  INDEX `fk_DIMENSION_EVCINDEX1` (`evc_index_id` ASC) ,
  CONSTRAINT `fk_DIMENSION_AGGREGATION_METHOD`
    FOREIGN KEY (`aggreg_method` )
    REFERENCES `EPRA`.`AGGREGATION_METHOD` (`aggreg_method` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DIMENSION_EVCINDEX1`
    FOREIGN KEY (`evc_index_id` )
    REFERENCES `EPRA`.`EVCINDEX` (`evc_index_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`PERIOD`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`PERIOD` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`PERIOD` (
  `period_id` VARCHAR(12) NOT NULL ,
  `period_nr` INT NULL ,
  `period_name` VARCHAR(50) NULL ,
  `period_date` DATETIME NULL ,
  PRIMARY KEY (`period_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`STAT_SECTOR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`STAT_SECTOR` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`STAT_SECTOR` (
  `sector_id` VARCHAR(12) NOT NULL ,
  `secctor_code` VARCHAR(20) NULL ,
  `sector_name` VARCHAR(255) NULL ,
  PRIMARY KEY (`sector_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`STAT_COUNTRY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`STAT_COUNTRY` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`STAT_COUNTRY` (
  `country_id` VARCHAR(12) NOT NULL ,
  `country_code` VARCHAR(3) NULL ,
  `country_name` VARCHAR(255) NULL ,
  `region` VARCHAR(255) NULL ,
  PRIMARY KEY (`country_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`ORGANISATION`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`ORGANISATION` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`ORGANISATION` (
  `organisation_id` VARCHAR(12) NOT NULL ,
  `parent_organisation` VARCHAR(12) NULL ,
  `organisation_order` VARCHAR(2) NULL ,
  `organisation_name` VARCHAR(50) NULL ,
  `oragnisation_desc` VARCHAR(255) NULL ,
  `organisation_type` VARCHAR(2) NULL ,
  `organisation_status` VARCHAR(12) NULL ,
  PRIMARY KEY (`organisation_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`REL_VIEW_ORG`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`REL_VIEW_ORG` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`REL_VIEW_ORG` (
  `organisation_id` VARCHAR(12) NOT NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  INDEX `fk_REL_VIEW_ORG_ORGANISATION1` (`organisation_id` ASC) ,
  PRIMARY KEY (`organisation_id`, `view_id`) ,
  INDEX `fk_REL_VIEW_ORG_ORG_VIEW1` (`view_id` ASC) ,
  CONSTRAINT `fk_REL_VIEW_ORG_ORGANISATION1`
    FOREIGN KEY (`organisation_id` )
    REFERENCES `EPRA`.`ORGANISATION` (`organisation_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REL_VIEW_ORG_ORG_VIEW1`
    FOREIGN KEY (`view_id` )
    REFERENCES `EPRA`.`ORG_VIEW` (`view_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`DIMENSION_VALUE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`DIMENSION_VALUE` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`DIMENSION_VALUE` (
  `dimension_id` VARCHAR(12) NOT NULL ,
  `period_id` VARCHAR(12) NOT NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  `dimension_value` DECIMAL(7,4) NULL ,
  `dimension_status` VARCHAR(20) NULL ,
  `dimension_comments` VARCHAR(2000) NULL ,
  `dimension_dist_to_target` DECIMAL(7,4) NULL ,
  `dimension_change` DECIMAL(7,4) NULL ,
  `dimension_trend_status` INT NULL ,
  `dimension_trend_colour` VARCHAR(10) NULL ,
  PRIMARY KEY (`dimension_id`, `period_id`, `view_id`) ,
  INDEX `fk_DIMENSION_VALUE_PERIOD1` (`period_id` ASC) ,
  CONSTRAINT `fk_DIMENSION_VALUE_DIMENSION1`
    FOREIGN KEY (`dimension_id` , `view_id` )
    REFERENCES `EPRA`.`DIMENSION` (`dimension_id` , `dimension_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DIMENSION_VALUE_PERIOD1`
    FOREIGN KEY (`period_id` )
    REFERENCES `EPRA`.`PERIOD` (`period_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`INDICATOR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`INDICATOR` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`INDICATOR` (
  `indicator_id` VARCHAR(12) NOT NULL ,
  `indicator_type` INT NULL ,
  `corr_code` VARCHAR(5) NULL ,
  `indicator_name` VARCHAR(50) NULL ,
  `indicator_description` VARCHAR(2000) NULL ,
  `indicator_owner` VARCHAR(70) NULL ,
  `indicator_unit` VARCHAR(10) NULL ,
  `indic_thresh_lower` DECIMAL(7,4) NULL ,
  `indic_thresh_upper` DECIMAL(7,4) NULL ,
  `indicator_weight` DECIMAL(7,4) NULL ,
  `indic_threshold1` DECIMAL(7,4) NULL ,
  `indic_threshold2` DECIMAL(7,4) NULL ,
  `dimension_id` VARCHAR(12) NOT NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  `aggreg_method` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`indicator_id`, `view_id`) ,
  INDEX `fk_INDICATOR_DIMENSION1` (`dimension_id` ASC, `view_id` ASC) ,
  INDEX `fk_INDICATOR_AGGREGATION_METHOD1` (`aggreg_method` ASC) ,
  CONSTRAINT `fk_INDICATOR_DIMENSION1`
    FOREIGN KEY (`dimension_id` , `view_id` )
    REFERENCES `EPRA`.`DIMENSION` (`dimension_id` , `view_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_INDICATOR_AGGREGATION_METHOD1`
    FOREIGN KEY (`aggreg_method` )
    REFERENCES `EPRA`.`AGGREGATION_METHOD` (`aggreg_method` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`EVCI_VALUE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`EVCI_VALUE` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`EVCI_VALUE` (
  `period_id` VARCHAR(12) NOT NULL ,
  `index_value` DECIMAL(7,4) NULL ,
  `index_status` VARCHAR(20) NULL ,
  `index_comments` VARCHAR(2000) NULL ,
  `evci_dist_to_target` DECIMAL(7,4) NULL ,
  `index_change` DECIMAL(7,4) NULL ,
  `index_trend_status` INT NULL ,
  `index_trend_colour` VARCHAR(10) NULL ,
  `evc_index_id` VARCHAR(12) NOT NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  PRIMARY KEY (`period_id`, `evc_index_id`, `view_id`) ,
  INDEX `fk_EVCI_VALUE_EVCINDEX1` (`evc_index_id` ASC, `view_id` ASC) ,
  CONSTRAINT `fk_EVCI_VALUE_PERIOD1`
    FOREIGN KEY (`period_id` )
    REFERENCES `EPRA`.`PERIOD` (`period_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EVCI_VALUE_EVCINDEX1`
    FOREIGN KEY (`evc_index_id` , `view_id` )
    REFERENCES `EPRA`.`EVCINDEX` (`evc_index_id` , `view_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`INDICATOR_VALUE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`INDICATOR_VALUE` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`INDICATOR_VALUE` (
  `indicator_value` DECIMAL(7,4) NULL ,
  `indicator_status` VARCHAR(20) NULL ,
  `indicator_comments` VARCHAR(2000) NULL ,
  `indicator_dist_to_target` DECIMAL(7,4) NULL ,
  `indicator_change` DECIMAL(7,4) NULL ,
  `indicator_trend_status` INT NULL ,
  `indicator_trend_colour` VARCHAR(10) NULL ,
  `indicator_id` VARCHAR(12) NOT NULL ,
  `view_id` VARCHAR(12) NOT NULL ,
  `period_id` VARCHAR(12) NOT NULL ,
  PRIMARY KEY (`indicator_id`, `period_id`) ,
  INDEX `fk_INDICATOR_VALUE_PERIOD1` (`period_id` ASC) ,
  CONSTRAINT `fk_INDICATOR_VALUE_INDICATOR1`
    FOREIGN KEY (`indicator_id` , `view_id` )
    REFERENCES `EPRA`.`INDICATOR` (`indicator_id` , `view_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_INDICATOR_VALUE_PERIOD1`
    FOREIGN KEY (`period_id` )
    REFERENCES `EPRA`.`PERIOD` (`period_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`ENTRY_LOG`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`ENTRY_LOG` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`ENTRY_LOG` (
  `entry_id` VARCHAR(12) NOT NULL ,
  `entry_date` DATETIME NULL ,
  `entry_log_code` VARCHAR(4) NULL ,
  `entry_user` VARCHAR(70) NULL ,
  PRIMARY KEY (`entry_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EPRA`.`METRIC`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`METRIC` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`METRIC` (
	`metric_id` VARCHAR(12) NOT NULL,
	`view_id` VARCHAR(12) NOT NULL,
	`indicator_id` VARCHAR(12) NOT NULL,
	`aggreg_method` VARCHAR(255) NULL,
	`calc_method` VARCHAR(max) NULL,
	`metric_type` INT NULL,
	`metric_label` VARCHAR(22) NULL,
	`metric_name` VARCHAR(50) NULL,
	`corr_code` VARCHAR(10) NULL,
	`metric_group` VARCHAR(4) NULL,
	`metric_desc` VARCHAR(max) NULL,
	`metric_owner` VARCHAR(70) NULL,
	`Specific` BIT NULL,
	`Specific_comment` VARCHAR(2000) NULL,
	`Measurable` BIT NULL,
	`Measurable_comment` VARCHAR(2000) NULL,
	`Actionable` BIT NULL,
	`Actionable_comment` VARCHAR(2000) NULL,
	`Relevant` BIT NULL,
	`Relevant_comment` VARCHAR(max) NULL,
	`Timely` BIT NULL,
	`Timely_comment` VARCHAR(2000) NULL,
	`metric_thres_green` NUMERIC(7, 4) NULL,
	`metric_thres_amber` NUMERIC(7, 4) NULL
	`metric_thres_red` NUMERIC(7, 4) NULL,
	`metric_thres_darkred` NUMERIC(7, 4) NULL,
	`trend_threshold1` NUMERIC(7, 4) NULL,
	`trend_threshold2` NUMERIC(7, 4) NULL,
	`metric_thres_comment` VARCHAR(2000) NULL,
	`metric_weight` NUMERIC(7, 4) NULL,
	`metric_weight_comment` VARCHAR(2000) NULL,
	`metric_rank` INT NULL,
	`forward_looking` BIT NULL,
	`backward_looking` BIT NULL,
	`metric_unit` VARCHAR(10) NULL,
	`metric_stage` VARCHAR(50) NULL,
	`metric_prioritization_score` INT NULL,
	`metric_frequency` VARCHAR(20) NULL,
	PRIMARY KEY (`metric_id`, `view_id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EPRA`.`METRIC_VALUE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EPRA`.`METRIC_VALUE` ;

CREATE  TABLE IF NOT EXISTS `EPRA`.`METRIC_VALUE` (
	`period_id` VARCHAR(12) NOT NULL,
	`metric_id` VARCHAR(12) NOT NULL,
	`view_id` VARCHAR(12) NOT NULL,
	`entry_id` VARCHAR(12) NULL,
	`metric_date` DATETIME NULL,
	`metric_value_raw` VARCHAR(30) NULL,
	`band_value` INT NULL,
	`metric_value_normalised` NUMERIC(7, 4) NULL,
	`metric_value_norm_capped` NUMERIC(7, 4) NULL,
	`metric_status` VARCHAR(20) NULL,
	`metric_value_comment` VARCHAR(2000) NULL,
	`metric_dist_to_target` NUMERIC(7, 4) NULL,
	`metric_change` NUMERIC(7, 4) NULL,
	`metric_trend_status` INT NULL,
	`metric_trend_colour` VARCHAR(10) NULL,
	PRIMARY KEY (`metric_id`, `period_id`) )
ENGINE = InnoDB;



