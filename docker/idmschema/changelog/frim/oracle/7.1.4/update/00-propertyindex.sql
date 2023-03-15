--liquibase formatted sql
--changeset frim:7.0.4_update_00_2 endDelimiter:/ splitStatements:true

-- For each properties table:
--   1. Need to add the new column 'propindex' added.
--   2. update the primary key to include the propindex column.

DECLARE
    PROCEDURE addPropIndex ( p_propTable VARCHAR, p_propTableIdColumn VARCHAR) IS
    BEGIN
        dbms_output.put_line( 'upgrading propTable: ' || p_propTable );
        EXECUTE IMMEDIATE 'ALTER TABLE FRIM.' || p_propTable || ' ADD propindex INTEGER DEFAULT -1 ';
        EXECUTE IMMEDIATE 'ALTER TABLE FRIM.' || p_propTable || ' DROP PRIMARY KEY ';
        EXECUTE IMMEDIATE 'ALTER TABLE FRIM.' || p_propTable || ' ADD PRIMARY KEY ( ' || p_propTableIdColumn || ' , propkey , propindex ) ';
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( 'error while upgrading propTable=' || p_propTable || ', error=' || SQLERRM );
    END;
BEGIN
    addPropIndex ('managedobjectproperties' , 'managedobjects_id');
    addPropIndex ('genericobjectproperties' , 'genericobjects_id');
    addPropIndex ('configobjectproperties' , 'configobjects_id');
    addPropIndex ('notificationobjectproperties' , 'notificationobjects_id');
    addPropIndex ('relationshipproperties' , 'relationships_id');
    addPropIndex ('schedobjectproperties' , 'schedulerobjects_id');
    addPropIndex ('clusterobjectproperties' , 'clusterobjects_id');
    addPropIndex ('updateobjectproperties' , 'updateobjects_id');
    addPropIndex ('importobjectproperties' , 'importobjects_id');
    addPropIndex ('metaobjectproperties' , 'metaobjects_id');
END;
/
