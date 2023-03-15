--liquibase formatted sql
--changeset frim:5.5.1.3_update_10 endDelimiter:; splitStatements:true

ALTER TABLE auditauthentication ADD provider varchar2(255 CHAR) NULL;
ALTER TABLE auditauthentication ADD method varchar2(15 CHAR) NULL;
ALTER TABLE auditactivity ADD provider varchar2(255 CHAR) NULL;
ALTER TABLE auditactivity ADD context varchar2(25 CHAR) NULL;
