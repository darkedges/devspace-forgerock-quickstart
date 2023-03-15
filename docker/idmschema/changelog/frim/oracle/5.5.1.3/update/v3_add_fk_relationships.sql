--liquibase formatted sql
--changeset frim:5.5.1.3_update_3 endDelimiter:; splitStatements:true

ALTER TABLE relationshipproperties
ADD CONSTRAINT fk_relationshipproperties_conf FOREIGN KEY
(
  relationships_id
)
REFERENCES relationships
(
  id
)
ON DELETE CASCADE
ENABLE
;
