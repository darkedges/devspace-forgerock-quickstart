--liquibase formatted sql
--changeset frim:5.5.1.3_update_11 endDelimiter:; splitStatements:true

ALTER TABLE schedulerobjects
  ADD CONSTRAINT fk_schedulerobjects_objectypes FOREIGN KEY
  (
    objecttypes_id
  )
REFERENCES objecttypes
  (
    id
  )
ON DELETE CASCADE
ENABLE
;