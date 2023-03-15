--liquibase formatted sql
--changeset frim:6.5.2_update_internaluser endDelimiter:; splitStatements:true

-- WARNING: This is a permanent operation and the associated data will be permanently deleted!
-- Drop 'roles' column from internaluser
ALTER TABLE internaluser DROP COLUMN roles;
