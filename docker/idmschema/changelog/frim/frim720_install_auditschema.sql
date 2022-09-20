--liquibase formatted sql

--changeset frim:7.2.0_audit endDelimiter:; splitStatements:true

-- -----------------------------------------------------
-- Table `frim`.`auditauthentication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `frim`.`auditauthentication` (
  `objectid` VARCHAR(56) NOT NULL ,
  `transactionid` VARCHAR(255) NOT NULL ,
  `activitydate` VARCHAR(29) NOT NULL COMMENT 'Date format: 2011-09-09T14:58:17.654+02:00' ,
  `userid` VARCHAR(255) NULL ,
  `eventname` VARCHAR(50) NULL ,
  `provider` VARCHAR(255) NULL ,
  `method` VARCHAR(25) NULL ,
  `result` VARCHAR(255) NULL ,
  `principals` TEXT ,
  `context` TEXT ,
  `entries` TEXT ,
  `trackingids` TEXT,
  PRIMARY KEY (`objectid`)
)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`auditrecon`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`auditrecon` (
  `objectid` VARCHAR(56) NOT NULL ,
  `transactionid` VARCHAR(255) NOT NULL ,
  `activitydate` VARCHAR(29) NOT NULL COMMENT 'Date format: 2011-09-09T14:58:17.654+02:00' ,
  `eventname` VARCHAR(50) NULL ,
  `userid` VARCHAR(255) NULL ,
  `trackingids` MEDIUMTEXT ,
  `activity` VARCHAR(24) NULL ,
  `exceptiondetail` TEXT NULL ,
  `linkqualifier` VARCHAR(255) NULL ,
  `mapping` VARCHAR(511) NULL ,
  `message` TEXT NULL ,
  `messagedetail` MEDIUMTEXT NULL ,
  `situation` VARCHAR(24) NULL ,
  `sourceobjectid` VARCHAR(511) NULL ,
  `status` VARCHAR(20) NULL ,
  `targetobjectid` VARCHAR(511) NULL ,
  `reconciling` VARCHAR(12) NULL ,
  `ambiguoustargetobjectids` MEDIUMTEXT NULL ,
  `reconaction` VARCHAR(36) NULL ,
  `entrytype` VARCHAR(7) NULL ,
  `reconid` VARCHAR(56) NULL ,
  PRIMARY KEY (`objectid`) ,
  INDEX `idx_auditrecon_reconid` (`reconid` ASC),
  INDEX `idx_auditrecon_entrytype` (`entrytype` ASC)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`auditsync`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`auditsync` (
  `objectid` VARCHAR(56) NOT NULL ,
  `transactionid` VARCHAR(255) NOT NULL ,
  `activitydate` VARCHAR(29) NOT NULL COMMENT 'Date format: 2011-09-09T14:58:17.654+02:00' ,
  `eventname` VARCHAR(50) NULL ,
  `userid` VARCHAR(255) NULL ,
  `trackingids` MEDIUMTEXT ,
  `activity` VARCHAR(24) NULL ,
  `exceptiondetail` TEXT NULL ,
  `linkqualifier` VARCHAR(255) NULL ,
  `mapping` VARCHAR(511) NULL ,
  `message` TEXT NULL ,
  `messagedetail` MEDIUMTEXT NULL ,
  `situation` VARCHAR(24) NULL ,
  `sourceobjectid` VARCHAR(511) NULL ,
  `status` VARCHAR(20) NULL ,
  `targetobjectid` VARCHAR(511) NULL ,
  PRIMARY KEY (`objectid`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`auditconfig`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`auditconfig` (
  `objectid` VARCHAR(56) NOT NULL ,
  `activitydate` VARCHAR(29) NOT NULL COMMENT 'Date format: 2011-09-09T14:58:17.654+02:00' ,
  `eventname` VARCHAR(255) NULL ,
  `transactionid` VARCHAR(255) NOT NULL ,
  `userid` VARCHAR(255) NULL ,
  `trackingids` MEDIUMTEXT,
  `runas` VARCHAR(255) NULL ,
  `configobjectid` VARCHAR(255) NULL ,
  `operation` VARCHAR(255) NULL ,
  `beforeObject` MEDIUMTEXT NULL ,
  `afterObject` MEDIUMTEXT NULL ,
  `changedfields` MEDIUMTEXT NULL ,
  `rev` VARCHAR(255) NULL,
  PRIMARY KEY (`objectid`)
)
  ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`auditactivity`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`auditactivity` (
  `objectid` VARCHAR(56) NOT NULL ,
  `activitydate` VARCHAR(29) NOT NULL COMMENT 'Date format: 2011-09-09T14:58:17.654+02:00' ,
  `eventname` VARCHAR(255) NULL ,
  `transactionid` VARCHAR(255) NOT NULL ,
  `userid` VARCHAR(255) NULL ,
  `trackingids` MEDIUMTEXT,
  `runas` VARCHAR(255) NULL ,
  `activityobjectid` VARCHAR(255) NULL ,
  `operation` VARCHAR(255) NULL ,
  `subjectbefore` MEDIUMTEXT NULL ,
  `subjectafter` MEDIUMTEXT NULL ,
  `changedfields` MEDIUMTEXT NULL ,
  `subjectrev` VARCHAR(255) NULL ,
  `passwordchanged` VARCHAR(5) NULL ,
  `message` TEXT NULL,
  `provider` VARCHAR(255) NULL,
  `context` VARCHAR(25) NULL,
  `status` VARCHAR(20) ,
  PRIMARY KEY (`objectid`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`auditaccess`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`auditaccess` (
  `objectid` VARCHAR(56) NOT NULL ,
  `activitydate` VARCHAR(29) NOT NULL COMMENT 'Date format: 2011-09-09T14:58:17.654+02:00' ,
  `eventname` VARCHAR(255) ,
  `transactionid` VARCHAR(255) NOT NULL ,
  `userid` VARCHAR(255) ,
  `trackingids` TEXT,
  `server_ip` VARCHAR(40) ,
  `server_port` VARCHAR(5) ,
  `client_ip` VARCHAR(40) ,
  `client_port` VARCHAR(5) ,
  `request_protocol` VARCHAR(255) NULL ,
  `request_operation` VARCHAR(255) NULL ,
  `request_detail` TEXT NULL ,
  `http_request_secure` VARCHAR(255) NULL ,
  `http_request_method` VARCHAR(255) NULL ,
  `http_request_path` VARCHAR(255) NULL ,
  `http_request_queryparameters` TEXT NULL ,
  `http_request_headers` TEXT NULL ,
  `http_request_cookies` TEXT NULL ,
  `http_response_headers` TEXT NULL ,
  `response_status` VARCHAR(255) NULL ,
  `response_statuscode` VARCHAR(255) NULL ,
  `response_elapsedtime` VARCHAR(255) NULL ,
  `response_elapsedtimeunits` VARCHAR(255) NULL ,
  `response_detail` TEXT NULL ,
  `roles` TEXT NULL ,
  PRIMARY KEY (`objectid`)
)
ENGINE = InnoDB;