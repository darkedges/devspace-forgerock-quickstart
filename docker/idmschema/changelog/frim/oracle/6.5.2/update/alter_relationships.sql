--liquibase formatted sql
--changeset frim:6.5.2_update_relationships endDelimiter:; splitStatements:true

-- WARNING: This is a permanent operation and the associated data will be permanently deleted!
ALTER TABLE relationships DROP COLUMN properties;
