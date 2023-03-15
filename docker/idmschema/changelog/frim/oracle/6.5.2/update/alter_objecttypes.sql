--liquibase formatted sql
--changeset frim:6.5.2_update_objecttypes endDelimiter:; splitStatements:true

-- Alter objecttypes schema
ALTER TABLE objecttypes
 MODIFY objecttype VARCHAR2(255 CHAR) NOT NULL;