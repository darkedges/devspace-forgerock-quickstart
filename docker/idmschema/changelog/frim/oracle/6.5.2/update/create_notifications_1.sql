--liquibase formatted sql
--changeset frim:6.5.2_update_notificationobjects endDelimiter:; splitStatements:true

-- DROP SEQUENCE notificationobjects_id_SEQ;


CREATE SEQUENCE  notificationobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP TABLE notificationobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE notificationobjectproperties (
  notificationobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(255 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_notificationproperties_conf ON notificationobjectproperties
(
  notificationobjects_id
)
;
CREATE INDEX idx_notificationproperties_1 ON notificationobjectproperties
(
  propkey
)
;
CREATE INDEX idx_notificationproperties_2 ON notificationobjectproperties
(
  propvalue
)
;

ALTER TABLE notificationobjectproperties
ADD CONSTRAINT PRIMARY_24 PRIMARY KEY
(
  notificationobjects_id,
  propkey
)
;

-- DROP TABLE notificationobjects CASCADE CONSTRAINTS;


CREATE TABLE notificationobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE notificationobjects
ADD CONSTRAINT PRIMARY_25 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_notificationobjects_object ON notificationobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_notification_objecttypes ON notificationobjects
(
  objecttypes_id
)
;

ALTER TABLE notificationobjectproperties
ADD CONSTRAINT fk_notificationproperties_conf FOREIGN KEY
(
  notificationobjects_id
)
REFERENCES notificationobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE notificationobjects
ADD CONSTRAINT fk_notification_objecttypes FOREIGN KEY
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