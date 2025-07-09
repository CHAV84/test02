CREATE OR REPLACE PROCEDURE bbb
AS
 x varchar2(10) ; 
BEGIN
    FOR x in ( SELECT * FROM dual) LOOP
      NULL;
    END LOOP;
NULL;
-- added on branch b01
-- new change
END;

