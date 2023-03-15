--liquibase formatted sql
--changeset frim:5.5.1.3_update_4 endDelimiter:; splitStatements:true

ALTER TABLE auditaccess ADD (response_detail CLOB NULL);
