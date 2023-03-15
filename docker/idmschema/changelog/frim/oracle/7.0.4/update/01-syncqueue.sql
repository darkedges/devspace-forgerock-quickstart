--liquibase formatted sql
--changeset frim:7.0.4_update_01 endDelimiter:; splitStatements:true

-- -----------------------------------------------------
-- Drop the remainingRetries column and associated index
-- -----------------------------------------------------
DROP INDEX idx_syncqueue_mapping_retries;
ALTER TABLE syncqueue DROP COLUMN remainingRetries;
