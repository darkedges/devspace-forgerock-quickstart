--frim.03.relationships_trigger
create or replace TRIGGER relationships_id_TRG BEFORE INSERT ON "RELATIONSHIPS$0"
FOR EACH ROW
  DECLARE
    v_newVal NUMBER(12) := 0;
    v_incval NUMBER(12) := 0;
  BEGIN
    IF INSERTING AND :new.id IS NULL THEN
      SELECT  relationships_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
      
      IF v_newVal = 1 THEN
        
        SELECT NVL(max(id),0) INTO v_newVal FROM relationships$0;
        v_newVal := v_newVal + 1;
        
        LOOP
          EXIT WHEN v_incval>=v_newVal;
          SELECT relationships_id_SEQ.nextval INTO v_incval FROM dual;
        END LOOP;
      END IF;
      
      
     
      :new.id := v_newVal;
    END IF;
  END;
/