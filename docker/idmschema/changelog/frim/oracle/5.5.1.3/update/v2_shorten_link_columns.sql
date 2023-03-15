--liquibase formatted sql
--changeset frim:5.5.1.3_update_2 endDelimiter:; splitStatements:true

ALTER TABLE links MODIFY linktype VARCHAR2(50 CHAR);
ALTER TABLE links MODIFY linkqualifier VARCHAR2(50 CHAR);
