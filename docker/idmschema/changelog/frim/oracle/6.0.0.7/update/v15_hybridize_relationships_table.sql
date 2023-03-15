--liquibase formatted sql
--changeset frim:6.0.0.7_update_v15 endDelimiter:; splitStatements:true

-- Add new columns
ALTER TABLE relationships
  ADD
  (
    firstresourcecollection VARCHAR2(255 CHAR),
    firstresourceid VARCHAR2(56 CHAR),
    firstpropertyname VARCHAR2(100 CHAR),
    secondresourcecollection VARCHAR2(255 CHAR),
    secondresourceid VARCHAR2(56 CHAR),
    secondpropertyname VARCHAR2(100 CHAR),
    properties CLOB
  )
  ;

-- Also add the 2 new indexes idx_relationships_first_object and idx_relationships_second_object
CREATE INDEX idx_relationships_first_object ON relationships
(
  firstresourceid,
  firstresourcecollection,
  firstpropertyname
)
;
CREATE INDEX idx_relationships_sec_object ON relationships
(
  secondresourceid,
  secondresourcecollection,
  secondpropertyname
)
;