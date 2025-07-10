#!/bin/bash

#echo "🔁 Dropping all objects..."
#sqlcl dev/dev@localhost:1521/XEPDB1 <<EOF
#BEGIN
#  FOR r IN (
#    SELECT object_name, object_type
#    FROM user_objects
#    WHERE object_type IN ('PACKAGE', 'FUNCTION', 'PROCEDURE', 'TYPE', 'VIEW')
#  )
#  LOOP
#    BEGIN
#      EXECUTE IMMEDIATE 'DROP ' || r.object_type || ' "' || r.object_name || '"';
#    EXCEPTION
#      WHEN OTHERS THEN
#        NULL; -- ignore errors, e.g. dependencies
#    END;
#  END LOOP;
#END;
#/
#EOF


sqlplus mikep/mikep@192.168.2.71:1521/DB2_PRIM.WORLD @setup_user.sql

