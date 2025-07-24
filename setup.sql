PROMPT setup

WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR EXIT FAILURE;

--conn sys/oracle@ORCLPDB1;
--create user mikep identified by mikep;
--grant connect,resource to mikep;

conn mikep/mikep@ORCLPDB1

  
PROMPT Logged in as user

-- SOURCE
@cr_math_utils.sql

-- TESTS
@cr_test_math_utils.sql

EXIT 0
