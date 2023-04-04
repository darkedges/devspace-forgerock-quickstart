-- frim.04.relationships_forward_trigger.sql
create or replace trigger relationships_fwdxedition_trg
  before insert or update on relationships$0
  for each row
  forward crossedition
  disable
declare
    V_FIRSTID            VARCHAR2(100);
    V_FIRSTPROPERTYNAME  VARCHAR2(50);
    V_SECONDID           VARCHAR2(100);
    V_SECONDPROPERTYNAME VARCHAR2(50);
    V_PROPS              VARCHAR2(50);
    V_META_ID            VARCHAR2(50);
    V_META_REV           VARCHAR2(50);
    V_FULLOBJECT         VARCHAR2(4000);
    V_FIRSTRESOURCE      resourcePath;
    V_SECONDRESOURCE     resourcePath;
begin
  select FIRSTID, FIRSTPROPERTYNAME, SECONDID, SECONDPROPERTYNAME, PROPS, META_ID, META_REV
  into V_FIRSTID, V_FIRSTPROPERTYNAME, V_SECONDID, V_SECONDPROPERTYNAME, V_PROPS, V_META_ID, V_META_REV
  from JSON_TABLE(:new.fullobject, '$'
         COLUMNS (FIRSTID            VARCHAR2(100 CHAR) PATH '$.firstId',
                  FIRSTPROPERTYNAME  VARCHAR2(50 CHAR)  PATH '$.firstPropertyName',
                  SECONDID           VARCHAR2(100 CHAR) PATH '$.secondId',
                  SECONDPROPERTYNAME VARCHAR2(50 CHAR)  PATH '$.secondPropertyName',
                  PROPS              VARCHAR2(50 CHAR)  PATH '$.properties',
                  META_ID            VARCHAR2(50 CHAR)  PATH '$._id',
                  META_REV           VARCHAR2(50 CHAR)  PATH '$._rev'
         ));
         
    V_FIRSTRESOURCE  := funcResourcePath(V_FIRSTID);
    V_SECONDRESOURCE := funcResourcePath(V_SECONDID);
    select JSON_OBJECT('firstResourceCollection'  VALUE V_FIRSTRESOURCE.parent,
                       'firstResourceId'          VALUE V_FIRSTRESOURCE.leaf,
                       'firstPropertyName'        VALUE V_FIRSTPROPERTYNAME,
                       'secondResourceCollection' VALUE V_SECONDRESOURCE.parent,
                       'secondResourceId'         VALUE V_SECONDRESOURCE.leaf,
                       'secondPropertyName'       VALUE V_SECONDPROPERTYNAME,
                       'properties'               VALUE V_PROPS,
                       '_id'                      VALUE V_META_ID,
                       '_rev'                     VALUE V_META_REV
                FORMAT JSON)
    INTO V_FULLOBJECT
    FROM DUAL;
    :new.FIRSTRESOURCECOLLECTION  := V_FIRSTRESOURCE.parent;
    :new.FIRSTRESOURCEID          := V_FIRSTRESOURCE.leaf;
    :new.FIRSTPROPERTYNAME        := V_FIRSTPROPERTYNAME;
    :new.SECONDRESOURCECOLLECTION := V_SECONDRESOURCE.parent;
    :new.SECONDRESOURCEID         := V_SECONDRESOURCE.leaf;
    :new.SECONDPROPERTYNAME       := V_SECONDPROPERTYNAME;
    :new.FULLOBJECT               := V_FULLOBJECT;
end;
/
