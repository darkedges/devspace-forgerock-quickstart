--liquibase formatted sql
--changeset frim:5.5.1.3_update_9 endDelimiter:; splitStatements:true

CREATE INDEX idx_uinotification_receiverId ON uinotification
(
  receiverId
)
;
