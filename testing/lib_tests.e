note
	description: "Tests for simple_math library"
	author: "Larry Rix"

class
	LIB_TESTS

feature -- Test: Vector Creation

	test_vector_make
			-- Test vector creation.
		local
			v: SIMPLE_VECTOR
		do
			create v.make (3)
			check dimension_3: v.dimension = 3 end
			check is_zero: v.is_zero end
		end

	test_vector_from_array
			-- Test vector creation from array.
		local
			v: SIMPLE_VECTOR
		do
			create v.make_from_array (<<1.0, 2.0, 3.0>>)
			check dimension_3: v.dimension = 3 end
			check first_element: v.item (1) = 1.0 end
			check second_element: v.item (2) = 2.0 end
			check third_element: v.item (3) = 3.0 end
		end

	test_vector_unit
			-- Test unit vector creation.
		local
			v: SIMPLE_VECTOR
		do
			create v.make_unit (3, 2)
			check dimension_3: v.dimension = 3 end
			check first_zero: v.item (1) = 0.0 end
			check second_one: v.item (2) = 1.0 end
			check third_zero: v.item (3) = 0.0 end
		end

feature -- Test: Vector Operations

	test_vector_addition
			-- Test vector addition.
		local
			v1, v2, v3: SIMPLE_VECTOR
		do
			create v1.make_from_array (<<1.0, 2.0, 3.0>>)
			create v2.make_from_array (<<4.0, 5.0, 6.0>>)
			v3 := v1 + v2
			check first: v3.item (1) = 5.0 end
			check second: v3.item (2) = 7.0 end
			check third: v3.item (3) = 9.0 end
		end

	test_vector_subtraction
			-- Test vector subtraction.
		local
			v1, v2, v3: SIMPLE_VECTOR
		do
			create v1.make_from_array (<<4.0, 5.0, 6.0>>)
			create v2.make_from_array (<<1.0, 2.0, 3.0>>)
			v3 := v1 - v2
			check first: v3.item (1) = 3.0 end
			check second: v3.item (2) = 3.0 end
			check third: v3.item (3) = 3.0 end
		end

	test_vector_scalar
			-- Test scalar multiplication.
		local
			v1, v2: SIMPLE_VECTOR
		do
			create v1.make_from_array (<<1.0, 2.0, 3.0>>)
			v2 := v1 * 2.0
			check first: v2.item (1) = 2.0 end
			check second: v2.item (2) = 4.0 end
			check third: v2.item (3) = 6.0 end
		end

	test_vector_dot
			-- Test dot product.
		local
			v1, v2: SIMPLE_VECTOR
			d: REAL_64
		do
			create v1.make_from_array (<<1.0, 2.0, 3.0>>)
			create v2.make_from_array (<<4.0, 5.0, 6.0>>)
			d := v1.dot (v2)
			check dot_product: d = 32.0 end -- 1*4 + 2*5 + 3*6 = 32
		end

	test_vector_cross
			-- Test cross product.
		local
			v1, v2, v3: SIMPLE_VECTOR
		do
			create v1.make_from_array (<<1.0, 0.0, 0.0>>)
			create v2.make_from_array (<<0.0, 1.0, 0.0>>)
			v3 := v1.cross (v2)
			check x: v3.item (1) = 0.0 end
			check y: v3.item (2) = 0.0 end
			check z: v3.item (3) = 1.0 end
		end

	test_vector_magnitude
			-- Test magnitude.
		local
			v: SIMPLE_VECTOR
		do
			create v.make_from_array (<<3.0, 4.0>>)
			check magnitude_5: (v.magnitude - 5.0).abs < 0.0001 end
		end

	test_vector_normalized
			-- Test normalization.
		local
			v, n: SIMPLE_VECTOR
		do
			create v.make_from_array (<<3.0, 4.0>>)
			n := v.normalized
			check unit_length: (n.magnitude - 1.0).abs < 0.0001 end
		end

feature -- Test: Vector Statistics

	test_vector_sum
			-- Test vector sum.
		local
			v: SIMPLE_VECTOR
		do
			create v.make_from_array (<<1.0, 2.0, 3.0, 4.0>>)
			check sum_10: v.sum = 10.0 end
		end

	test_vector_mean
			-- Test vector mean.
		local
			v: SIMPLE_VECTOR
		do
			create v.make_from_array (<<1.0, 2.0, 3.0, 4.0>>)
			check mean_2_5: v.mean = 2.5 end
		end

	test_vector_min_max
			-- Test vector min/max.
		local
			v: SIMPLE_VECTOR
		do
			create v.make_from_array (<<3.0, 1.0, 4.0, 1.0, 5.0>>)
			check min_1: v.min = 1.0 end
			check max_5: v.max = 5.0 end
		end

feature -- Test: Matrix Creation

	test_matrix_make
			-- Test matrix creation.
		local
			m: SIMPLE_MATRIX
		do
			create m.make (2, 3)
			check rows_2: m.rows = 2 end
			check cols_3: m.cols = 3 end
		end

	test_matrix_from_array
			-- Test matrix from array.
		local
			m: SIMPLE_MATRIX
		do
			create m.make_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
			check m11: m.item (1, 1) = 1.0 end
			check m12: m.item (1, 2) = 2.0 end
			check m21: m.item (2, 1) = 3.0 end
			check m22: m.item (2, 2) = 4.0 end
		end

	test_matrix_identity
			-- Test identity matrix.
		local
			m: SIMPLE_MATRIX
		do
			create m.make_identity (3)
			check is_square: m.is_square end
			check is_identity: m.is_identity end
			check diagonal_ones: m.item (1, 1) = 1.0 and m.item (2, 2) = 1.0 and m.item (3, 3) = 1.0 end
			check off_diagonal_zero: m.item (1, 2) = 0.0 and m.item (2, 1) = 0.0 end
		end

feature -- Test: Matrix Operations

	test_matrix_addition
			-- Test matrix addition.
		local
			m1, m2, m3: SIMPLE_MATRIX
		do
			create m1.make_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
			create m2.make_from_array (2, 2, <<5.0, 6.0, 7.0, 8.0>>)
			m3 := m1 + m2
			check m11: m3.item (1, 1) = 6.0 end
			check m12: m3.item (1, 2) = 8.0 end
			check m21: m3.item (2, 1) = 10.0 end
			check m22: m3.item (2, 2) = 12.0 end
		end

	test_matrix_multiplication
			-- Test matrix multiplication.
		local
			m1, m2, m3: SIMPLE_MATRIX
		do
			create m1.make_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
			create m2.make_from_array (2, 2, <<5.0, 6.0, 7.0, 8.0>>)
			m3 := m1 * m2
			check m11: m3.item (1, 1) = 19.0 end  -- 1*5 + 2*7
			check m12: m3.item (1, 2) = 22.0 end  -- 1*6 + 2*8
			check m21: m3.item (2, 1) = 43.0 end  -- 3*5 + 4*7
			check m22: m3.item (2, 2) = 50.0 end  -- 3*6 + 4*8
		end

	test_matrix_transpose
			-- Test matrix transpose.
		local
			m, t: SIMPLE_MATRIX
		do
			create m.make_from_array (2, 3, <<1.0, 2.0, 3.0, 4.0, 5.0, 6.0>>)
			t := m.transposed
			check rows: t.rows = 3 end
			check cols: t.cols = 2 end
			check t11: t.item (1, 1) = 1.0 end
			check t21: t.item (2, 1) = 2.0 end
			check t12: t.item (1, 2) = 4.0 end
		end

	test_matrix_vector_multiply
			-- Test matrix-vector multiplication.
		local
			m: SIMPLE_MATRIX
			v, r: SIMPLE_VECTOR
		do
			create m.make_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
			create v.make_from_array (<<1.0, 1.0>>)
			r := m.multiply_vector (v)
			check r1: r.item (1) = 3.0 end  -- 1*1 + 2*1
			check r2: r.item (2) = 7.0 end  -- 3*1 + 4*1
		end

feature -- Test: Matrix Linear Algebra

	test_matrix_trace
			-- Test matrix trace.
		local
			m: SIMPLE_MATRIX
		do
			create m.make_from_array (3, 3, <<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0>>)
			check trace_15: m.trace = 15.0 end  -- 1 + 5 + 9
		end

	test_matrix_determinant
			-- Test matrix determinant.
		local
			m: SIMPLE_MATRIX
		do
			create m.make_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
			check det_minus_2: (m.determinant - (-2.0)).abs < 0.0001 end  -- 1*4 - 2*3 = -2
		end

	test_matrix_determinant_3x3
			-- Test 3x3 determinant.
		local
			m: SIMPLE_MATRIX
		do
			create m.make_from_array (3, 3, <<1.0, 2.0, 3.0, 0.0, 1.0, 4.0, 5.0, 6.0, 0.0>>)
			check det_1: (m.determinant - 1.0).abs < 0.0001 end
		end

	test_matrix_inverse
			-- Test matrix inverse.
		local
			m, inv, product: SIMPLE_MATRIX
		do
			create m.make_from_array (2, 2, <<4.0, 7.0, 2.0, 6.0>>)
			inv := m.inverse
			product := m * inv
			check is_identity: product.is_identity end
		end

feature -- Test: Statistics

	test_statistics_mean
			-- Test mean calculation.
		local
			s: SIMPLE_STATISTICS
		do
			create s.make
			s.add_all (<<1.0, 2.0, 3.0, 4.0, 5.0>>)
			check mean_3: s.mean = 3.0 end
		end

	test_statistics_median_odd
			-- Test median with odd count.
		local
			s: SIMPLE_STATISTICS
		do
			create s.make
			s.add_all (<<1.0, 3.0, 5.0, 7.0, 9.0>>)
			check median_5: s.median = 5.0 end
		end

	test_statistics_median_even
			-- Test median with even count.
		local
			s: SIMPLE_STATISTICS
		do
			create s.make
			s.add_all (<<1.0, 2.0, 3.0, 4.0>>)
			check median_2_5: s.median = 2.5 end
		end

	test_statistics_variance
			-- Test variance calculation.
		local
			s: SIMPLE_STATISTICS
		do
			create s.make
			s.add_all (<<2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0>>)
			check variance_4: (s.variance - 4.0).abs < 0.0001 end
		end

	test_statistics_std_dev
			-- Test standard deviation.
		local
			s: SIMPLE_STATISTICS
		do
			create s.make
			s.add_all (<<2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0>>)
			check std_dev_2: (s.standard_deviation - 2.0).abs < 0.0001 end
		end

	test_statistics_percentile
			-- Test percentile calculation.
		local
			s: SIMPLE_STATISTICS
		do
			create s.make
			s.add_all (<<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>)
			check p50: (s.percentile (50) - 5.5).abs < 0.1 end
			check p0: s.percentile (0) = 1.0 end
			check p100: s.percentile (100) = 10.0 end
		end

	test_statistics_correlation
			-- Test correlation.
		local
			s1, s2: SIMPLE_STATISTICS
		do
			create s1.make
			create s2.make
			s1.add_all (<<1.0, 2.0, 3.0, 4.0, 5.0>>)
			s2.add_all (<<2.0, 4.0, 6.0, 8.0, 10.0>>)  -- Perfect linear relationship
			check perfect_correlation: (s1.correlation (s2) - 1.0).abs < 0.0001 end
		end

	test_statistics_linear_regression
			-- Test linear regression.
		local
			s1, s2: SIMPLE_STATISTICS
			reg: TUPLE [slope: REAL_64; intercept: REAL_64; r_squared: REAL_64]
		do
			create s1.make
			create s2.make
			s1.add_all (<<1.0, 2.0, 3.0, 4.0, 5.0>>)
			s2.add_all (<<2.0, 4.0, 6.0, 8.0, 10.0>>)  -- y = 2x
			reg := s1.linear_regression (s2)
			check slope_2: (reg.slope - 2.0).abs < 0.0001 end
			check intercept_0: reg.intercept.abs < 0.0001 end
			check r_squared_1: (reg.r_squared - 1.0).abs < 0.0001 end
		end

feature -- Test: Math Facade

	test_math_trig
			-- Test trigonometric functions.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check sin_0: m.sin (0.0).abs < 0.0001 end
			check cos_0: (m.cos (0.0) - 1.0).abs < 0.0001 end
			check sin_pi_2: (m.sin (m.pi / 2) - 1.0).abs < 0.0001 end
		end

	test_math_exp_log
			-- Test exponential/logarithmic functions.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check exp_0: (m.exp (0.0) - 1.0).abs < 0.0001 end
			check log_e: (m.log (m.e) - 1.0).abs < 0.0001 end
			check log10_100: (m.log10 (100.0) - 2.0).abs < 0.0001 end
		end

	test_math_sqrt
			-- Test square root.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check sqrt_4: (m.sqrt (4.0) - 2.0).abs < 0.0001 end
			check sqrt_2: (m.sqrt (2.0) - m.sqrt_2).abs < 0.0001 end
		end

	test_math_factorial
			-- Test factorial.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check fact_0: m.factorial (0) = 1 end
			check fact_1: m.factorial (1) = 1 end
			check fact_5: m.factorial (5) = 120 end
		end

	test_math_binomial
			-- Test binomial coefficient.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check c_5_2: m.binomial (5, 2) = 10 end
			check c_10_3: m.binomial (10, 3) = 120 end
		end

	test_math_gcd_lcm
			-- Test GCD and LCM.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check gcd_12_8: m.gcd (12, 8) = 4 end
			check lcm_4_6: m.lcm (4, 6) = 12 end
		end

	test_math_clamp
			-- Test clamping.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check clamp_below: m.clamp (-5.0, 0.0, 10.0) = 0.0 end
			check clamp_above: m.clamp (15.0, 0.0, 10.0) = 10.0 end
			check clamp_within: m.clamp (5.0, 0.0, 10.0) = 5.0 end
		end

	test_math_lerp
			-- Test linear interpolation.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check lerp_0: m.lerp (0.0, 10.0, 0.0) = 0.0 end
			check lerp_1: m.lerp (0.0, 10.0, 1.0) = 10.0 end
			check lerp_half: m.lerp (0.0, 10.0, 0.5) = 5.0 end
		end

	test_math_interpolation
			-- Test linear interpolation between points.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check interp_mid: m.linear_interpolate (0.0, 0.0, 10.0, 20.0, 5.0) = 10.0 end
		end

	test_math_degrees_radians
			-- Test angle conversion.
		local
			m: SIMPLE_MATH
		do
			create m.make
			check deg_to_rad: (m.degrees_to_radians (180.0) - m.pi).abs < 0.0001 end
			check rad_to_deg: (m.radians_to_degrees (m.pi) - 180.0).abs < 0.0001 end
		end

feature -- Test: Numerical Integration

	test_trapezoidal
			-- Test trapezoidal integration.
		local
			m: SIMPLE_MATH
			l_result: REAL_64
		do
			create m.make
			-- Integrate x^2 from 0 to 1, should be 1/3 = 0.333...
			l_result := m.trapezoidal (agent square, 0.0, 1.0, 100)
			check approx_third: (l_result - 0.333333).abs < 0.01 end
		end

	test_simpson
			-- Test Simpson integration.
		local
			m: SIMPLE_MATH
			l_result: REAL_64
		do
			create m.make
			-- Integrate x^2 from 0 to 1, should be 1/3 = 0.333...
			l_result := m.simpson (agent square, 0.0, 1.0, 100)
			check approx_third: (l_result - 0.333333).abs < 0.001 end
		end

feature -- Test: Root Finding

	test_bisection
			-- Test bisection root finding.
		local
			m: SIMPLE_MATH
			root: REAL_64
		do
			create m.make
			-- Find root of x^2 - 2 in [1, 2], should be sqrt(2)
			root := m.bisection (agent x_squared_minus_2, 1.0, 2.0, 0.0001, 100)
			check sqrt_2: (root - m.sqrt_2).abs < 0.001 end
		end

	test_newton_raphson
			-- Test Newton-Raphson root finding.
		local
			m: SIMPLE_MATH
			root: REAL_64
		do
			create m.make
			-- Find root of x^2 - 2, starting at 1.5
			root := m.newton_raphson (agent x_squared_minus_2, agent two_x, 1.5, 0.0001, 100)
			check sqrt_2: (root - m.sqrt_2).abs < 0.001 end
		end

feature {NONE} -- Test helpers

	square (x: REAL_64): REAL_64
		do
			Result := x * x
		end

	x_squared_minus_2 (x: REAL_64): REAL_64
		do
			Result := x * x - 2.0
		end

	two_x (x: REAL_64): REAL_64
		do
			Result := 2.0 * x
		end

end
