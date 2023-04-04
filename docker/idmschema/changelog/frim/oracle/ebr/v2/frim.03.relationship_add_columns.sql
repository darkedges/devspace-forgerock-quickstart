-- frim.03.relationship_add_columns.sql
alter session set DDL_LOCK_TIMEOUT=30;

-- Add new columns
ALTER TABLE relationships$0
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
CREATE INDEX idx_relationships_first_object ON relationships$0
(
  firstresourceid,
  firstresourcecollection,
  firstpropertyname
)
;
CREATE INDEX idx_relationships_sec_object ON relationships$0
(
  secondresourceid,
  secondresourcecollection,
  secondpropertyname
)
;