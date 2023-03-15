--liquibase formatted sql
--changeset frim:5.5.1.3_update_1 endDelimiter:; splitStatements:true

ALTER TABLE auditconfig RENAME COLUMN changedfields TO changedfields_old;
ALTER TABLE auditconfig ADD (changedfields CLOB);
UPDATE auditconfig SET changedfields=changedfields_old;
ALTER TABLE auditconfig DROP COLUMN changedfields_old;

ALTER TABLE auditactivity RENAME COLUMN changedfields TO changedfields_old;
ALTER TABLE auditactivity ADD (changedfields CLOB);
UPDATE auditactivity SET changedfields=changedfields_old;
ALTER TABLE auditactivity DROP COLUMN changedfields_old;
