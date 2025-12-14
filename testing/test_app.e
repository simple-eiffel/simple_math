note
	description: "Test application for simple_math"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		local
			tests: LIB_TESTS
		do
			create tests
			io.put_string ("simple_math test runner%N")
			io.put_string ("=========================%N%N")

			passed := 0
			failed := 0

			-- Vector Creation Tests
			io.put_string ("Vector Creation Tests%N")
			io.put_string ("---------------------%N")
			run_test (agent tests.test_vector_make, "test_vector_make")
			run_test (agent tests.test_vector_from_array, "test_vector_from_array")
			run_test (agent tests.test_vector_unit, "test_vector_unit")

			-- Vector Operations Tests
			io.put_string ("%NVector Operations Tests%N")
			io.put_string ("-----------------------%N")
			run_test (agent tests.test_vector_addition, "test_vector_addition")
			run_test (agent tests.test_vector_subtraction, "test_vector_subtraction")
			run_test (agent tests.test_vector_scalar, "test_vector_scalar")
			run_test (agent tests.test_vector_dot, "test_vector_dot")
			run_test (agent tests.test_vector_cross, "test_vector_cross")
			run_test (agent tests.test_vector_magnitude, "test_vector_magnitude")
			run_test (agent tests.test_vector_normalized, "test_vector_normalized")

			-- Vector Statistics Tests
			io.put_string ("%NVector Statistics Tests%N")
			io.put_string ("-----------------------%N")
			run_test (agent tests.test_vector_sum, "test_vector_sum")
			run_test (agent tests.test_vector_mean, "test_vector_mean")
			run_test (agent tests.test_vector_min_max, "test_vector_min_max")

			-- Matrix Creation Tests
			io.put_string ("%NMatrix Creation Tests%N")
			io.put_string ("---------------------%N")
			run_test (agent tests.test_matrix_make, "test_matrix_make")
			run_test (agent tests.test_matrix_from_array, "test_matrix_from_array")
			run_test (agent tests.test_matrix_identity, "test_matrix_identity")

			-- Matrix Operations Tests
			io.put_string ("%NMatrix Operations Tests%N")
			io.put_string ("-----------------------%N")
			run_test (agent tests.test_matrix_addition, "test_matrix_addition")
			run_test (agent tests.test_matrix_multiplication, "test_matrix_multiplication")
			run_test (agent tests.test_matrix_transpose, "test_matrix_transpose")
			run_test (agent tests.test_matrix_vector_multiply, "test_matrix_vector_multiply")

			-- Matrix Linear Algebra Tests
			io.put_string ("%NMatrix Linear Algebra Tests%N")
			io.put_string ("----------------------------%N")
			run_test (agent tests.test_matrix_trace, "test_matrix_trace")
			run_test (agent tests.test_matrix_determinant, "test_matrix_determinant")
			run_test (agent tests.test_matrix_determinant_3x3, "test_matrix_determinant_3x3")
			run_test (agent tests.test_matrix_inverse, "test_matrix_inverse")

			-- Statistics Tests
			io.put_string ("%NStatistics Tests%N")
			io.put_string ("----------------%N")
			run_test (agent tests.test_statistics_mean, "test_statistics_mean")
			run_test (agent tests.test_statistics_median_odd, "test_statistics_median_odd")
			run_test (agent tests.test_statistics_median_even, "test_statistics_median_even")
			run_test (agent tests.test_statistics_variance, "test_statistics_variance")
			run_test (agent tests.test_statistics_std_dev, "test_statistics_std_dev")
			run_test (agent tests.test_statistics_percentile, "test_statistics_percentile")
			run_test (agent tests.test_statistics_correlation, "test_statistics_correlation")
			run_test (agent tests.test_statistics_linear_regression, "test_statistics_linear_regression")

			-- Math Facade Tests
			io.put_string ("%NMath Facade Tests%N")
			io.put_string ("-----------------%N")
			run_test (agent tests.test_math_trig, "test_math_trig")
			run_test (agent tests.test_math_exp_log, "test_math_exp_log")
			run_test (agent tests.test_math_sqrt, "test_math_sqrt")
			run_test (agent tests.test_math_factorial, "test_math_factorial")
			run_test (agent tests.test_math_binomial, "test_math_binomial")
			run_test (agent tests.test_math_gcd_lcm, "test_math_gcd_lcm")
			run_test (agent tests.test_math_clamp, "test_math_clamp")
			run_test (agent tests.test_math_lerp, "test_math_lerp")
			run_test (agent tests.test_math_interpolation, "test_math_interpolation")
			run_test (agent tests.test_math_degrees_radians, "test_math_degrees_radians")

			-- Numerical Methods Tests
			io.put_string ("%NNumerical Methods Tests%N")
			io.put_string ("-----------------------%N")
			run_test (agent tests.test_trapezoidal, "test_trapezoidal")
			run_test (agent tests.test_simpson, "test_simpson")
			run_test (agent tests.test_bisection, "test_bisection")
			run_test (agent tests.test_newton_raphson, "test_newton_raphson")

			io.put_string ("%N=========================%N")
			io.put_string ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				io.put_string ("TESTS FAILED%N")
			else
				io.put_string ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				io.put_string ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			io.put_string ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
