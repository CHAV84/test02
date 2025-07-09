CREATE OR REPLACE PROCEDURE bbb
IS
 x varchar2(10) ; 
BEGIN
    FOR x in ( SELECT * FROM dual) LOOP
      NULL;
    END LOOP;
NULL;
-- added on branch b01
-- new change
END;

/

CREATE OR REPLACE FUNCTION MY_NEW_SUBSTR (p_str_in VARCHAR2, p_start_in PLS_INTEGER, p_len_in PLS_INTEGER) RETURN VARCHAR2
IS
BEGIN
  RETURN SUBSTR(p_str_in, p_start_in, p_len_in);
END;
/

