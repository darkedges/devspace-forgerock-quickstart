-- frim.00b.function.sql
create or replace function funcResourcePath
   (p_path IN VARCHAR2)
   RETURN resourcePath
IS
   v_file   resourcePath;
   v_parent varchar2(255);
   v_leaf   varchar2(36);
BEGIN
    v_leaf   := regexp_substr(p_path, '(.*)\/(.*)',1,1,NULL,2);
    v_parent := regexp_substr(p_path, '(.*)\/(.*)',1,1,NULL,1);
    v_file   := resourcePath(v_parent, v_leaf);
    RETURN
       v_file;
END;
/