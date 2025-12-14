note
	description: "N-dimensional vector for mathematical operations"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_VECTOR

inherit
	ANY
		redefine
			out,
			is_equal
		end

create
	make,
	make_from_array,
	make_zero,
	make_unit

feature {NONE} -- Initialization

	make (a_dimension: INTEGER)
			-- Create vector with `a_dimension` elements, all zero.
		require
			positive_dimension: a_dimension > 0
		do
			create elements.make_filled (0.0, 1, a_dimension)
		ensure
			dimension_set: dimension = a_dimension
			all_zero: is_zero
		end

	make_from_array (a_values: ARRAY [REAL_64])
			-- Create vector from array of values.
		require
			values_not_empty: a_values.count > 0
		do
			create elements.make_filled (0.0, 1, a_values.count)
			copy_from_array (a_values)
		ensure
			dimension_set: dimension = a_values.count
		end

	make_zero (a_dimension: INTEGER)
			-- Create zero vector with `a_dimension` elements.
		require
			positive_dimension: a_dimension > 0
		do
			make (a_dimension)
		ensure
			dimension_set: dimension = a_dimension
			is_zero: is_zero
		end

	make_unit (a_dimension: INTEGER; a_index: INTEGER)
			-- Create unit vector with 1 at `a_index`, rest zero.
		require
			positive_dimension: a_dimension > 0
			valid_index: a_index >= 1 and a_index <= a_dimension
		do
			make (a_dimension)
			elements.put (1.0, a_index)
		ensure
			dimension_set: dimension = a_dimension
			unit_at_index: item (a_index) = 1.0
		end

feature -- Access

	dimension: INTEGER
			-- Number of elements in vector.
		do
			Result := elements.count
		end

	item alias "[]" (i: INTEGER): REAL_64 assign put
			-- Element at index `i`.
		require
			valid_index: i >= 1 and i <= dimension
		do
			Result := elements.item (i)
		end

	elements: ARRAY [REAL_64]
			-- Internal storage for vector elements.

feature -- Element change

	put (a_value: REAL_64; i: INTEGER)
			-- Set element at index `i` to `a_value`.
		require
			valid_index: i >= 1 and i <= dimension
		do
			elements.put (a_value, i)
		ensure
			value_set: item (i) = a_value
		end

feature -- Status report

	is_zero: BOOLEAN
			-- Are all elements zero?
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > dimension or not Result loop
				if elements.item (i) /= 0.0 then
					Result := False
				end
				i := i + 1
			end
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other` equal to Current?
		local
			i: INTEGER
		do
			if dimension = other.dimension then
				Result := True
				from i := 1 until i > dimension or not Result loop
					if (item (i) - other.item (i)).abs > 1.0e-10 then
						Result := False
					end
					i := i + 1
				end
			end
		end

feature -- Basic operations

	plus alias "+" (other: SIMPLE_VECTOR): SIMPLE_VECTOR
			-- Vector addition.
		require
			same_dimension: dimension = other.dimension
		local
			i: INTEGER
		do
			create Result.make (dimension)
			from i := 1 until i > dimension loop
				Result.put (item (i) + other.item (i), i)
				i := i + 1
			end
		ensure
			result_dimension: Result.dimension = dimension
		end

	minus alias "-" (other: SIMPLE_VECTOR): SIMPLE_VECTOR
			-- Vector subtraction.
		require
			same_dimension: dimension = other.dimension
		local
			i: INTEGER
		do
			create Result.make (dimension)
			from i := 1 until i > dimension loop
				Result.put (item (i) - other.item (i), i)
				i := i + 1
			end
		ensure
			result_dimension: Result.dimension = dimension
		end

	scaled alias "*" (a_scalar: REAL_64): SIMPLE_VECTOR
			-- Scalar multiplication.
		local
			i: INTEGER
		do
			create Result.make (dimension)
			from i := 1 until i > dimension loop
				Result.put (item (i) * a_scalar, i)
				i := i + 1
			end
		ensure
			result_dimension: Result.dimension = dimension
		end

	negated alias "-": SIMPLE_VECTOR
			-- Negation of vector.
		local
			i: INTEGER
		do
			create Result.make (dimension)
			from i := 1 until i > dimension loop
				Result.put (-item (i), i)
				i := i + 1
			end
		ensure
			result_dimension: Result.dimension = dimension
		end

	dot (other: SIMPLE_VECTOR): REAL_64
			-- Dot product with `other`.
		require
			same_dimension: dimension = other.dimension
		local
			i: INTEGER
		do
			from i := 1 until i > dimension loop
				Result := Result + item (i) * other.item (i)
				i := i + 1
			end
		end

	cross (other: SIMPLE_VECTOR): SIMPLE_VECTOR
			-- Cross product with `other` (3D only).
		require
			three_dimensional: dimension = 3 and other.dimension = 3
		do
			create Result.make (3)
			Result.put (item (2) * other.item (3) - item (3) * other.item (2), 1)
			Result.put (item (3) * other.item (1) - item (1) * other.item (3), 2)
			Result.put (item (1) * other.item (2) - item (2) * other.item (1), 3)
		ensure
			result_dimension: Result.dimension = 3
		end

feature -- Metrics

	magnitude: REAL_64
			-- Euclidean length of vector.
		do
			Result := {DOUBLE_MATH}.sqrt (dot (Current))
		end

	magnitude_squared: REAL_64
			-- Square of magnitude (avoids sqrt).
		do
			Result := dot (Current)
		end

	distance (other: SIMPLE_VECTOR): REAL_64
			-- Euclidean distance to `other`.
		require
			same_dimension: dimension = other.dimension
		do
			Result := (Current - other).magnitude
		end

	normalized: SIMPLE_VECTOR
			-- Unit vector in same direction.
		require
			not_zero: not is_zero
		local
			mag: REAL_64
		do
			mag := magnitude
			Result := Current * (1.0 / mag)
		ensure
			result_dimension: Result.dimension = dimension
			unit_length: (Result.magnitude - 1.0).abs < 1.0e-10
		end

feature -- Statistics

	sum: REAL_64
			-- Sum of all elements.
		local
			i: INTEGER
		do
			from i := 1 until i > dimension loop
				Result := Result + item (i)
				i := i + 1
			end
		end

	mean: REAL_64
			-- Arithmetic mean of elements.
		do
			Result := sum / dimension
		end

	min: REAL_64
			-- Minimum element value.
		local
			i: INTEGER
		do
			Result := item (1)
			from i := 2 until i > dimension loop
				if item (i) < Result then
					Result := item (i)
				end
				i := i + 1
			end
		end

	max: REAL_64
			-- Maximum element value.
		local
			i: INTEGER
		do
			Result := item (1)
			from i := 2 until i > dimension loop
				if item (i) > Result then
					Result := item (i)
				end
				i := i + 1
			end
		end

feature -- Conversion

	to_array: ARRAY [REAL_64]
			-- Convert to array.
		do
			create Result.make_from_array (elements)
		ensure
			same_count: Result.count = dimension
		end

	out: STRING
			-- String representation.
		local
			i: INTEGER
		do
			create Result.make (dimension * 10)
			Result.append_character ('[')
			from i := 1 until i > dimension loop
				if i > 1 then
					Result.append_string (", ")
				end
				Result.append_string (item (i).out)
				i := i + 1
			end
			Result.append_character (']')
		end

feature {NONE} -- Implementation

	copy_from_array (a_values: ARRAY [REAL_64])
			-- Copy values from array.
		local
			i: INTEGER
		do
			from i := 1 until i > a_values.count loop
				elements.put (a_values.item (a_values.lower + i - 1), i)
				i := i + 1
			end
		end

invariant
	positive_dimension: dimension > 0
	elements_match: elements.count = dimension

end
