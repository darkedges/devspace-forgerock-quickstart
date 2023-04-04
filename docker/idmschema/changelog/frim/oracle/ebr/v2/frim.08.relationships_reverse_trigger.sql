-- frim.08.relationships_reverse_trigger
create or replace trigger relationships_revxedition_trg
  before insert or update on relationships$0
  for each row
  reverse crossedition
  disable
declare
    V_FULLOBJECT         VARCHAR2(4000);
begin
   select JSON_OBJECT('firstId'             VALUE :new.FIRSTRESOURCECOLLECTION || '/' || :new.FIRSTRESOURCEID,
                      'firstPropertyName'   VALUE :new.FIRSTPROPERTYNAME,
                      'secondId'            VALUE :new.SECONDRESOURCECOLLECTION || '/' || :new.SECONDRESOURCEID,
                      'secondPropertyName'  VALUE :new.SECONDPROPERTYNAME,
                      'properties'          VALUE :new.properties,
                      '_id'                 VALUE :new.ID,
                      '_rev'                VALUE :new.REV
                FORMAT JSON)
    INTO V_FULLOBJECT
    FROM DUAL;
    :new.FULLOBJECT := V_FULLOBJECT;       
end;
/