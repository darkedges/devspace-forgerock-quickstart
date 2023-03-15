--liquibase formatted sql
--changeset frim:7.0.4_update_02 endDelimiter:; splitStatements:true

-- DROP TABLE importobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE importobjectproperties (
  importobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_importobjectproperties_gen ON importobjectproperties
(
  importobjects_id
)
;
CREATE INDEX idx_importobjectproper_1 ON importobjectproperties
(
  propkey
)
;
CREATE INDEX idx_importobjectproper_2 ON importobjectproperties
(
  propvalue
)
;

ALTER TABLE importobjectproperties
ADD CONSTRAINT PRIMARY_33 PRIMARY KEY
(
  importobjects_id,
  propkey
)
;


-- DROP TABLE importobjects CASCADE CONSTRAINTS;


CREATE TABLE importobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE importobjects
ADD CONSTRAINT PRIMARY_34 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_importobjects_object ON importobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_importobjects_objecttypes ON importobjects
(
  objecttypes_id
)
;