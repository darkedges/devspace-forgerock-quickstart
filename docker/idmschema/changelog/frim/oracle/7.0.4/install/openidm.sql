--liquibase formatted sql
--changeset frim:7.0.4_openidm endDelimiter:; splitStatements:true

-- DROP SEQUENCE genericobjects_id_SEQ;


CREATE SEQUENCE  genericobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE configobjects_id_SEQ;


CREATE SEQUENCE  configobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE notificationobjects_id_SEQ;


CREATE SEQUENCE  notificationobjects_id_SEQ
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

-- DROP SEQUENCE metaobjects_id_SEQ;


CREATE SEQUENCE  metaobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

-- DROP SEQUENCE importobjects_id_SEQ;


CREATE SEQUENCE  importobjects_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;


-- DROP TABLE uinotification CASCADE CONSTRAINTS;


CREATE TABLE uinotification (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  notificationType VARCHAR2(255 CHAR) NOT NULL,
  createDate VARCHAR2(38 CHAR) NOT NULL,
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

-- DROP TABLE relationships CASCADE CONSTRAINTS;


CREATE TABLE relationships (
  id NUMBER(24,0) NOT NULL,
  objecttypes_id NUMBER(24,0) NOT NULL,
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  fullobject CLOB,
  firstresourcecollection VARCHAR2(255 CHAR),
  firstresourceid VARCHAR2(56 CHAR),
  firstpropertyname VARCHAR2(100 CHAR),
  secondresourcecollection VARCHAR2(255 CHAR),
  secondresourceid VARCHAR2(56 CHAR),
  secondpropertyname VARCHAR2(100 CHAR)
);


ALTER TABLE relationships
ADD CONSTRAINT pk_relationships PRIMARY KEY
(
  id
)
ENABLE
;

CREATE INDEX idx_relationships_first_obj ON relationships
(
  firstresourcecollection,
  firstresourceid,
  firstpropertyname
)
;

CREATE INDEX idx_relationships_second_obj ON relationships
(
  secondresourcecollection,
  secondresourceid,
  secondpropertyname
)
;

CREATE UNIQUE INDEX idx_relationships_object ON relationships
(
  objectid
)
;

CREATE INDEX idx_relationships_originFirst ON relationships
(
  firstresourceid,
  firstresourcecollection,
  firstpropertyname,
  secondresourceid,
  secondresourcecollection
);

CREATE INDEX idx_relationships_originSecond ON relationships
(
  secondresourceid,
  secondresourcecollection,
  secondpropertyname,
  firstresourceid,
  firstresourcecollection
);



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
  pwd VARCHAR2(510 CHAR)
);


ALTER TABLE internaluser
ADD CONSTRAINT PRIMARY_2 PRIMARY KEY
(
  objectid
)
ENABLE
;


-- DROP TABLE internalrole CASCADE CONSTRAINTS;

CREATE TABLE internalrole (
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  name VARCHAR2(64 CHAR),
  description VARCHAR2(510 CHAR),
  temporalConstraints VARCHAR2(1024 CHAR),
  condition VARCHAR2(1024 CHAR),
  privs CLOB
);


ALTER TABLE internalrole
ADD CONSTRAINT PRIMARY_8 PRIMARY KEY
(
  objectid
)
ENABLE
;

-- DROP TABLE links CASCADE CONSTRAINTS;


CREATE TABLE links (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  linktype VARCHAR2(255 CHAR) NOT NULL,
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

-- DROP TABLE objecttypes CASCADE CONSTRAINTS;

CREATE TABLE objecttypes (
  id NUMBER(24,0) NOT NULL,
  objecttype VARCHAR2(255 CHAR) NOT NULL
);

ALTER TABLE objecttypes
ADD CONSTRAINT primary_objecttypes_id PRIMARY KEY
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


-- DROP TABLE syncqueue CASCADE CONSTRAINTS;

CREATE TABLE syncqueue (
  objectid           VARCHAR2(38 CHAR)  NOT NULL,
  rev                VARCHAR2(38 CHAR)  NOT NULL,
  syncAction         VARCHAR2(38 CHAR)  NOT NULL,
  resourceCollection VARCHAR2(38 CHAR)  NOT NULL,
  resourceId         VARCHAR2(255 CHAR) NOT NULL,
  mapping            VARCHAR2(255 CHAR) NOT NULL,
  objectRev          VARCHAR2(38 CHAR)  NULL,
  oldObject          CLOB          NULL,
  newObject          CLOB          NULL,
  context            CLOB          NOT NULL,
  state              VARCHAR2(38 CHAR)  NOT NULL,
  nodeId             VARCHAR2(255 CHAR) NULL,
  createDate         VARCHAR2(255 CHAR) NOT NULL
);
ALTER TABLE syncqueue
  ADD CONSTRAINT PRIMARY_22 PRIMARY KEY
  (
    objectid
  )
ENABLE
;
CREATE INDEX idx_syncqueue_map_state_crdt ON syncqueue
(
  mapping,
  state,
  createDate
)
;

-- DROP TABLE locks CASCADE CONSTRAINTS;


CREATE TABLE locks (
  objectid VARCHAR2(255 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  nodeid VARCHAR2(255 CHAR)
);
ALTER TABLE locks
ADD CONSTRAINT PRIMARY_26 PRIMARY KEY
(
  objectid
)
ENABLE
;

CREATE INDEX idx_locks_nid ON locks
(
  nodeid
)
;

-- DROP TABLE files CASCADE CONSTRAINTS;


CREATE TABLE files (
  objectid VARCHAR2(38 CHAR) NOT NULL,
  rev VARCHAR2(38 CHAR) NOT NULL,
  content CLOB NULL
);
ALTER TABLE files
ADD CONSTRAINT PRIMARY_27 PRIMARY KEY
(
  objectid
)
ENABLE
;

-- DROP TABLE reconassoc CASCADE CONSTRAINTS;

CREATE TABLE reconassoc
(
    objectid VARCHAR2(255) NOT NULL,
    rev VARCHAR2(38) NOT NULL,
    mapping VARCHAR2(255) NOT NULL,
    sourceResourceCollection VARCHAR2(255) NOT NULL,
    targetResourceCollection VARCHAR2(255) NOT NULL,
    isAnalysis VARCHAR2(5) NOT NULL,
    finishTime VARCHAR2(38) NULL
);
ALTER TABLE reconassoc
  ADD CONSTRAINT PRIMARY_31 PRIMARY KEY
    (
     objectid
    )
    ENABLE
;
CREATE INDEX idx_reconassoc_mapping ON reconassoc
  (
   mapping
  )
;

-- DROP TABLE reconassocentry CASCADE CONSTRAINTS;

CREATE TABLE reconassocentry
(
     objectid VARCHAR2(38) NOT NULL,
     rev VARCHAR2(38) NOT NULL,
     reconId VARCHAR2(255) NOT NULL,
     situation VARCHAR2(38) NULL,
     action VARCHAR2(38) NULL,
     phase VARCHAR2(38) NULL,
     linkQualifier VARCHAR2(38) NOT NULL,
     sourceObjectId VARCHAR2(255) NULL,
     targetObjectId VARCHAR2(255) NULL,
     status VARCHAR2(38) NOT NULL,
     exception CLOB NULL,
     message CLOB NULL,
     messagedetail CLOB NULL,
     ambiguousTargetObjectIds CLOB NULL
);
ALTER TABLE reconassocentry
  ADD CONSTRAINT PRIMARY_32 PRIMARY KEY
    (
     objectid
    )
  ENABLE
;
ALTER TABLE reconassocentry
  ADD CONSTRAINT fk_rnasscntry_rnassc_id FOREIGN KEY
    (
     reconId
    )
    REFERENCES reconassoc
      (
       objectid
      )
    ON DELETE CASCADE
    ENABLE
;

CREATE INDEX idx_reconassocentry_situation ON reconassocentry
  (
   situation
  )
;

-- -----------------------------------------------------
-- View openidm.reconassocentryview
-- -----------------------------------------------------

CREATE VIEW reconassocentryview AS
  SELECT
    assoc.objectid as reconId,
    assoc.mapping as mapping,
    assoc.sourceResourceCollection as sourceResourceCollection,
    assoc.targetResourceCollection as targetResourceCollection,
    entry.objectid AS objectid,
    entry.rev AS rev,
    entry.action AS action,
    entry.situation AS situation,
    entry.linkQualifier as linkQualifier,
    entry.sourceObjectId as sourceObjectId,
    entry.targetObjectId as targetObjectId,
    entry.status as status,
    entry.exception as exception,
    entry.message as message,
    entry.messagedetail as messagedetail,
    entry.ambiguousTargetObjectIds as ambiguousTargetObjectIds
  FROM reconassocentry entry, reconassoc assoc
  WHERE assoc.objectid = entry.reconid
;

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

ALTER TABLE importobjectproperties
ADD CONSTRAINT fk_importproperties_conf FOREIGN KEY
(
  importobjects_id
)
REFERENCES importobjects
(
  id
)
ON DELETE CASCADE
ENABLE
;

ALTER TABLE importobjects
ADD CONSTRAINT fk_import_objecttypes FOREIGN KEY
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

CREATE OR REPLACE TRIGGER genericobjects_id_TRG BEFORE INSERT ON genericobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  genericobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM genericobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT genericobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/


CREATE OR REPLACE TRIGGER configobjects_id_TRG BEFORE INSERT ON configobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  configobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM configobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT configobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/


CREATE OR REPLACE TRIGGER notificationobjects_id_TRG BEFORE INSERT ON notificationobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  notificationobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM notificationobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT notificationobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/


CREATE OR REPLACE TRIGGER managedobjects_id_TRG BEFORE INSERT ON managedobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  managedobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM managedobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT managedobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER clusterobjects_id_TRG BEFORE INSERT ON clusterobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  clusterobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM clusterobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT clusterobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER schedulerobjects_id_TRG BEFORE INSERT ON schedulerobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  schedulerobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM schedulerobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT schedulerobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER updateobjects_id_TRG BEFORE INSERT ON updateobjects
FOR EACH ROW
  DECLARE
    v_newVal NUMBER(12) := 0;
    v_incval NUMBER(12) := 0;
  BEGIN
    IF INSERTING AND :new.id IS NULL THEN
      SELECT  updateobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
-- If this is the first time this table have been inserted into (sequence == 1)
      IF v_newVal = 1 THEN
--get the max indentity value from the table
        SELECT NVL(max(id),0) INTO v_newVal FROM updateobjects;
        v_newVal := v_newVal + 1;
--set the sequence to that value
        LOOP
          EXIT WHEN v_incval>=v_newVal;
          SELECT updateobjects_id_SEQ.nextval INTO v_incval FROM dual;
        END LOOP;
      END IF;
--used to emulate LAST_INSERT_ID()
--mysql_utilities.identity := v_newVal;
-- assign the value from the sequence to emulate the identity column
      :new.id := v_newVal;
    END IF;
  END;

/

CREATE OR REPLACE TRIGGER objecttypes_id_TRG BEFORE INSERT ON objecttypes
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  objecttypes_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM objecttypes;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT objecttypes_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER relationships_id_TRG BEFORE INSERT ON relationships
FOR EACH ROW
  DECLARE
    v_newVal NUMBER(12) := 0;
    v_incval NUMBER(12) := 0;
  BEGIN
    IF INSERTING AND :new.id IS NULL THEN
      SELECT  relationships_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
      -- If this is the first time this table have been inserted into (sequence == 1)
      IF v_newVal = 1 THEN
        --get the max indentity value from the table
        SELECT NVL(max(id),0) INTO v_newVal FROM relationships;
        v_newVal := v_newVal + 1;
        --set the sequence to that value
        LOOP
          EXIT WHEN v_incval>=v_newVal;
          SELECT relationships_id_SEQ.nextval INTO v_incval FROM dual;
        END LOOP;
      END IF;
      --used to emulate LAST_INSERT_ID()
      --mysql_utilities.identity := v_newVal;
     -- assign the value from the sequence to emulate the identity column
      :new.id := v_newVal;
    END IF;
  END;

/

CREATE OR REPLACE TRIGGER metaobjects_id_TRG BEFORE INSERT ON metaobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  metaobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM metaobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT metaobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER importobjects_id_TRG BEFORE INSERT ON importobjects
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  importobjects_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM importobjects;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT importobjects_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE TABLE relationshipresources (
     id VARCHAR2(255 CHAR) NOT NULL,
     originresourcecollection VARCHAR(255) NOT NULL,
     originproperty VARCHAR(100) NOT NULL,
     refresourcecollection VARCHAR(255) NOT NULL,
     originfirst NUMBER NOT NULL,
     reverseproperty VARCHAR(100)
);

ALTER TABLE relationshipresources
ADD CONSTRAINT pk_relationshipresources PRIMARY KEY
(
  originresourcecollection, originproperty, refresourcecollection, originfirst
)
ENABLE
;