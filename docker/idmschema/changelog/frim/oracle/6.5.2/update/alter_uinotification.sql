--liquibase formatted sql
--changeset frim:6.5.2_update_uinotification endDelimiter:; splitStatements:true

-- Alter uinotification schema
ALTER TABLE uinotification
 MODIFY createDate VARCHAR2(38 CHAR);