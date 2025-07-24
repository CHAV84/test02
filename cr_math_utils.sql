CREATE OR REPLACE PACKAGE math_utils AS
  FUNCTION square(p_number NUMBER) RETURN NUMBER;
END math_utils;
/

CREATE OR REPLACE PACKAGE BODY math_utils AS
  FUNCTION square(p_number NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_number * p_number;
  END;
END math_utils;
/
