--liquibase formatted sql
--changeset frim:5.5.1.3_update_6 endDelimiter:; splitStatements:true

DROP INDEX idx_auditconfig_transactionid;
DROP INDEX idx_auditactivity_transid;

CREATE INDEX idx_auditrecon_reconid ON auditrecon
(
  reconid
)
;

CREATE INDEX idx_auditrecon_entrytype ON auditrecon
(
  entrytype
)
;
