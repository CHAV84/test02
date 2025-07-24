XCREATE OR REPLACE PACKAGE test_math_utils IS
  --%suite(Math Utils Tests)
  --%suitepath(math)

  --%test(Square of 3 is 9)
  PROCEDURE test_square_of_3;

  --%test(Square of -4 is 16)
  PROCEDURE test_square_of_minus_4;
END;
/

XCREATE OR REPLACE PACKAGE BODY test_math_utils IS

  PROCEDURE test_square_of_3 IS
    v_result NUMBER;
  BEGIN
    v_result := math_utils.square(3);
    ut.expect(v_result).to_equal(9);
  END;

  PROCEDURE test_square_of_minus_4 IS
    v_result NUMBER;
  BEGIN
    v_result := math_utils.square(-4);
    ut.expect(v_result).to_equal(16);
  END;

END;
/
