# S03-CONTRACTS.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Class Invariants

### SIMPLE_VECTOR

```eiffel
invariant
    positive_dimension: dimension > 0
    elements_match: elements.count = dimension
    elements_attached: elements /= Void
    model_consistent: model.count = dimension
```

### SIMPLE_MATRIX

```eiffel
invariant
    positive_rows: rows > 0
    positive_cols: cols > 0
    data_size: data.count = rows * cols
    data_attached: data /= Void
    model_rows: model.count = rows
    model_cols: across 1 |..| rows as idx all model [idx].count = cols end
```

### SIMPLE_STATISTICS

```eiffel
invariant
    data_attached: data /= Void
    count_non_negative: count >= 0
    model_consistent: model.count = count
```

## 2. SIMPLE_MATH Contracts

### Vector Factory

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| new_vector | positive_dimension: a_dimension > 0 | dimension_set: Result.dimension = a_dimension |
| new_vector_from_array | not_empty: a_values.count > 0 | dimension_set: Result.dimension = a_values.count |
| new_vector_2d | (none) | dimension_2: Result.dimension = 2 |
| new_vector_3d | (none) | dimension_3: Result.dimension = 3 |

### Matrix Factory

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| new_matrix | positive_rows, positive_cols | rows_set, cols_set |
| new_matrix_from_array | positive_rows, positive_cols, correct_size: a_values.count = a_rows * a_cols | rows_set, cols_set |
| new_identity_matrix | positive_size: a_size > 0 | square: Result.rows = Result.cols, size_set |

### Statistics Factory

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| new_statistics | (none) | (none) |
| new_statistics_from_array | (none) | count_set: Result.count = a_values.count |

### Trigonometric Functions

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| asin | valid_range: x >= -1.0 and x <= 1.0 | (none) |
| acos | valid_range: x >= -1.0 and x <= 1.0 | (none) |

### Logarithmic Functions

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| log | positive: x > 0 | (none) |
| log10 | positive: x > 0 | (none) |
| log2 | positive: x > 0 | (none) |
| sqrt | non_negative: x >= 0 | (none) |

### Root Finding

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| bisection | valid_interval: a < b, opposite_signs: f(a) * f(b) < 0, positive_tolerance, positive_iterations | (none) |
| newton_raphson | positive_tolerance, positive_iterations | (none) |

### Integration

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| trapezoidal | valid_interval: a < b, positive_intervals: n > 0 | (none) |
| simpson | valid_interval: a < b, even_intervals: n > 0 and n \\ 2 = 0 | (none) |

### Utility

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| factorial | non_negative: n >= 0 | (none) |
| binomial | valid_n: n >= 0, valid_k: k >= 0 and k <= n | (none) |
| gcd | positive_a, positive_b | positive: Result > 0 |
| lcm | positive_a, positive_b | positive: Result > 0 |
| clamp | valid_range: min_val <= max_val | in_range: Result >= min_val and Result <= max_val |

## 3. SIMPLE_VECTOR Contracts

### Creation

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| make | positive_dimension: a_dimension > 0 | dimension_set, all_zero: is_zero |
| make_from_array | values_not_empty: a_values.count > 0 | dimension_set: dimension = a_values.count |
| make_zero | positive_dimension | dimension_set, is_zero |
| make_unit | positive_dimension, valid_index: a_index >= 1 and a_index <= a_dimension | dimension_set, unit_at_index: item(a_index) = 1.0 |

### Element Access/Change

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| item [] | valid_index: i >= 1 and i <= dimension | (none) |
| put | valid_index: i >= 1 and i <= dimension | value_set, model_updated, dimension_unchanged |

### Operations

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| plus + | same_dimension: dimension = other.dimension | result_dimension, elementwise_sum |
| minus - | same_dimension | result_dimension, elementwise_diff |
| scaled * | (none) | result_dimension, elementwise_scaled |
| negated - | (none) | result_dimension, elementwise_negated |
| dot | same_dimension | (none) |
| cross | three_dimensional: dimension = 3 and other.dimension = 3 | result_dimension: Result.dimension = 3, cross_x, cross_y, cross_z |
| normalized | not_zero: not is_zero | result_dimension, unit_length: (Result.magnitude - 1.0).abs < 1.0e-10 |
| distance | same_dimension | (none) |

### Conversion

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| to_array | (none) | same_count: Result.count = dimension |

## 4. SIMPLE_MATRIX Contracts

### Creation

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| make | positive_rows, positive_cols | rows_set, cols_set |
| make_from_array | positive_rows, positive_cols, correct_size | rows_set, cols_set |
| make_identity | positive_size | square, size_set |
| make_zero | positive_rows, positive_cols | rows_set, cols_set |

### Element Access/Change

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| item [] | valid_row, valid_col | (none) |
| put | valid_row, valid_col | value_set, dimensions_unchanged |
| row | valid_row | correct_dimension: Result.dimension = cols |
| column | valid_col | correct_dimension: Result.dimension = rows |
| diagonal | is_square | correct_dimension: Result.dimension = rows |
| set_row | valid_row, correct_dimension | row_set, dimensions_unchanged |
| set_column | valid_col, correct_dimension | column_set, dimensions_unchanged |

### Operations

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| plus + | same_rows, same_cols | result_rows, result_cols, elementwise_sum |
| minus - | same_rows, same_cols | result_rows, result_cols, elementwise_diff |
| product * | compatible: cols = other.rows | result_rows: Result.rows = rows, result_cols: Result.cols = other.cols |
| scaled | (none) | result_rows, result_cols, elementwise_scaled |
| multiply_vector | compatible: cols = a_vector.dimension | result_dimension: Result.dimension = rows |
| transposed | (none) | result_rows: Result.rows = cols, result_cols: Result.cols = rows, transposed_elements |

### Linear Algebra

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| trace | is_square | (none) |
| determinant | is_square | (none) |
| inverse | is_square, is_invertible: determinant.abs > 1.0e-10 | result_rows: Result.rows = rows, result_cols: Result.cols = cols |

## 5. SIMPLE_STATISTICS Contracts

### Element Change

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| add | (none) | count_increased, model_extended |
| add_all | (none) | count_increased: count = old count + a_values.count |
| clear | (none) | empty: count = 0, model_empty |

### Central Tendency

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| sum | not_empty: count > 0 | (none) |
| mean | not_empty | (none) |
| median | not_empty | (none) |
| mode | not_empty | (none) |
| geometric_mean | not_empty, all_positive | (none) |
| harmonic_mean | not_empty, all_positive | (none) |

### Dispersion

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| variance | not_empty | (none) |
| sample_variance | at_least_two: count >= 2 | (none) |
| standard_deviation | not_empty | (none) |
| sample_standard_deviation | at_least_two | (none) |
| range | not_empty | (none) |
| coefficient_of_variation | not_empty, mean_not_zero | (none) |

### Extremes

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| minimum | not_empty | (none) |
| maximum | not_empty | (none) |

### Percentiles

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| percentile | not_empty, valid_percentile: p >= 0 and p <= 100 | (none) |
| quartile_1 | not_empty | (none) |
| quartile_2 | not_empty | (none) |
| quartile_3 | not_empty | (none) |
| interquartile_range | not_empty | (none) |

### Correlation

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| covariance | same_count, not_empty | (none) |
| correlation | same_count, not_empty, non_zero_variance | valid_range: Result >= -1.0 and Result <= 1.0 |

### Regression

| Feature | Precondition | Postcondition |
|---------|--------------|---------------|
| linear_regression | same_count, at_least_two | (none) |

## 6. Contract Philosophy

### Design by Contract Principles

1. **Dimension Safety:** All operations require compatible dimensions. This catches programming errors at contract check time rather than producing wrong results.

2. **Non-Zero Constraints:** Operations like inverse, normalized require non-zero inputs. The `is_invertible` query allows checking before calling inverse.

3. **Data Presence:** Statistics operations require data (count > 0). Sample statistics need at least 2 points.

4. **Model Consistency:** MML_SEQUENCE models allow formal verification of operations.

5. **Postcondition Verification:** Many operations have comprehensive postconditions that verify correctness (e.g., elementwise_sum, unit_length).

---

*Generated as backwash specification from existing implementation.*
