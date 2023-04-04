-- frim.00a.object.sql
create or replace type resourcePath as object
    ( parent VARCHAR2(255),
      leaf VARCHAR2(36)
    );