note
	description: "Matrix class for linear algebra operations"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_MATRIX

inherit
	ANY
		redefine
			out,
			is_equal
		end

create
	make,
	make_from_array,
	make_identity,
	make_zero

feature {NONE} -- Initialization

	make (a_rows, a_cols: INTEGER)
			-- Create matrix with `a_rows` rows and `a_cols` columns.
		require
			positive_rows: a_rows > 0
			positive_cols: a_cols > 0
		do
			rows := a_rows
			cols := a_cols
			create data.make_filled (0.0, 1, a_rows * a_cols)
		ensure
			rows_set: rows = a_rows
			cols_set: cols = a_cols
		end

	make_from_array (a_rows, a_cols: INTEGER; a_values: ARRAY [REAL_64])
			-- Create matrix from row-major array.
		require
			positive_rows: a_rows > 0
			positive_cols: a_cols > 0
			correct_size: a_values.count = a_rows * a_cols
		local
			i: INTEGER
		do
			make (a_rows, a_cols)
			from i := 1 until i > a_values.count loop
				data.put (a_values.item (a_values.lower + i - 1), i)
				i := i + 1
			end
		ensure
			rows_set: rows = a_rows
			cols_set: cols = a_cols
		end

	make_identity (a_size: INTEGER)
			-- Create identity matrix.
		require
			positive_size: a_size > 0
		local
			i: INTEGER
		do
			make (a_size, a_size)
			from i := 1 until i > a_size loop
				put (1.0, i, i)
				i := i + 1
			end
		ensure
			square: rows = cols
			size_set: rows = a_size
		end

	make_zero (a_rows, a_cols: INTEGER)
			-- Create zero matrix.
		require
			positive_rows: a_rows > 0
			positive_cols: a_cols > 0
		do
			make (a_rows, a_cols)
		ensure
			rows_set: rows = a_rows
			cols_set: cols = a_cols
		end

feature -- Model

	model: MML_SEQUENCE [MML_SEQUENCE [REAL_64]]
			-- Mathematical model of matrix as sequence of row sequences.
		local
			l_row: MML_SEQUENCE [REAL_64]
			i, j: INTEGER
		do
			create Result
			from i := 1 until i > rows loop
				create l_row
				from j := 1 until j > cols loop
					l_row := l_row & item (i, j)
					j := j + 1
				end
				Result := Result & l_row
				i := i + 1
			end
		ensure
			row_count: Result.count = rows
			col_count: across 1 |..| rows as idx all Result [idx].count = cols end
		end

feature -- Access

	rows: INTEGER
			-- Number of rows.

	cols: INTEGER
			-- Number of columns.

	item alias "[]" (i, j: INTEGER): REAL_64 assign put
			-- Element at row `i`, column `j`.
		require
			valid_row: i >= 1 and i <= rows
			valid_col: j >= 1 and j <= cols
		do
			Result := data.item ((i - 1) * cols + j)
		end

	row (i: INTEGER): SIMPLE_VECTOR
			-- Row `i` as vector.
		require
			valid_row: i >= 1 and i <= rows
		local
			j: INTEGER
		do
			create Result.make (cols)
			from j := 1 until j > cols loop
				Result.put (item (i, j), j)
				j := j + 1
			end
		ensure
			correct_dimension: Result.dimension = cols
		end

	column (j: INTEGER): SIMPLE_VECTOR
			-- Column `j` as vector.
		require
			valid_col: j >= 1 and j <= cols
		local
			i: INTEGER
		do
			create Result.make (rows)
			from i := 1 until i > rows loop
				Result.put (item (i, j), i)
				i := i + 1
			end
		ensure
			correct_dimension: Result.dimension = rows
		end

	diagonal: SIMPLE_VECTOR
			-- Main diagonal as vector.
		require
			is_square: rows = cols
		local
			i: INTEGER
		do
			create Result.make (rows)
			from i := 1 until i > rows loop
				Result.put (item (i, i), i)
				i := i + 1
			end
		ensure
			correct_dimension: Result.dimension = rows
		end

feature -- Element change

	put (a_value: REAL_64; i, j: INTEGER)
			-- Set element at row `i`, column `j` to `a_value`.
		require
			valid_row: i >= 1 and i <= rows
			valid_col: j >= 1 and j <= cols
		do
			data.put (a_value, (i - 1) * cols + j)
		ensure
			value_set: item (i, j) = a_value
			dimensions_unchanged: rows = old rows and cols = old cols
		end

	set_row (i: INTEGER; a_vector: SIMPLE_VECTOR)
			-- Set row `i` from vector.
		require
			valid_row: i >= 1 and i <= rows
			correct_dimension: a_vector.dimension = cols
		local
			j: INTEGER
		do
			from j := 1 until j > cols loop
				put (a_vector.item (j), i, j)
				j := j + 1
			end
		ensure
			row_set: across 1 |..| cols as jdx all item (i, jdx) = a_vector.item (jdx) end
			dimensions_unchanged: rows = old rows and cols = old cols
		end

	set_column (j: INTEGER; a_vector: SIMPLE_VECTOR)
			-- Set column `j` from vector.
		require
			valid_col: j >= 1 and j <= cols
			correct_dimension: a_vector.dimension = rows
		local
			i: INTEGER
		do
			from i := 1 until i > rows loop
				put (a_vector.item (i), i, j)
				i := i + 1
			end
		ensure
			column_set: across 1 |..| rows as idx all item (idx, j) = a_vector.item (idx) end
			dimensions_unchanged: rows = old rows and cols = old cols
		end

feature -- Status report

	is_square: BOOLEAN
			-- Is matrix square?
		do
			Result := rows = cols
		end

	is_symmetric: BOOLEAN
			-- Is matrix symmetric?
		local
			i, j: INTEGER
		do
			if is_square then
				Result := True
				from i := 1 until i > rows or not Result loop
					from j := i + 1 until j > cols or not Result loop
						if (item (i, j) - item (j, i)).abs > 1.0e-10 then
							Result := False
						end
						j := j + 1
					end
					i := i + 1
				end
			end
		end

	is_diagonal: BOOLEAN
			-- Is matrix diagonal?
		local
			i, j: INTEGER
		do
			if is_square then
				Result := True
				from i := 1 until i > rows or not Result loop
					from j := 1 until j > cols or not Result loop
						if i /= j and item (i, j).abs > 1.0e-10 then
							Result := False
						end
						j := j + 1
					end
					i := i + 1
				end
			end
		end

	is_identity: BOOLEAN
			-- Is matrix identity?
		local
			i, j: INTEGER
		do
			if is_square then
				Result := True
				from i := 1 until i > rows or not Result loop
					from j := 1 until j > cols or not Result loop
						if i = j then
							if (item (i, j) - 1.0).abs > 1.0e-10 then
								Result := False
							end
						else
							if item (i, j).abs > 1.0e-10 then
								Result := False
							end
						end
						j := j + 1
					end
					i := i + 1
				end
			end
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other` equal to Current?
		local
			i, j: INTEGER
		do
			if rows = other.rows and cols = other.cols then
				Result := True
				from i := 1 until i > rows or not Result loop
					from j := 1 until j > cols or not Result loop
						if (item (i, j) - other.item (i, j)).abs > 1.0e-10 then
							Result := False
						end
						j := j + 1
					end
					i := i + 1
				end
			end
		end

feature -- Basic operations

	plus alias "+" (other: SIMPLE_MATRIX): SIMPLE_MATRIX
			-- Matrix addition.
		require
			same_rows: rows = other.rows
			same_cols: cols = other.cols
		local
			i, j: INTEGER
		do
			create Result.make (rows, cols)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					Result.put (item (i, j) + other.item (i, j), i, j)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			result_rows: Result.rows = rows
			result_cols: Result.cols = cols
			elementwise_sum: across 1 |..| rows as ri all
				across 1 |..| cols as ci all
					Result.item (ri, ci) = item (ri, ci) + other.item (ri, ci)
				end
			end
		end

	minus alias "-" (other: SIMPLE_MATRIX): SIMPLE_MATRIX
			-- Matrix subtraction.
		require
			same_rows: rows = other.rows
			same_cols: cols = other.cols
		local
			i, j: INTEGER
		do
			create Result.make (rows, cols)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					Result.put (item (i, j) - other.item (i, j), i, j)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			result_rows: Result.rows = rows
			result_cols: Result.cols = cols
			elementwise_diff: across 1 |..| rows as ri all
				across 1 |..| cols as ci all
					Result.item (ri, ci) = item (ri, ci) - other.item (ri, ci)
				end
			end
		end

	product alias "*" (other: SIMPLE_MATRIX): SIMPLE_MATRIX
			-- Matrix multiplication.
		require
			compatible: cols = other.rows
		local
			i, j, k: INTEGER
			l_sum: REAL_64
		do
			create Result.make (rows, other.cols)
			from i := 1 until i > rows loop
				from j := 1 until j > other.cols loop
					l_sum := 0.0
					from k := 1 until k > cols loop
						l_sum := l_sum + item (i, k) * other.item (k, j)
						k := k + 1
					end
					Result.put (l_sum, i, j)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			result_rows: Result.rows = rows
			result_cols: Result.cols = other.cols
		end

	scaled (a_scalar: REAL_64): SIMPLE_MATRIX
			-- Scalar multiplication.
		local
			i, j: INTEGER
		do
			create Result.make (rows, cols)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					Result.put (item (i, j) * a_scalar, i, j)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			result_rows: Result.rows = rows
			result_cols: Result.cols = cols
			elementwise_scaled: across 1 |..| rows as ri all
				across 1 |..| cols as ci all
					Result.item (ri, ci) = item (ri, ci) * a_scalar
				end
			end
		end

	multiply_vector (a_vector: SIMPLE_VECTOR): SIMPLE_VECTOR
			-- Multiply matrix by vector.
		require
			compatible: cols = a_vector.dimension
		local
			i, j: INTEGER
			l_sum: REAL_64
		do
			create Result.make (rows)
			from i := 1 until i > rows loop
				l_sum := 0.0
				from j := 1 until j > cols loop
					l_sum := l_sum + item (i, j) * a_vector.item (j)
					j := j + 1
				end
				Result.put (l_sum, i)
				i := i + 1
			end
		ensure
			result_dimension: Result.dimension = rows
		end

	transposed: SIMPLE_MATRIX
			-- Transpose of matrix.
		local
			i, j: INTEGER
		do
			create Result.make (cols, rows)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					Result.put (item (i, j), j, i)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			result_rows: Result.rows = cols
			result_cols: Result.cols = rows
			transposed_elements: across 1 |..| rows as ri all
				across 1 |..| cols as ci all
					Result.item (ci, ri) = item (ri, ci)
				end
			end
		end

feature -- Linear algebra

	trace: REAL_64
			-- Sum of diagonal elements.
		require
			is_square: rows = cols
		local
			i: INTEGER
		do
			from i := 1 until i > rows loop
				Result := Result + item (i, i)
				i := i + 1
			end
		end

	determinant: REAL_64
			-- Determinant using LU decomposition.
		require
			is_square: rows = cols
		local
			lu: SIMPLE_MATRIX
			i, j, k, pivot_row: INTEGER
			l_max, l_temp, l_factor: REAL_64
			l_det: REAL_64
			l_swaps: INTEGER
		do
			-- Copy matrix for LU decomposition
			create lu.make (rows, cols)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					lu.put (item (i, j), i, j)
					j := j + 1
				end
				i := i + 1
			end

			l_det := 1.0
			l_swaps := 0

			from k := 1 until k > rows loop
				-- Find pivot
				l_max := lu.item (k, k).abs
				pivot_row := k
				from i := k + 1 until i > rows loop
					if lu.item (i, k).abs > l_max then
						l_max := lu.item (i, k).abs
						pivot_row := i
					end
					i := i + 1
				end

				-- Check for singular
				if l_max < 1.0e-10 then
					Result := 0.0
					k := rows + 1 -- Exit loop
				else
					-- Swap rows if needed
					if pivot_row /= k then
						from j := 1 until j > cols loop
							l_temp := lu.item (k, j)
							lu.put (lu.item (pivot_row, j), k, j)
							lu.put (l_temp, pivot_row, j)
							j := j + 1
						end
						l_swaps := l_swaps + 1
					end

					l_det := l_det * lu.item (k, k)

					-- Eliminate below pivot
					from i := k + 1 until i > rows loop
						l_factor := lu.item (i, k) / lu.item (k, k)
						from j := k until j > cols loop
							lu.put (lu.item (i, j) - l_factor * lu.item (k, j), i, j)
							j := j + 1
						end
						i := i + 1
					end

					k := k + 1
				end
			end

			if l_det /= 0.0 then
				if l_swaps \\ 2 = 1 then
					Result := -l_det
				else
					Result := l_det
				end
			end
		end

	inverse: SIMPLE_MATRIX
			-- Matrix inverse using Gauss-Jordan elimination.
		require
			is_square: rows = cols
			is_invertible: determinant.abs > 1.0e-10
		local
			aug: SIMPLE_MATRIX
			i, j, k, pivot_row: INTEGER
			l_max, l_temp, l_factor, l_pivot: REAL_64
		do
			-- Create augmented matrix [A | I]
			create aug.make (rows, cols * 2)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					aug.put (item (i, j), i, j)
					j := j + 1
				end
				aug.put (1.0, i, cols + i)
				i := i + 1
			end

			-- Forward elimination with partial pivoting
			from k := 1 until k > rows loop
				-- Find pivot
				l_max := aug.item (k, k).abs
				pivot_row := k
				from i := k + 1 until i > rows loop
					if aug.item (i, k).abs > l_max then
						l_max := aug.item (i, k).abs
						pivot_row := i
					end
					i := i + 1
				end

				-- Swap rows if needed
				if pivot_row /= k then
					from j := 1 until j > cols * 2 loop
						l_temp := aug.item (k, j)
						aug.put (aug.item (pivot_row, j), k, j)
						aug.put (l_temp, pivot_row, j)
						j := j + 1
					end
				end

				-- Scale pivot row
				l_pivot := aug.item (k, k)
				from j := 1 until j > cols * 2 loop
					aug.put (aug.item (k, j) / l_pivot, k, j)
					j := j + 1
				end

				-- Eliminate column
				from i := 1 until i > rows loop
					if i /= k then
						l_factor := aug.item (i, k)
						from j := 1 until j > cols * 2 loop
							aug.put (aug.item (i, j) - l_factor * aug.item (k, j), i, j)
							j := j + 1
						end
					end
					i := i + 1
				end

				k := k + 1
			end

			-- Extract inverse from augmented matrix
			create Result.make (rows, cols)
			from i := 1 until i > rows loop
				from j := 1 until j > cols loop
					Result.put (aug.item (i, cols + j), i, j)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			result_rows: Result.rows = rows
			result_cols: Result.cols = cols
		end

feature -- Conversion

	out: STRING
			-- String representation.
		local
			i, j: INTEGER
		do
			create Result.make (rows * cols * 10)
			from i := 1 until i > rows loop
				Result.append_character ('[')
				from j := 1 until j > cols loop
					if j > 1 then
						Result.append_string (", ")
					end
					Result.append_string (item (i, j).out)
					j := j + 1
				end
				Result.append_character (']')
				if i < rows then
					Result.append_character ('%N')
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	data: ARRAY [REAL_64]
			-- Row-major storage for matrix elements.

invariant
	positive_rows: rows > 0
	positive_cols: cols > 0
	data_size: data.count = rows * cols
	data_attached: data /= Void
	model_rows: model.count = rows
	model_cols: across 1 |..| rows as idx all model [idx].count = cols end

end
