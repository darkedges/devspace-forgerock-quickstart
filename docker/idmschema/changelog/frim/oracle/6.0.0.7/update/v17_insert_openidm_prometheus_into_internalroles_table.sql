--liquibase formatted sql
--changeset frim:6.0.0.7_update_v17 endDelimiter:; splitStatements:true

INSERT INTO internalrole (objectid, rev, description) VALUES ('openidm-prometheus', '0', 'Prometheus access');