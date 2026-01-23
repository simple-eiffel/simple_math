note
	description: "Statistical functions for data analysis"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_STATISTICS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize statistics calculator.
		do
			create {ARRAYED_LIST [REAL_64]} data.make (0)
		end

feature -- Model

	model: MML_SEQUENCE [REAL_64]
			-- Mathematical model of statistics data as sequence.
		do
			create Result
			from data.start until data.after loop
				Result := Result & data.item
				data.forth
			end
		ensure
			count_matches: Result.count = count
		end

feature -- Access

	count: INTEGER
			-- Number of data points.
		do
			Result := data.count
		end

	data: LIST [REAL_64]
			-- Current data set.

feature -- Element change

	add (a_value: REAL_64)
			-- Add value to data set.
		do
			data.extend (a_value)
		ensure
			count_increased: count = old count + 1
			model_extended: model |=| (old model).extended (a_value)
		end

	add_all (a_values: ARRAY [REAL_64])
			-- Add all values from array.
		local
			i: INTEGER
		do
			from i := a_values.lower until i > a_values.upper loop
				data.extend (a_values.item (i))
				i := i + 1
			end
		ensure
			count_increased: count = old count + a_values.count
		end

	clear
			-- Remove all data.
		do
			data.wipe_out
		ensure
			empty: count = 0
			model_empty: model.is_empty
		end

feature -- Central tendency

	sum: REAL_64
			-- Sum of all values.
		require
			not_empty: count > 0
		do
			from data.start until data.after loop
				Result := Result + data.item
				data.forth
			end
		end

	mean: REAL_64
			-- Arithmetic mean.
		require
			not_empty: count > 0
		do
			Result := sum / count
		end

	median: REAL_64
			-- Median value.
		require
			not_empty: count > 0
		local
			sorted: ARRAYED_LIST [REAL_64]
			mid: INTEGER
		do
			sorted := sorted_data
			mid := count // 2
			if count \\ 2 = 0 then
				Result := (sorted.i_th (mid) + sorted.i_th (mid + 1)) / 2.0
			else
				Result := sorted.i_th (mid + 1)
			end
		end

	mode: REAL_64
			-- Most frequent value (first if tie).
		require
			not_empty: count > 0
		local
			freq: HASH_TABLE [INTEGER, REAL_64]
			l_max_freq: INTEGER
			l_val: REAL_64
		do
			create freq.make (count)
			from data.start until data.after loop
				l_val := data.item
				if freq.has (l_val) then
					freq.force (freq.item (l_val) + 1, l_val)
				else
					freq.put (1, l_val)
				end
				data.forth
			end

			l_max_freq := 0
			from freq.start until freq.after loop
				if freq.item_for_iteration > l_max_freq then
					l_max_freq := freq.item_for_iteration
					Result := freq.key_for_iteration
				end
				freq.forth
			end
		end

	geometric_mean: REAL_64
			-- Geometric mean (all values must be positive).
		require
			not_empty: count > 0
			all_positive: all_positive
		local
			l_log_sum: REAL_64
		do
			from data.start until data.after loop
				l_log_sum := l_log_sum + {DOUBLE_MATH}.log (data.item)
				data.forth
			end
			Result := {DOUBLE_MATH}.exp (l_log_sum / count)
		end

	harmonic_mean: REAL_64
			-- Harmonic mean (all values must be positive).
		require
			not_empty: count > 0
			all_positive: all_positive
		local
			l_reciprocal_sum: REAL_64
		do
			from data.start until data.after loop
				l_reciprocal_sum := l_reciprocal_sum + 1.0 / data.item
				data.forth
			end
			Result := count / l_reciprocal_sum
		end

feature -- Dispersion

	variance: REAL_64
			-- Population variance.
		require
			not_empty: count > 0
		local
			l_mean, l_sum_sq: REAL_64
		do
			l_mean := mean
			from data.start until data.after loop
				l_sum_sq := l_sum_sq + (data.item - l_mean) * (data.item - l_mean)
				data.forth
			end
			Result := l_sum_sq / count
		end

	sample_variance: REAL_64
			-- Sample variance (Bessel's correction).
		require
			at_least_two: count >= 2
		local
			l_mean, l_sum_sq: REAL_64
		do
			l_mean := mean
			from data.start until data.after loop
				l_sum_sq := l_sum_sq + (data.item - l_mean) * (data.item - l_mean)
				data.forth
			end
			Result := l_sum_sq / (count - 1)
		end

	standard_deviation: REAL_64
			-- Population standard deviation.
		require
			not_empty: count > 0
		do
			Result := {DOUBLE_MATH}.sqrt (variance)
		end

	sample_standard_deviation: REAL_64
			-- Sample standard deviation.
		require
			at_least_two: count >= 2
		do
			Result := {DOUBLE_MATH}.sqrt (sample_variance)
		end

	range: REAL_64
			-- Difference between max and min.
		require
			not_empty: count > 0
		do
			Result := maximum - minimum
		end

	coefficient_of_variation: REAL_64
			-- Coefficient of variation (CV).
		require
			not_empty: count > 0
			mean_not_zero: mean.abs > 1.0e-10
		do
			Result := standard_deviation / mean.abs
		end

feature -- Extremes

	minimum: REAL_64
			-- Minimum value.
		require
			not_empty: count > 0
		do
			Result := data.first
			from data.start until data.after loop
				if data.item < Result then
					Result := data.item
				end
				data.forth
			end
		end

	maximum: REAL_64
			-- Maximum value.
		require
			not_empty: count > 0
		do
			Result := data.first
			from data.start until data.after loop
				if data.item > Result then
					Result := data.item
				end
				data.forth
			end
		end

feature -- Percentiles

	percentile (p: REAL_64): REAL_64
			-- Value at percentile `p` (0-100).
		require
			not_empty: count > 0
			valid_percentile: p >= 0 and p <= 100
		local
			sorted: ARRAYED_LIST [REAL_64]
			l_index: REAL_64
			l_lower, l_upper: INTEGER
			l_frac: REAL_64
		do
			sorted := sorted_data
			l_index := (p / 100.0) * (count - 1) + 1
			l_lower := l_index.floor
			l_upper := l_index.ceiling
			if l_lower = l_upper then
				Result := sorted.i_th (l_lower)
			else
				l_frac := l_index - l_lower
				Result := sorted.i_th (l_lower) * (1 - l_frac) + sorted.i_th (l_upper) * l_frac
			end
		end

	quartile_1: REAL_64
			-- First quartile (25th percentile).
		require
			not_empty: count > 0
		do
			Result := percentile (25)
		end

	quartile_2: REAL_64
			-- Second quartile (median).
		require
			not_empty: count > 0
		do
			Result := median
		end

	quartile_3: REAL_64
			-- Third quartile (75th percentile).
		require
			not_empty: count > 0
		do
			Result := percentile (75)
		end

	interquartile_range: REAL_64
			-- IQR = Q3 - Q1.
		require
			not_empty: count > 0
		do
			Result := quartile_3 - quartile_1
		end

feature -- Correlation

	covariance (other: SIMPLE_STATISTICS): REAL_64
			-- Population covariance with `other`.
		require
			same_count: count = other.count
			not_empty: count > 0
		local
			mean_x, mean_y, l_sum: REAL_64
			i: INTEGER
		do
			mean_x := mean
			mean_y := other.mean
			from
				i := 1
				data.start
				other.data.start
			until
				data.after
			loop
				l_sum := l_sum + (data.item - mean_x) * (other.data.item - mean_y)
				data.forth
				other.data.forth
			end
			Result := l_sum / count
		end

	correlation (other: SIMPLE_STATISTICS): REAL_64
			-- Pearson correlation coefficient with `other`.
		require
			same_count: count = other.count
			not_empty: count > 0
			non_zero_variance: standard_deviation > 1.0e-10 and other.standard_deviation > 1.0e-10
		do
			Result := covariance (other) / (standard_deviation * other.standard_deviation)
		ensure
			valid_range: Result >= -1.0 and Result <= 1.0
		end

feature -- Regression

	linear_regression (other: SIMPLE_STATISTICS): TUPLE [slope: REAL_64; intercept: REAL_64; r_squared: REAL_64]
			-- Linear regression: y = slope*x + intercept.
			-- Current is x, `other` is y.
		require
			same_count: count = other.count
			at_least_two: count >= 2
		local
			mean_x, mean_y: REAL_64
			sum_xy, sum_xx: REAL_64
			l_slope, l_intercept, l_r: REAL_64
		do
			mean_x := mean
			mean_y := other.mean

			from
				data.start
				other.data.start
			until
				data.after
			loop
				sum_xy := sum_xy + (data.item - mean_x) * (other.data.item - mean_y)
				sum_xx := sum_xx + (data.item - mean_x) * (data.item - mean_x)
				data.forth
				other.data.forth
			end

			if sum_xx.abs > 1.0e-10 then
				l_slope := sum_xy / sum_xx
				l_intercept := mean_y - l_slope * mean_x
				if standard_deviation > 1.0e-10 and other.standard_deviation > 1.0e-10 then
					l_r := correlation (other)
				end
			end

			Result := [l_slope, l_intercept, l_r * l_r]
		end

feature -- Status report

	all_positive: BOOLEAN
			-- Are all values positive?
		do
			Result := True
			from data.start until data.after or not Result loop
				if data.item <= 0 then
					Result := False
				end
				data.forth
			end
		end

feature {NONE} -- Implementation

	sorted_data: ARRAYED_LIST [REAL_64]
			-- Sorted copy of data.
		local
			l_sorter: SIMPLE_SORTER [REAL_64]
		do
			-- Copy data to result
			create Result.make (count)
			from data.start until data.after loop
				Result.extend (data.item)
				data.forth
			end
			-- Sort using simple_sorter
			create l_sorter.make
			l_sorter.sort_by (Result, agent real_identity)
		end

	real_identity (a_value: REAL_64): REAL_64
			-- Identity function for REAL_64 key extraction.
		do
			Result := a_value
		end

invariant
	data_attached: data /= Void
	count_non_negative: count >= 0
	model_consistent: model.count = count

end
