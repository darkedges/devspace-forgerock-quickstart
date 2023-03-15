--liquibase formatted sql
--changeset frim:6.5.2_update_files endDelimiter:; splitStatements:true

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
