--liquibase formatted sql

--changeset frim:7.1.0_base endDelimiter:; splitStatements:true

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `frim` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `frim` ;

-- -----------------------------------------------------
-- Table `frim`.`objecttypes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`objecttypes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttype` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx_objecttypes_objecttype` (`objecttype` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`genericobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`genericobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  INDEX `fk_genericobjects_objecttypes` (`objecttypes_id` ASC) ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx_genericobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  CONSTRAINT `fk_genericobjects_objecttypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`genericobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`genericobjectproperties` (
  `genericobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(32) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`genericobjects_id`, `propkey`, `propindex`),
  INDEX `fk_genericobjectproperties_genericobjects` (`genericobjects_id` ASC) ,
  INDEX `idx_genericobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_genericobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_genericobjectproperties_genericobjects`
    FOREIGN KEY (`genericobjects_id` )
    REFERENCES `frim`.`genericobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`managedobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`managedobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx-managedobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  INDEX `fk_managedobjects_objectypes` (`objecttypes_id` ASC) ,
  CONSTRAINT `fk_managedobjects_objectypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`managedobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`managedobjectproperties` (
  `managedobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(32) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`managedobjects_id`, `propkey`, `propindex`),
  INDEX `fk_managedobjectproperties_managedobjects` (`managedobjects_id` ASC) ,
  INDEX `idx_managedobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_managedobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_managedobjectproperties_managedobjects`
    FOREIGN KEY (`managedobjects_id` )
    REFERENCES `frim`.`managedobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`configobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`configobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_configobjects_objecttypes` (`objecttypes_id` ASC) ,
  UNIQUE INDEX `idx_configobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  CONSTRAINT `fk_configobjects_objecttypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`configobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`configobjectproperties` (
  `configobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(255) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`configobjects_id`, `propkey`, `propindex`),
  INDEX `fk_configobjectproperties_configobjects` (`configobjects_id` ASC) ,
  INDEX `idx_configobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_configobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_configobjectproperties_configobjects`
    FOREIGN KEY (`configobjects_id` )
    REFERENCES `frim`.`configobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`notificationobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`notificationobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  INDEX `fk_notificationobjects_objecttypes` (`objecttypes_id` ASC) ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx_notificationobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  CONSTRAINT `fk_notificationobjects_objecttypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`notificationobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`notificationobjectproperties` (
  `notificationobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(32) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`notificationobjects_id`, `propkey`, `propindex`),
  INDEX `fk_notificationobjectproperties_notificationobjects` (`notificationobjects_id` ASC) ,
  INDEX `idx_notificationobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_notificationobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_notificationobjectproperties_notificationobjects`
    FOREIGN KEY (`notificationobjects_id` )
    REFERENCES `frim`.`notificationobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`relationships`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`relationships` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  `firstresourcecollection` VARCHAR(255) ,
  `firstresourceid` VARCHAR(56) ,
  `firstpropertyname` VARCHAR(100) ,
  `secondresourcecollection` VARCHAR(255) ,
  `secondresourceid` VARCHAR(56) ,
  `secondpropertyname` VARCHAR(100) ,
  PRIMARY KEY (`id`) ,
  INDEX `idx_relationships_first_object` (`firstresourcecollection` ASC, `firstresourceid` ASC, `firstpropertyname` ASC) ,
  INDEX `idx_relationships_second_object` (`secondresourcecollection` ASC, `secondresourceid` ASC, `secondpropertyname` ASC) ,
  INDEX `idx_relationships_originFirst` (`firstresourceid` ASC, `firstresourcecollection` ASC, `firstpropertyname` ASC, `secondresourceid` ASC, `secondresourcecollection` ASC),
  INDEX `idx_relationships_originSecond` (`secondresourceid` ASC, `secondresourcecollection` ASC, `secondpropertyname` ASC, `firstresourceid` ASC, `firstresourcecollection` ASC),
  UNIQUE INDEX `idx_relationships_object` (`objectid` ASC),
  CONSTRAINT `fk_relationships_objecttypes`
  FOREIGN KEY (`objecttypes_id` )
  REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`relationshipproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`relationshipproperties` (
  `relationships_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(255) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`relationships_id`, `propkey`, `propindex`),
  INDEX `fk_relationshipproperties_relationships` (`relationships_id` ASC) ,
  INDEX `idx_relationshipproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_relationshipproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_relationshipproperties_relationships`
  FOREIGN KEY (`relationships_id` )
  REFERENCES `frim`.`relationships` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`links`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`links` (
  `objectid` VARCHAR(38) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `linktype` VARCHAR(255) NOT NULL ,
  `linkqualifier` VARCHAR(50) NOT NULL ,
  `firstid` VARCHAR(255) NOT NULL ,
  `secondid` VARCHAR(255) NOT NULL ,
  UNIQUE INDEX `idx_links_first` (`linktype` ASC, `linkqualifier` ASC, `firstid` ASC) ,
  UNIQUE INDEX `idx_links_second` (`linktype` ASC, `linkqualifier` ASC, `secondid` ASC) ,
  INDEX `idx_links_firstid` (`firstid`) ,
  INDEX `idx_links_secondid` (`secondid`) ,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`internaluser`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`internaluser` (
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `pwd` VARCHAR(510) NULL ,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`internalrole`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`internalrole` (
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `name` VARCHAR(64) NULL ,
  `description` VARCHAR(510) NULL ,
  `temporalConstraints` VARCHAR(1024) NULL,
  `conditional` VARCHAR(1024) NULL,
  `privs` MEDIUMTEXT NULL,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`schedulerobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`schedulerobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx-schedulerobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  INDEX `fk_schedulerobjects_objectypes` (`objecttypes_id` ASC) ,
  CONSTRAINT `fk_schedulerobjects_objectypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`schedulerobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`schedulerobjectproperties` (
  `schedulerobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(32) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`schedulerobjects_id`, `propkey`, `propindex`),
  INDEX `fk_schedulerobjectproperties_schedulerobjects` (`schedulerobjects_id` ASC) ,
  INDEX `idx_schedulerobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_schedulerobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_schedulerobjectproperties_schedulerobjects`
    FOREIGN KEY (`schedulerobjects_id` )
    REFERENCES `frim`.`schedulerobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`uinotification`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`uinotification` (
  `objectid` VARCHAR(38) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `notificationType` VARCHAR(255) NOT NULL ,
  `createDate` VARCHAR(38) NOT NULL ,
  `message` TEXT NOT NULL ,
  `requester` VARCHAR(255) NULL ,
  `receiverId` VARCHAR(255) NOT NULL ,
  `requesterId` VARCHAR(255) NULL ,
  `notificationSubtype` VARCHAR(255) NULL ,
  INDEX `idx-uinotification-receiverId` (`receiverId` ASC) ,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`clusterobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`clusterobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx-clusterobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  INDEX `fk_clusterobjects_objectypes` (`objecttypes_id` ASC) ,
  CONSTRAINT `fk_clusterobjects_objectypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`clusterobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`clusterobjectproperties` (
  `clusterobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(32) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`clusterobjects_id`, `propkey`, `propindex`),
  INDEX `idx_clusterobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_clusterobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  INDEX `fk_clusterobjectproperties_clusterobjects` (`clusterobjects_id` ASC) ,
  CONSTRAINT `fk_clusterobjectproperties_clusterobjects`
    FOREIGN KEY (`clusterobjects_id` )
    REFERENCES `frim`.`clusterobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`clusteredrecontargetids`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`clusteredrecontargetids` (
  `objectid` VARCHAR(38) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `reconid` VARCHAR(255) NOT NULL ,
  `targetids` LONGTEXT NOT NULL ,
  INDEX `idx_clusteredrecontargetids_reconid` (`reconid` ASC) ,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`updateobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`updateobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_updateobjects_objecttypes` (`objecttypes_id` ASC) ,
  UNIQUE INDEX `idx_updateobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  CONSTRAINT `fk_updateobjects_objecttypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`updateobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`updateobjectproperties` (
  `updateobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(255) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`updateobjects_id`, `propkey`, `propindex`),
  INDEX `fk_updateobjectproperties_updateobjects` (`updateobjects_id` ASC) ,
  INDEX `idx_updateobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_updateobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_updateobjectproperties_updateobjects`
    FOREIGN KEY (`updateobjects_id` )
    REFERENCES `frim`.`updateobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`importobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`importobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_importobjects_objecttypes` (`objecttypes_id` ASC) ,
  UNIQUE INDEX `idx_importobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  CONSTRAINT `fk_importobjects_objecttypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`importobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`importobjectproperties` (
  `importobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(255) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`importobjects_id`, `propkey`, `propindex`),
  INDEX `fk_importobjectproperties_importobjects` (`importobjects_id` ASC) ,
  INDEX `idx_importobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_importobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_importobjectproperties_importobjects`
    FOREIGN KEY (`importobjects_id` )
    REFERENCES `frim`.`importobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`syncqueue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `frim`.`syncqueue` (
  `objectid` VARCHAR(38) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `syncAction` VARCHAR(38) NOT NULL ,
  `resourceCollection` VARCHAR(38) NOT NULL ,
  `resourceId` VARCHAR(255) NOT NULL ,
  `mapping` VARCHAR(255) NOT NULL ,
  `objectRev` VARCHAR(38) NULL ,
  `oldObject` MEDIUMTEXT NULL ,
  `newObject` MEDIUMTEXT NULL ,
  `context` MEDIUMTEXT NOT NULL ,
  `state` VARCHAR(38) NOT NULL ,
  `nodeId` VARCHAR(255) NULL ,
  `createDate` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`objectid`) ,
  INDEX `indx_syncqueue_mapping_state_createdate` (`mapping` ASC, `state` ASC, `createDate` ASC) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`locks`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`locks` (
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `nodeid` VARCHAR(255) ,
  INDEX `idx_locks_nodeid` (`nodeid` ASC) ,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`files`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`files` (
  `objectid` VARCHAR(38) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `content` LONGTEXT ,
  PRIMARY KEY (`objectid`) )
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Table `frim`.`metaobjects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`metaobjects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `objecttypes_id` BIGINT UNSIGNED NOT NULL ,
  `objectid` VARCHAR(255) NOT NULL ,
  `rev` VARCHAR(38) NOT NULL ,
  `fullobject` MEDIUMTEXT NULL ,
  INDEX `fk_metaobjects_objecttypes` (`objecttypes_id` ASC) ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `idx_metaobjects_object` (`objecttypes_id` ASC, `objectid` ASC) ,
  CONSTRAINT `fk_metaobjects_objecttypes`
    FOREIGN KEY (`objecttypes_id` )
    REFERENCES `frim`.`objecttypes` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `frim`.`metaobjectproperties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `frim`.`metaobjectproperties` (
  `metaobjects_id` BIGINT UNSIGNED NOT NULL ,
  `propkey` VARCHAR(255) NOT NULL ,
  `proptype` VARCHAR(32) NULL ,
  `propvalue` VARCHAR(2000) NULL ,
  `propindex` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`metaobjects_id`, `propkey`, `propindex`),
  INDEX `fk_metaobjectproperties_metaobjects` (`metaobjects_id` ASC) ,
  INDEX `idx_metaobjectproperties_propkey` (`propkey` ASC) ,
  INDEX `idx_metaobjectproperties_propvalue` (`propvalue`(255) ASC) ,
  CONSTRAINT `fk_metaobjectproperties_metaobjects`
    FOREIGN KEY (`metaobjects_id` )
    REFERENCES `frim`.`metaobjects` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `frim`.`reconassoc`
-- -----------------------------------------------------

CREATE TABLE `frim`.`reconassoc` (
    `objectid` VARCHAR(255) NOT NULL ,
    `rev` VARCHAR(38) NOT NULL ,
    `mapping` VARCHAR(255) NOT NULL ,
    `sourceResourceCollection` VARCHAR(255) NOT NULL ,
    `targetResourceCollection` VARCHAR(255) NOT NULL ,
    `isAnalysis` VARCHAR(5) NOT NULL ,
    `finishTime` VARCHAR(38) NULL ,
    PRIMARY KEY (`objectid`) ,
    INDEX `idx_reconassoc_mapping` (`mapping` ASC) ,
    INDEX `idx_reconassoc_reconId` (`objectid` ASC) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table frim.reconassocentry
-- -----------------------------------------------------

CREATE TABLE `frim`.`reconassocentry` (
   `objectid` VARCHAR(38) NOT NULL ,
   `rev` VARCHAR(38) NOT NULL ,
   `reconId` VARCHAR(255) NOT NULL ,
   `situation` VARCHAR(38) NULL ,
   `action` VARCHAR(38) NULL ,
   `phase` VARCHAR(38) NULL ,
   `linkQualifier` VARCHAR(38) NOT NULL ,
   `sourceObjectId` VARCHAR(255) NULL ,
   `targetObjectId` VARCHAR(255) NULL ,
   `status` VARCHAR(38) NOT NULL ,
   `exception` TEXT NULL ,
   `message` TEXT NULL ,
   `messagedetail` TEXT NULL ,
   `ambiguousTargetObjectIds` MEDIUMTEXT NULL ,
   PRIMARY KEY (`objectid`) ,
   INDEX `idx_reconassocentry_situation` (`situation` ASC) ,
   CONSTRAINT `fk_reconassocentry_reconassoc_id`
     FOREIGN KEY (`reconId`)
     REFERENCES `frim`.`reconassoc` (`objectid`)
     ON DELETE CASCADE
     ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- View frim.reconassocentryview
-- -----------------------------------------------------
CREATE VIEW `frim`.`reconassocentryview` AS
 SELECT
  `assoc`.`objectid` AS `reconId`,
  `assoc`.`mapping` AS `mapping`,
  `assoc`.`sourceResourceCollection` AS `sourceResourceCollection`,
  `assoc`.`targetResourceCollection` AS `targetResourceCollection`,
  `entry`.`objectid` AS `objectid`,
  `entry`.`rev` AS `rev`,
  `entry`.`action` AS `action`,
  `entry`.`situation` AS `situation`,
  `entry`.`linkQualifier` AS `linkQualifier`,
  `entry`.`sourceObjectId` AS `sourceObjectId`,
  `entry`.`targetObjectId` AS `targetObjectId`,
  `entry`.`status` AS `status`,
  `entry`.`exception` AS `exception`,
  `entry`.`message` AS `message`,
  `entry`.`messagedetail` AS `messagedetail`,
  `entry`.`ambiguousTargetObjectIds` AS `ambiguousTargetObjectIds`
 FROM `frim`.`reconassocentry` `entry`, `frim`.`reconassoc` `assoc`
 WHERE `assoc`.`objectid` = `entry`.`reconid`;

-- -----------------------------------------------------
-- Table `frim`.`relationshipresources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `frim`.`relationshipresources` (
  `id` VARCHAR(255) NOT NULL ,
  `originresourcecollection` VARCHAR(255) NOT NULL ,
  `originproperty` VARCHAR(100) NOT NULL ,
  `refresourcecollection` VARCHAR(255) NOT NULL ,
  `originfirst` tinyint(1) NOT NULL ,
  `reverseproperty` VARCHAR(100) ,
  PRIMARY KEY ( `originproperty`, `originresourcecollection`, `refresourcecollection`, `originfirst`))
  ENGINE = InnoDB;


