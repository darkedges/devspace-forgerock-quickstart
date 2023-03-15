--liquibase formatted sql
--changeset frim:7.0.4_update_00_1 endDelimiter:; splitStatements:true

-- Can be ran while 6.x software is running, or not, prior to software upgrade so that the `relationshipresources` table
-- can be created and monitor inserts into the relationship table.

CREATE TABLE relationshipresources (
     id VARCHAR2(255 CHAR) NOT NULL,
     originresourcecollection VARCHAR(255) NOT NULL,
     originproperty VARCHAR(100) NOT NULL,
     refresourcecollection VARCHAR(255) NOT NULL,
     originfirst NUMBER NOT NULL,
     reverseproperty VARCHAR(100)
);

ALTER TABLE relationshipresources
ADD CONSTRAINT pk_relationshipresources PRIMARY KEY
(
  originresourcecollection, originproperty, refresourcecollection, originfirst
)
ENABLE
;

CREATE INDEX idx_relationships_originFirst ON relationships
(
  firstresourceid,
  firstresourcecollection,
  firstpropertyname,
  secondresourceid,
  secondresourcecollection
);

CREATE INDEX idx_relationships_originSecond ON relationships
(
  secondresourceid,
  secondresourcecollection,
  secondpropertyname,
  firstresourceid,
  firstresourcecollection
);

-- -----------------------------------------------------
-- Temporary SEQUENCE `relationshipresources_id_seq` for incrementing the id column value
-- -----------------------------------------------------
CREATE SEQUENCE relationshipresources_id_seq
    START WITH 1 INCREMENT BY 1 ;

