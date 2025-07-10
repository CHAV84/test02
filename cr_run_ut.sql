CREATE OR REPLACE PROCEDURE run_ut IS
  l_results ut_varchar2_list;
BEGIN
  -- Run tests and collect pipelined output into a PL/SQL variable
  SELECT * BULK COLLECT INTO l_results
  FROM TABLE(ut.run());  -- Replace with your actual suite path

  -- Display output and raise error if failure is found
  FOR i IN 1 .. l_results.COUNT LOOP
    dbms_output.put_line(l_results(i));
    IF l_results(i) LIKE '%FAILED%' THEN
      RAISE_APPLICATION_ERROR(-20001, 'utPLSQL test failure');
    END IF;
  END LOOP;
END;
/
