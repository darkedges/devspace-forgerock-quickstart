--liquibase formatted sql
--changeset frim:6.5.2_update_metaobjects_ endDelimiter:; splitStatements:true

-- DROP SEQUENCE metaobjects_id_SEQ;


CREATE SEQUENCE  metaobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP TABLE metaobjectproperties CASCADE CONSTRAINTS;


CREATE TABLE metaobjectproperties (
  metaobjects_id NUMBER(24,0) NOT NULL,
  propkey VARCHAR2(255 CHAR) NOT NULL,
  proptype VARCHAR2(32 CHAR),
  propvalue VARCHAR2(2000 CHAR)
);


CREATE INDEX fk_metaobjectproperties_gen ON metaobjectproperties
(
  metaobjects_id
)
;
CREATE INDEX idx_metaobjectproper_1 ON metaobjectproperties
(
  propkey
)
;
CREATE INDEX idx_metaobjectproper_2 ON metaobjectproperties
(
  propvalue
)
;

ALTER TABLE metaobjectproperties
ADD CONSTRAINT PRIMARY_28 PRIMARY KEY
(
  metaobjects_id,
  propkey
)
;


-- DROP TABLE metaobjects CASCADE CONSTRAINTS;


CREATE TABLE metaobjects (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB
);


ALTER TABLE metaobjects
ADD CONSTRAINT PRIMARY_29 PRIMARY KEY
(
  id
)
ENABLE
;
CREATE UNIQUE INDEX idx_metaobjects_object ON metaobjects
(
  objecttypes_id,
  objectid
)
;
CREATE INDEX fk_metaobjects_objecttypes ON metaobjects
(
  objecttypes_id
)
;


ALTER TABLE metaobjectproperties
ADD CONSTRAINT fk_metaproperties_conf FOREIGN KEY
(
  metaobjects_id
)
REFERENCES metaobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE metaobjects
ADD CONSTRAINT fk_meta_objecttypes FOREIGN KEY
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

-- -----------------------------------------------------
-- Migrate user meta data
-- -----------------------------------------------------
INSERT INTO metaobjects (id, objecttypes_id, objectid, rev, fullobject)
  SELECT metaobjects_id_SEQ.NEXTVAL, objecttypes_id, objectid, rev, fullobject
  FROM genericobjects
    WHERE objecttypes_id = (SELECT id FROM objecttypes WHERE objecttype = 'internal/usermeta');

INSERT INTO metaobjectproperties (metaobjects_id, propkey, proptype, propvalue)
  SELECT metaobjects.id, genericobjectproperties.propkey, genericobjectproperties.proptype, genericobjectproperties.propvalue
  FROM metaobjects
  JOIN genericobjects ON metaobjects.objectid = genericobjects.objectid
    AND metaobjects.objecttypes_id = genericobjects.objecttypes_id
  JOIN genericobjectproperties ON genericobjects.id = genericobjectproperties.genericobjects_id;


-- -----------------------------------------------------
-- Remove old user meta data
-- WARNING: This is a permanent operation and the associated data will be permanently deleted!
-- -----------------------------------------------------
DELETE FROM genericobjects
  WHERE objectid IN (SELECT objectid FROM metaobjects)
  AND objecttypes_id = (SELECT id FROM objecttypes WHERE objecttype = 'internal/usermeta');
COMMIT;


