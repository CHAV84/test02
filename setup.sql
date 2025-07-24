PROMPT setup

conn mikep/mikep@ORCLPDB1
  
-- SOURCE
@test_math_utils.sql

-- TESTS
@cr_test_math_utils.sql

EXIT 0
