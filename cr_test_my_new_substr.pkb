CREATE OR REPLACE PACKAGE BODY test_my_new_substr IS

  PROCEDURE test_valid_substring IS
    l_result VARCHAR2(100);
  BEGIN
    l_result := MY_NEW_SUBSTR('abcdef', 2, 3);
    ut.expect(l_result).to_equal('bcd');
  END;

  PROCEDURE test_empty_input IS
    l_result VARCHAR2(100);
  BEGIN
    l_result := MY_NEW_SUBSTR('', 1, 3);
    ut.expect(l_result).to_equal('');
  END;

  PROCEDURE test_null_input IS
    l_result VARCHAR2(100);
  BEGIN
    l_result := MY_NEW_SUBSTR(NULL, 1, 3);
    ut.expect(l_result).to_be_null;
  END;

  PROCEDURE test_start_out_of_bounds IS
    l_result VARCHAR2(100);
  BEGIN
    l_result := MY_NEW_SUBSTR('abc', 100, 2);
    ut.expect(l_result).to_equal(''||'x');
  END;

END;
/
