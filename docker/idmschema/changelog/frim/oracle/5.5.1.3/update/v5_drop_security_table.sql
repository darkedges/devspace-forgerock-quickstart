--liquibase formatted sql
--changeset frim:5.5.1.3_update_5 endDelimiter:; splitStatements:true

DROP TABLE security CASCADE CONSTRAINTS;