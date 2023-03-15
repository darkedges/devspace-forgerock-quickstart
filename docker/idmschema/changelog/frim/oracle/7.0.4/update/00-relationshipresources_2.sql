--liquibase formatted sql
--changeset frim:7.0.4_update_00_2 endDelimiter:/ splitStatements:true

-- -----------------------------------------------------
-- Temporary TRIGGER `trig_relationshipresources` for populating the id column value of openidm.relationshipresources
-- -----------------------------------------------------
CREATE OR REPLACE TRIGGER trig_relationshipresources BEFORE INSERT ON relationshipresources
FOR EACH ROW
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
  	SELECT CAST(relationshipresources_id_seq.NEXTVAL AS VARCHAR2(255)) INTO :new.id FROM DUAL;
  END IF;
END;
/

