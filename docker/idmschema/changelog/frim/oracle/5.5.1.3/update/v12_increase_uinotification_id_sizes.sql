--liquibase formatted sql
--changeset frim:5.5.1.3_update_12 endDelimiter:; splitStatements:true

ALTER TABLE uinotification MODIFY receiverId VARCHAR2(255 CHAR);
ALTER TABLE uinotification MODIFY requesterId VARCHAR2(255 CHAR);
