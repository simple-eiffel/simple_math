note
	description: "Facade class for simple_math library - numerical methods and factory"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_MATH

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize math library.
		do
		end

feature -- Vector factory

	new_vector (a_dimension: INTEGER): SIMPLE_VECTOR
			-- Create zero vector.
		require
			positive_dimension: a_dimension > 0
		do
			create Result.make (a_dimension)
		ensure
			dimension_set: Result.dimension = a_dimension
		end

	new_vector_from_array (a_values: ARRAY [REAL_64]): SIMPLE_VECTOR
			-- Create vector from array.
		require
			not_empty: a_values.count > 0
		do
			create Result.make_from_array (a_values)
		ensure
			dimension_set: Result.dimension = a_values.count
		end

	new_vector_2d (x, y: REAL_64): SIMPLE_VECTOR
			-- Create 2D vector.
		do
			create Result.make_from_array (<<x, y>>)
		ensure
			dimension_2: Result.dimension = 2
		end

	new_vector_3d (x, y, z: REAL_64): SIMPLE_VECTOR
			-- Create 3D vector.
		do
			create Result.make_from_array (<<x, y, z>>)
		ensure
			dimension_3: Result.dimension = 3
		end

feature -- Matrix factory

	new_matrix (a_rows, a_cols: INTEGER): SIMPLE_MATRIX
			-- Create zero matrix.
		require
			positive_rows: a_rows > 0
			positive_cols: a_cols > 0
		do
			create Result.make (a_rows, a_cols)
		ensure
			rows_set: Result.rows = a_rows
			cols_set: Result.cols = a_cols
		end

	new_matrix_from_array (a_rows, a_cols: INTEGER; a_values: ARRAY [REAL_64]): SIMPLE_MATRIX
			-- Create matrix from row-major array.
		require
			positive_rows: a_rows > 0
			positive_cols: a_cols > 0
			correct_size: a_values.count = a_rows * a_cols
		do
			create Result.make_from_array (a_rows, a_cols, a_values)
		ensure
			rows_set: Result.rows = a_rows
			cols_set: Result.cols = a_cols
		end

	new_identity_matrix (a_size: INTEGER): SIMPLE_MATRIX
			-- Create identity matrix.
		require
			positive_size: a_size > 0
		do
			create Result.make_identity (a_size)
		ensure
			square: Result.rows = Result.cols
			size_set: Result.rows = a_size
		end

feature -- Statistics factory

	new_statistics: SIMPLE_STATISTICS
			-- Create statistics calculator.
		do
			create Result.make
		end

	new_statistics_from_array (a_values: ARRAY [REAL_64]): SIMPLE_STATISTICS
			-- Create statistics from array.
		do
			create Result.make
			Result.add_all (a_values)
		ensure
			count_set: Result.count = a_values.count
		end

feature -- Numerical constants

	pi: REAL_64 = 3.14159265358979323846
			-- Pi constant.

	e: REAL_64 = 2.71828182845904523536
			-- Euler's number.

	golden_ratio: REAL_64 = 1.61803398874989484820
			-- Golden ratio (phi).

	sqrt_2: REAL_64 = 1.41421356237309504880
			-- Square root of 2.

feature -- Trigonometric functions

	sin (x: REAL_64): REAL_64
			-- Sine of `x` (radians).
		do
			Result := {DOUBLE_MATH}.sine (x)
		end

	cos (x: REAL_64): REAL_64
			-- Cosine of `x` (radians).
		do
			Result := {DOUBLE_MATH}.cosine (x)
		end

	tan (x: REAL_64): REAL_64
			-- Tangent of `x` (radians).
		do
			Result := {DOUBLE_MATH}.tangent (x)
		end

	asin (x: REAL_64): REAL_64
			-- Arc sine of `x`.
		require
			valid_range: x >= -1.0 and x <= 1.0
		do
			Result := {DOUBLE_MATH}.arc_sine (x)
		end

	acos (x: REAL_64): REAL_64
			-- Arc cosine of `x`.
		require
			valid_range: x >= -1.0 and x <= 1.0
		do
			Result := {DOUBLE_MATH}.arc_cosine (x)
		end

	atan (x: REAL_64): REAL_64
			-- Arc tangent of `x`.
		do
			Result := {DOUBLE_MATH}.arc_tangent (x)
		end

	atan2 (y, x: REAL_64): REAL_64
			-- Arc tangent of y/x using signs to determine quadrant.
		do
			if x > 0 then
				Result := atan (y / x)
			elseif x < 0 then
				if y >= 0 then
					Result := atan (y / x) + pi
				else
					Result := atan (y / x) - pi
				end
			else
				if y > 0 then
					Result := pi / 2
				elseif y < 0 then
					Result := -pi / 2
				else
					Result := 0
				end
			end
		end

	degrees_to_radians (d: REAL_64): REAL_64
			-- Convert degrees to radians.
		do
			Result := d * pi / 180.0
		end

	radians_to_degrees (r: REAL_64): REAL_64
			-- Convert radians to degrees.
		do
			Result := r * 180.0 / pi
		end

feature -- Exponential and logarithmic

	exp (x: REAL_64): REAL_64
			-- e raised to power `x`.
		do
			Result := {DOUBLE_MATH}.exp (x)
		end

	log (x: REAL_64): REAL_64
			-- Natural logarithm.
		require
			positive: x > 0
		do
			Result := {DOUBLE_MATH}.log (x)
		end

	log10 (x: REAL_64): REAL_64
			-- Base-10 logarithm.
		require
			positive: x > 0
		do
			Result := {DOUBLE_MATH}.log10 (x)
		end

	log2 (x: REAL_64): REAL_64
			-- Base-2 logarithm.
		require
			positive: x > 0
		do
			Result := {DOUBLE_MATH}.log (x) / {DOUBLE_MATH}.log (2.0)
		end

	pow (base, exponent: REAL_64): REAL_64
			-- `base` raised to `exponent`.
		do
			Result := base ^ exponent
		end

	sqrt (x: REAL_64): REAL_64
			-- Square root.
		require
			non_negative: x >= 0
		do
			Result := {DOUBLE_MATH}.sqrt (x)
		end

	cbrt (x: REAL_64): REAL_64
			-- Cube root.
		do
			if x >= 0 then
				Result := x ^ (1.0 / 3.0)
			else
				Result := -((-x) ^ (1.0 / 3.0))
			end
		end

feature -- Root finding

	bisection (f: FUNCTION [REAL_64, REAL_64]; a, b: REAL_64; tolerance: REAL_64; max_iterations: INTEGER): REAL_64
			-- Find root of `f` in [a,b] using bisection method.
		require
			valid_interval: a < b
			opposite_signs: f.item ([a]) * f.item ([b]) < 0
			positive_tolerance: tolerance > 0
			positive_iterations: max_iterations > 0
		local
			l_a, l_b, l_mid, l_fa, l_fb, l_fmid: REAL_64
			i: INTEGER
		do
			l_a := a
			l_b := b
			l_fa := f.item ([l_a])
			l_fb := f.item ([l_b])

			from i := 1 until i > max_iterations or (l_b - l_a) < tolerance loop
				l_mid := (l_a + l_b) / 2.0
				l_fmid := f.item ([l_mid])

				if l_fmid.abs < tolerance then
					l_a := l_mid
					l_b := l_mid
				elseif l_fa * l_fmid < 0 then
					l_b := l_mid
					l_fb := l_fmid
				else
					l_a := l_mid
					l_fa := l_fmid
				end
				i := i + 1
			end

			Result := (l_a + l_b) / 2.0
		end

	newton_raphson (f, df: FUNCTION [REAL_64, REAL_64]; x0: REAL_64; tolerance: REAL_64; max_iterations: INTEGER): REAL_64
			-- Find root using Newton-Raphson method.
			-- `f` is the function, `df` is its derivative.
		require
			positive_tolerance: tolerance > 0
			positive_iterations: max_iterations > 0
		local
			x, fx, dfx: REAL_64
			i: INTEGER
		do
			x := x0
			from i := 1 until i > max_iterations loop
				fx := f.item ([x])
				if fx.abs < tolerance then
					i := max_iterations + 1 -- Exit
				else
					dfx := df.item ([x])
					if dfx.abs < 1.0e-15 then
						i := max_iterations + 1 -- Exit (derivative too small)
					else
						x := x - fx / dfx
					end
				end
				i := i + 1
			end
			Result := x
		end

feature -- Numerical integration

	trapezoidal (f: FUNCTION [REAL_64, REAL_64]; a, b: REAL_64; n: INTEGER): REAL_64
			-- Integrate `f` from `a` to `b` using trapezoidal rule with `n` intervals.
		require
			valid_interval: a < b
			positive_intervals: n > 0
		local
			h, l_sum: REAL_64
			i: INTEGER
			x: REAL_64
		do
			h := (b - a) / n
			l_sum := (f.item ([a]) + f.item ([b])) / 2.0

			from i := 1 until i >= n loop
				x := a + i * h
				l_sum := l_sum + f.item ([x])
				i := i + 1
			end

			Result := h * l_sum
		end

	simpson (f: FUNCTION [REAL_64, REAL_64]; a, b: REAL_64; n: INTEGER): REAL_64
			-- Integrate `f` from `a` to `b` using Simpson's rule with `n` intervals.
		require
			valid_interval: a < b
			even_intervals: n > 0 and n \\ 2 = 0
		local
			h, l_sum: REAL_64
			i: INTEGER
			x: REAL_64
		do
			h := (b - a) / n
			l_sum := f.item ([a]) + f.item ([b])

			from i := 1 until i >= n loop
				x := a + i * h
				if i \\ 2 = 0 then
					l_sum := l_sum + 2.0 * f.item ([x])
				else
					l_sum := l_sum + 4.0 * f.item ([x])
				end
				i := i + 1
			end

			Result := h * l_sum / 3.0
		end

feature -- Interpolation

	linear_interpolate (x1, y1, x2, y2, x: REAL_64): REAL_64
			-- Linear interpolation at `x`.
		require
			different_x: (x2 - x1).abs > 1.0e-15
		do
			Result := y1 + (y2 - y1) * (x - x1) / (x2 - x1)
		end

	lagrange_interpolate (x_points, y_points: ARRAY [REAL_64]; x: REAL_64): REAL_64
			-- Lagrange polynomial interpolation at `x`.
		require
			same_count: x_points.count = y_points.count
			not_empty: x_points.count > 0
		local
			n, i, j: INTEGER
			l_prod: REAL_64
		do
			n := x_points.count

			from i := x_points.lower until i > x_points.upper loop
				l_prod := 1.0
				from j := x_points.lower until j > x_points.upper loop
					if i /= j then
						l_prod := l_prod * (x - x_points.item (j)) / (x_points.item (i) - x_points.item (j))
					end
					j := j + 1
				end
				Result := Result + y_points.item (i) * l_prod
				i := i + 1
			end
		end

feature -- Utility functions

	factorial (n: INTEGER): INTEGER_64
			-- Factorial of `n`.
		require
			non_negative: n >= 0
		local
			i: INTEGER
		do
			if n <= 1 then
				Result := 1
			else
				Result := 1
				from i := 2 until i > n loop
					Result := Result * i
					i := i + 1
				end
			end
		end

	binomial (n, k: INTEGER): INTEGER_64
			-- Binomial coefficient C(n,k).
		require
			valid_n: n >= 0
			valid_k: k >= 0 and k <= n
		do
			Result := factorial (n) // (factorial (k) * factorial (n - k))
		end

	gcd (a, b: INTEGER): INTEGER
			-- Greatest common divisor.
		require
			positive_a: a > 0
			positive_b: b > 0
		local
			l_a, l_b, l_temp: INTEGER
		do
			l_a := a
			l_b := b
			from until l_b = 0 loop
				l_temp := l_b
				l_b := l_a \\ l_b
				l_a := l_temp
			end
			Result := l_a
		ensure
			positive: Result > 0
		end

	lcm (a, b: INTEGER): INTEGER
			-- Least common multiple.
		require
			positive_a: a > 0
			positive_b: b > 0
		do
			Result := (a * b) // gcd (a, b)
		ensure
			positive: Result > 0
		end

	clamp (value, min_val, max_val: REAL_64): REAL_64
			-- Clamp `value` to [min_val, max_val].
		require
			valid_range: min_val <= max_val
		do
			if value < min_val then
				Result := min_val
			elseif value > max_val then
				Result := max_val
			else
				Result := value
			end
		ensure
			in_range: Result >= min_val and Result <= max_val
		end

	lerp (a, b, t: REAL_64): REAL_64
			-- Linear interpolation between `a` and `b` at parameter `t`.
		do
			Result := a + (b - a) * t
		end

	is_close (a, b: REAL_64; tolerance: REAL_64): BOOLEAN
			-- Are `a` and `b` within `tolerance`?
		require
			positive_tolerance: tolerance >= 0
		do
			Result := (a - b).abs <= tolerance
		end

end
