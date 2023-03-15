--liquibase formatted sql
--changeset frim:6.5.2_update_internalroles endDelimiter:; splitStatements:true

-- Add new columns to internalrole
ALTER TABLE internalrole
ADD
(
  name VARCHAR2(64 CHAR),
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

