--liquibase formatted sql
--changeset frim:6.0.0.7_update_v16 endDelimiter:; splitStatements:true

ALTER TABLE auditauthentication MODIFY method VARCHAR2(25 CHAR);