--liquibase formatted sql
--changeset frim:5.5.1.3_openidm_1 endDelimiter:; splitStatements:true

-- DROP SEQUENCE genericobjects_id_SEQ;


CREATE SEQUENCE  genericobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE configobjects_id_SEQ;


CREATE SEQUENCE  configobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE relationships_id_SEQ;


CREATE SEQUENCE  relationships_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE managedobjects_id_SEQ;


CREATE SEQUENCE  managedobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE schedulerobjects_id_SEQ;


CREATE SEQUENCE  schedulerobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE clusterobjects_id_SEQ;


CREATE SEQUENCE  clusterobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;


-- DROP SEQUENCE objecttypes_id_SEQ;


CREATE SEQUENCE  objecttypes_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE updateobjects_id_SEQ;


CREATE SEQUENCE  updateobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;


-- DROP TABLE uinotification CASCADE CONSTRAINTS;


CREATE TABLE uinotification (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  notificationType VARCHAR2(255 CHAR) NOT NULL,
  createDate VARCHAR2(255 CHAR) NOT NULL,
  message VARCHAR2(4000 CHAR) NOT NULL,
  requester VARCHAR2(255 CHAR),
  receiverId VARCHAR2(255 CHAR) NOT NULL,
  requesterId VARCHAR2(255 CHAR),
  notificationSubtype VARCHAR2(255 CHAR)
);

ALTER TABLE uinotification
ADD CONSTRAINT PRIMARY_0 PRIMARY KEY
(
  objectid
)
ENABLE
;

CREATE INDEX idx_uinotification_receiverId ON uinotification
(
  receiverId
)
;

-- DROP TABLE configobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE configobjectproperties (
  configobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(255 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_configobjectproperties_conf ON configobjectproperties
(
  configobjects_id
)
;
CREATE INDEX idx_configobjectpropert_1 ON configobjectproperties
(
  propkey
)
;
CREATE INDEX idx_configobjectpropert_2 ON configobjectproperties
(
  propvalue
)
;

ALTER TABLE configobjectproperties
ADD CONSTRAINT PRIMARY_15 PRIMARY KEY
(
  configobjects_id,
  propkey
)
;

-- DROP TABLE configobjects CASCADE CONSTRAINTS;


CREATE TABLE configobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE configobjects
ADD CONSTRAINT PRIMARY_3 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_configobjects_object ON configobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_configobjects_objecttypes ON configobjects
(
  objecttypes_id
)
;

-- DROP TABLE relationships CASCADE CONSTRAINTS;


CREATE TABLE relationships (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE relationships
ADD CONSTRAINT pk_relationships PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_relationships_object ON relationships
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_relationships_objecttypes ON relationships
(
  objecttypes_id
)
;

-- DROP TABLE relationshipproperties CASCADE CONSTRAINTS;


CREATE TABLE relationshipproperties (
  relationships_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(255 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);

ALTER TABLE relationshipproperties
ADD CONSTRAINT PRIMARY_21 PRIMARY KEY
(
  relationships_id,
  propkey
)
;

ALTER TABLE relationshipproperties
ADD CONSTRAINT fk_relationshipproperties_conf FOREIGN KEY
(
  relationships_id
)
REFERENCES relationships
(
  id
)
ON DELETE CASCADE
ENABLE
;
CREATE INDEX fk_relationshipproperties_conf ON relationshipproperties
(
  relationships_id
)
;
CREATE INDEX idx_relationshippropert_1 ON relationshipproperties
(
  propkey
)
;
CREATE INDEX idx_relationshippropert_2 ON relationshipproperties
(
  propvalue
)
;

-- DROP TABLE genericobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE genericobjectproperties (
  genericobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_genericobjectproperties_gen ON genericobjectproperties
(
  genericobjects_id
)
;
CREATE INDEX idx_genericobjectproper_1 ON genericobjectproperties
(
  propkey
)
;
CREATE INDEX idx_genericobjectproper_2 ON genericobjectproperties
(
  propvalue
)
;

ALTER TABLE genericobjectproperties
ADD CONSTRAINT PRIMARY_16 PRIMARY KEY
(
  genericobjects_id,
  propkey
)
;


-- DROP TABLE genericobjects CASCADE CONSTRAINTS;


CREATE TABLE genericobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE genericobjects
ADD CONSTRAINT PRIMARY_5 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_genericobjects_object ON genericobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_genericobjects_objecttypes ON genericobjects
(
  objecttypes_id
)
;


-- DROP TABLE internaluser CASCADE CONSTRAINTS;


CREATE TABLE internaluser (
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  pwd VARCHAR2(510 CHAR),
  roles VARCHAR2(1024 CHAR)
);


-- DROP TABLE internalrole CASCADE CONSTRAINTS;

CREATE TABLE internalrole (
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  description VARCHAR2(510 CHAR)
);


ALTER TABLE internaluser
ADD CONSTRAINT PRIMARY_2 PRIMARY KEY
(
  objectid
)
ENABLE
;

-- DROP TABLE links CASCADE CONSTRAINTS;


CREATE TABLE links (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  linktype VARCHAR2(50 CHAR) NOT NULL,
  linkqualifier VARCHAR2(50 CHAR) NOT NULL,
  firstid VARCHAR2(255 CHAR) NOT NULL,
  secondid VARCHAR2(255 CHAR) NOT NULL
);


ALTER TABLE links
ADD CONSTRAINT PRIMARY_4 PRIMARY KEY
(
  objectid
)
ENABLE
;
CREATE UNIQUE INDEX idx_links_first ON links
(
  linktype,
  linkqualifier,
  firstid
)
;
CREATE UNIQUE INDEX idx_links_second ON links
(
  linktype,
  linkqualifier,
  secondid
)
;

-- DROP TABLE securitykeys CASCADE CONSTRAINTS;


CREATE TABLE securitykeys (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  keypair CLOB
);


ALTER TABLE securitykeys
ADD CONSTRAINT PRIMARY_12 PRIMARY KEY
(
  objectid
)
ENABLE
;

-- DROP TABLE managedobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE managedobjectproperties (
  managedobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_managedobjectproperties_man ON managedobjectproperties
(
  managedobjects_id
)
;
CREATE INDEX idx_managedobjectproper_1 ON managedobjectproperties
(
  propkey
)
;
CREATE INDEX idx_managedobjectproper_2 ON managedobjectproperties
(
  propvalue
)
;

ALTER TABLE managedobjectproperties
ADD CONSTRAINT PRIMARY_17 PRIMARY KEY
(
  managedobjects_id,
  propkey
)
;


-- DROP TABLE managedobjects CASCADE CONSTRAINTS;


CREATE TABLE managedobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE managedobjects
ADD CONSTRAINT PRIMARY_6 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_managedobjects_object ON managedobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_managedobjects_objectypes ON managedobjects
(
  objecttypes_id
)
;

-- DROP TABLE schedobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE schedobjectproperties (
  schedulerobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_schedobjectproperties_man ON schedobjectproperties
(
  schedulerobjects_id
)
;
CREATE INDEX idx_schedobjectproperties_1 ON schedobjectproperties
(
  propkey
)
;
CREATE INDEX idx_schedobjectproperties_2 ON schedobjectproperties
(
  propvalue
)
;

ALTER TABLE schedobjectproperties
ADD CONSTRAINT PRIMARY_18 PRIMARY KEY
(
  schedulerobjects_id,
  propkey
)
;


-- DROP TABLE schedulerobjects CASCADE CONSTRAINTS;


CREATE TABLE schedulerobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE schedulerobjects
ADD CONSTRAINT PRIMARY_9 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_schedulerobjects_object ON schedulerobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_schedulerobjects_objectypes ON schedulerobjects
(
  objecttypes_id
)
;

-- DROP TABLE clusterobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE clusterobjectproperties (
  clusterobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_clusterobjectproperties_man ON clusterobjectproperties
(
  clusterobjects_id
)
;
CREATE INDEX idx_clusterobjectproperties_1 ON clusterobjectproperties
(
  propkey
)
;
CREATE INDEX idx_clusterobjectproperties_2 ON clusterobjectproperties
(
  propvalue
)
;

ALTER TABLE clusterobjectproperties
ADD CONSTRAINT PRIMARY_19 PRIMARY KEY
(
  clusterobjects_id,
  propkey
)
;


-- DROP TABLE clusterobjects CASCADE CONSTRAINTS;


CREATE TABLE clusterobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE clusterobjects
ADD CONSTRAINT PRIMARY_10 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_clusterobjects_object ON clusterobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_clusterobjects_objectypes ON clusterobjects
(
  objecttypes_id
)
;


-- DROP TABLE clusteredrecontargetids CASCADE CONSTRAINTS;


CREATE TABLE clusteredrecontargetids (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  reconid VARCHAR2(255 CHAR) NOT NULL,
  targetids CLOB NOT NULL
);
ALTER TABLE clusteredrecontargetids
ADD CONSTRAINT PRIMARY_11 PRIMARY KEY
(
  objectid
)
ENABLE
;

CREATE INDEX idx_clusteredrecontids_rid ON clusteredrecontargetids
(
  reconid
)
;



-- DROP TABLE updateobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE updateobjectproperties (
  updateobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_updateobjectproperties_gen ON updateobjectproperties
(
  updateobjects_id
)
;
CREATE INDEX idx_updateobjectproper_1 ON updateobjectproperties
(
  propkey
)
;
CREATE INDEX idx_updateobjectproper_2 ON updateobjectproperties
(
  propvalue
)
;

ALTER TABLE updateobjectproperties
ADD CONSTRAINT PRIMARY_20 PRIMARY KEY
(
  updateobjects_id,
  propkey
)
;


-- DROP TABLE updateobjects CASCADE CONSTRAINTS;


CREATE TABLE updateobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE updateobjects
ADD CONSTRAINT PRIMARY_14 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_updateobjects_object ON updateobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_updateobjects_objecttypes ON updateobjects
(
  objecttypes_id
)
;

-- DROP TABLE objecttypes CASCADE CONSTRAINTS;


CREATE TABLE objecttypes (
  id NUMBER(24,0) NOT NULL,
  objecttype VARCHAR2(255 CHAR)
);


ALTER TABLE objecttypes
ADD CONSTRAINT PRIMARY_7 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_objecttypes_objecttype ON objecttypes
(
  objecttype
)
;

ALTER TABLE configobjectproperties
ADD CONSTRAINT fk_configobjectproperties_conf FOREIGN KEY
(
  configobjects_id
)
REFERENCES configobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE configobjects
ADD CONSTRAINT fk_configobjects_objecttypes FOREIGN KEY
(
  objecttypes_id
)
REFERENCES objecttypes
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE genericobjects
ADD CONSTRAINT fk_genericobjects_objecttypes FOREIGN KEY
(
  objecttypes_id
)
REFERENCES objecttypes
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE managedobjectproperties
ADD CONSTRAINT fk_managedobjectproperties_man FOREIGN KEY
(
  managedobjects_id
)
REFERENCES managedobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE managedobjects
ADD CONSTRAINT fk_managedobjects_objectypes FOREIGN KEY
(
  objecttypes_id
)
REFERENCES objecttypes
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE schedobjectproperties
  ADD CONSTRAINT fk_schedobjectproperties_man FOREIGN KEY
  (
    schedulerobjects_id
  )
REFERENCES schedulerobjects
  (
    id
  )
ON DELETE CASCADE
ENABLE
;

ALTER TABLE schedulerobjects
  ADD CONSTRAINT fk_schedulerobjects_objectypes FOREIGN KEY
  (
    objecttypes_id
  )
REFERENCES objecttypes
  (
    id
  )
ON DELETE CASCADE
ENABLE
;

ALTER TABLE clusterobjectproperties
  ADD CONSTRAINT fk_clusterobjectproperties_man FOREIGN KEY
  (
    clusterobjects_id
  )
REFERENCES clusterobjects
  (
    id
  )
ON DELETE CASCADE
ENABLE
;

ALTER TABLE clusterobjects
  ADD CONSTRAINT fk_clusterobjects_objectypes FOREIGN KEY
  (
    objecttypes_id
  )
REFERENCES objecttypes
  (
    id
  )
ON DELETE CASCADE
ENABLE
;

ALTER TABLE relationships
  ADD CONSTRAINT fk_relationships_objecttypes FOREIGN KEY
  (
    objecttypes_id
  )
REFERENCES objecttypes
  (
    id
  )
ON DELETE CASCADE
ENABLE
;

ALTER TABLE genericobjectproperties
ADD CONSTRAINT fk_genericobjectproperties_gen FOREIGN KEY
(
  genericobjects_id
)
REFERENCES genericobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE updateobjectproperties
ADD CONSTRAINT fk_updateobjectproperties_man FOREIGN KEY
(
  updateobjects_id
)
REFERENCES updateobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE updateobjects
ADD CONSTRAINT fk_updateobjects_objectypes FOREIGN KEY
(
  objecttypes_id
)
REFERENCES objecttypes
(
  id
)
ON DELETE CASCADE
ENABLE
;
