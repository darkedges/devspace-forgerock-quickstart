--liquibase formatted sql
--changeset frim:6.5.2_update_syncqueue endDelimiter:; splitStatements:true

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
  remainingRetries   VARCHAR2(38 CHAR)  NOT NULL,
  createDate         VARCHAR2(38 CHAR) NOT NULL
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
CREATE INDEX idx_syncqueue_mapping_retries ON syncqueue
(
  mapping,
  remainingRetries
)
;

-- DROP TABLE locks CASCADE CONSTRAINTS;


CREATE TABLE locks (
  objectid VARCHAR2(38 CHAR) NOT NULL,
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
