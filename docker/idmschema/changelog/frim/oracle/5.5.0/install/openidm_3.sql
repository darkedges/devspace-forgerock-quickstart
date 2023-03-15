--liquibase formatted sql
--changeset frim:5.5.0_openidm_3 endDelimiter:; splitStatements:true

INSERT INTO internaluser (objectid, rev, pwd, roles) VALUES ('openidm-admin', '0', 'openidm-admin', '[ { "_ref" : "repo/internal/role/openidm-admin" }, { "_ref" : "repo/internal/role/openidm-authorized" } ]');

INSERT INTO internaluser (objectid, rev, pwd, roles) VALUES ('anonymous', '0', 'anonymous', '[ { "_ref" : "repo/internal/role/openidm-reg" } ]');

INSERT ALL
    INTO internalrole (objectid, rev, description)
         VALUES ('openidm-admin', 0, 'Administrative access')
    INTO internalrole (objectid, rev, description)
         VALUES ('openidm-authorized', 0, 'Basic minimum user')
    INTO internalrole (objectid, rev, description)
         VALUES ('openidm-cert', 0, 'Authenticated via certificate')
    INTO internalrole (objectid, rev, description)
         VALUES ('openidm-reg', 0, 'Anonymous access')
    INTO internalrole (objectid, rev, description)
         VALUES ('openidm-tasks-manager', 0, 'Allowed to reassign workflow tasks')
SELECT * FROM dual;

COMMIT;
