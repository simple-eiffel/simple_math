# S04-FEATURE-SPECS.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. SIMPLE_MATH Features

### Mathematical Constants

| Constant | Value | Precision |
|----------|-------|-----------|
| pi | 3.14159265358979323846 | ~20 digits |
| e | 2.71828182845904523536 | ~20 digits |
| golden_ratio | 1.61803398874989484820 | ~20 digits |
| sqrt_2 | 1.41421356237309504880 | ~20 digits |

### Trigonometric Functions

```eiffel
sin (x: REAL_64): REAL_64
    -- Sine of x (radians)

cos (x: REAL_64): REAL_64
    -- Cosine of x (radians)

tan (x: REAL_64): REAL_64
    -- Tangent of x (radians)

asin (x: REAL_64): REAL_64
    -- Arc sine of x (returns radians)
    require
        valid_range: x >= -1.0 and x <= 1.0

acos (x: REAL_64): REAL_64
    -- Arc cosine of x (returns radians)
    require
        valid_range: x >= -1.0 and x <= 1.0

atan (x: REAL_64): REAL_64
    -- Arc tangent of x (returns radians)

atan2 (y, x: REAL_64): REAL_64
    -- Arc tangent of y/x using signs to determine quadrant
```

### Angle Conversion

```eiffel
degrees_to_radians (d: REAL_64): REAL_64
    -- Convert degrees to radians

radians_to_degrees (r: REAL_64): REAL_64
    -- Convert radians to degrees
```

### Exponential and Logarithmic

```eiffel
exp (x: REAL_64): REAL_64
    -- e raised to power x

log (x: REAL_64): REAL_64
    -- Natural logarithm
    require positive: x > 0

log10 (x: REAL_64): REAL_64
    -- Base-10 logarithm
    require positive: x > 0

log2 (x: REAL_64): REAL_64
    -- Base-2 logarithm
    require positive: x > 0

pow (base, exponent: REAL_64): REAL_64
    -- base raised to exponent

sqrt (x: REAL_64): REAL_64
    -- Square root
    require non_negative: x >= 0

cbrt (x: REAL_64): REAL_64
    -- Cube root (handles negative values)
```

### Root Finding

```eiffel
bisection (f: FUNCTION [REAL_64, REAL_64]; a, b: REAL_64;
           tolerance: REAL_64; max_iterations: INTEGER): REAL_64
    -- Find root of f in [a,b] using bisection method
    require
        valid_interval: a < b
        opposite_signs: f.item ([a]) * f.item ([b]) < 0
        positive_tolerance: tolerance > 0
        positive_iterations: max_iterations > 0

newton_raphson (f, df: FUNCTION [REAL_64, REAL_64]; x0: REAL_64;
               tolerance: REAL_64; max_iterations: INTEGER): REAL_64
    -- Find root using Newton-Raphson method
    -- f is the function, df is its derivative
    require
        positive_tolerance: tolerance > 0
        positive_iterations: max_iterations > 0
```

### Numerical Integration

```eiffel
trapezoidal (f: FUNCTION [REAL_64, REAL_64]; a, b: REAL_64;
             n: INTEGER): REAL_64
    -- Integrate f from a to b using trapezoidal rule with n intervals
    require
        valid_interval: a < b
        positive_intervals: n > 0

simpson (f: FUNCTION [REAL_64, REAL_64]; a, b: REAL_64;
         n: INTEGER): REAL_64
    -- Integrate f from a to b using Simpson's rule with n intervals
    require
        valid_interval: a < b
        even_intervals: n > 0 and n \\ 2 = 0
```

### Interpolation

```eiffel
linear_interpolate (x1, y1, x2, y2, x: REAL_64): REAL_64
    -- Linear interpolation at x
    require
        different_x: (x2 - x1).abs > 1.0e-15

lagrange_interpolate (x_points, y_points: ARRAY [REAL_64];
                      x: REAL_64): REAL_64
    -- Lagrange polynomial interpolation at x
    require
        same_count: x_points.count = y_points.count
        not_empty: x_points.count > 0
```

### Utility Functions

```eiffel
factorial (n: INTEGER): INTEGER_64
    -- Factorial of n
    require non_negative: n >= 0

binomial (n, k: INTEGER): INTEGER_64
    -- Binomial coefficient C(n,k)
    require valid_n: n >= 0; valid_k: k >= 0 and k <= n

gcd (a, b: INTEGER): INTEGER
    -- Greatest common divisor
    require positive_a: a > 0; positive_b: b > 0
    ensure positive: Result > 0

lcm (a, b: INTEGER): INTEGER
    -- Least common multiple
    require positive_a: a > 0; positive_b: b > 0
    ensure positive: Result > 0

clamp (value, min_val, max_val: REAL_64): REAL_64
    -- Clamp value to [min_val, max_val]
    require valid_range: min_val <= max_val
    ensure in_range: Result >= min_val and Result <= max_val

lerp (a, b, t: REAL_64): REAL_64
    -- Linear interpolation between a and b at parameter t

is_close (a, b: REAL_64; tolerance: REAL_64): BOOLEAN
    -- Are a and b within tolerance?
    require positive_tolerance: tolerance >= 0
```

## 2. SIMPLE_VECTOR Features

### Creation

```eiffel
make (a_dimension: INTEGER)
    -- Create zero vector of dimension n
    require positive_dimension: a_dimension > 0
    ensure dimension_set, all_zero

make_from_array (a_values: ARRAY [REAL_64])
    -- Create vector from array values
    require values_not_empty: a_values.count > 0
    ensure dimension_set: dimension = a_values.count

make_unit (a_dimension: INTEGER; a_index: INTEGER)
    -- Create unit vector with 1 at a_index
    require positive_dimension, valid_index
    ensure dimension_set, unit_at_index: item (a_index) = 1.0
```

### Arithmetic Operations

| Operation | Operator | Returns |
|-----------|----------|---------|
| Addition | + | New SIMPLE_VECTOR |
| Subtraction | - | New SIMPLE_VECTOR |
| Scalar multiply | * | New SIMPLE_VECTOR |
| Negation | - (prefix) | New SIMPLE_VECTOR |

### Vector Products

```eiffel
dot (other: SIMPLE_VECTOR): REAL_64
    -- Dot product (scalar product)
    require same_dimension

cross (other: SIMPLE_VECTOR): SIMPLE_VECTOR
    -- Cross product (3D only)
    require three_dimensional
    ensure result_dimension: Result.dimension = 3
```

### Metrics

```eiffel
magnitude: REAL_64
    -- Euclidean length ||v||

magnitude_squared: REAL_64
    -- Square of magnitude (avoids sqrt)

distance (other: SIMPLE_VECTOR): REAL_64
    -- Euclidean distance to other
    require same_dimension

normalized: SIMPLE_VECTOR
    -- Unit vector in same direction
    require not_zero: not is_zero
    ensure unit_length: (Result.magnitude - 1.0).abs < 1.0e-10
```

### Element Statistics

```eiffel
sum: REAL_64
    -- Sum of all elements

mean: REAL_64
    -- Arithmetic mean of elements

min: REAL_64
    -- Minimum element

max: REAL_64
    -- Maximum element
```

## 3. SIMPLE_MATRIX Features

### Creation

```eiffel
make (a_rows, a_cols: INTEGER)
    -- Create zero matrix
    require positive_rows, positive_cols

make_from_array (a_rows, a_cols: INTEGER; a_values: ARRAY [REAL_64])
    -- Create from row-major array
    require positive_rows, positive_cols, correct_size

make_identity (a_size: INTEGER)
    -- Create identity matrix
    require positive_size
    ensure square, size_set
```

### Row/Column Access

```eiffel
row (i: INTEGER): SIMPLE_VECTOR
    -- Row i as vector
    require valid_row
    ensure correct_dimension: Result.dimension = cols

column (j: INTEGER): SIMPLE_VECTOR
    -- Column j as vector
    require valid_col
    ensure correct_dimension: Result.dimension = rows

diagonal: SIMPLE_VECTOR
    -- Main diagonal
    require is_square
    ensure correct_dimension: Result.dimension = rows
```

### Arithmetic Operations

| Operation | Method/Operator | Result |
|-----------|-----------------|--------|
| Addition | + | New SIMPLE_MATRIX |
| Subtraction | - | New SIMPLE_MATRIX |
| Matrix multiply | * | New SIMPLE_MATRIX |
| Scalar multiply | scaled | New SIMPLE_MATRIX |
| Matrix-vector | multiply_vector | SIMPLE_VECTOR |
| Transpose | transposed | New SIMPLE_MATRIX |

### Linear Algebra

```eiffel
trace: REAL_64
    -- Sum of diagonal elements
    require is_square

determinant: REAL_64
    -- Determinant using LU decomposition
    require is_square

inverse: SIMPLE_MATRIX
    -- Matrix inverse using Gauss-Jordan elimination
    require is_square, is_invertible
    ensure result_rows, result_cols
```

### Status Queries

| Query | Returns | Description |
|-------|---------|-------------|
| is_square | BOOLEAN | rows = cols |
| is_symmetric | BOOLEAN | A = A^T |
| is_diagonal | BOOLEAN | Only diagonal non-zero |
| is_identity | BOOLEAN | Diagonal = 1, rest = 0 |

## 4. SIMPLE_STATISTICS Features

### Data Management

```eiffel
add (a_value: REAL_64)
    -- Add single value
    ensure count_increased

add_all (a_values: ARRAY [REAL_64])
    -- Add all values from array
    ensure count_increased

clear
    -- Remove all data
    ensure empty: count = 0
```

### Central Tendency

| Feature | Description | Precondition |
|---------|-------------|--------------|
| sum | Sum of all values | not_empty |
| mean | Arithmetic mean | not_empty |
| median | Middle value | not_empty |
| mode | Most frequent | not_empty |
| geometric_mean | nth root of product | not_empty, all_positive |
| harmonic_mean | Reciprocal of mean of reciprocals | not_empty, all_positive |

### Dispersion

| Feature | Description | Precondition |
|---------|-------------|--------------|
| variance | Population variance | not_empty |
| sample_variance | Sample variance (n-1) | at_least_two |
| standard_deviation | Population std dev | not_empty |
| sample_standard_deviation | Sample std dev | at_least_two |
| range | max - min | not_empty |
| coefficient_of_variation | std_dev / mean | not_empty, mean_not_zero |

### Percentiles

```eiffel
percentile (p: REAL_64): REAL_64
    -- Value at percentile p (0-100)
    require not_empty, valid_percentile: p >= 0 and p <= 100

quartile_1: REAL_64    -- 25th percentile
quartile_2: REAL_64    -- 50th percentile (median)
quartile_3: REAL_64    -- 75th percentile
interquartile_range: REAL_64  -- Q3 - Q1
```

### Correlation and Regression

```eiffel
covariance (other: SIMPLE_STATISTICS): REAL_64
    -- Population covariance
    require same_count, not_empty

correlation (other: SIMPLE_STATISTICS): REAL_64
    -- Pearson correlation coefficient
    require same_count, not_empty, non_zero_variance
    ensure valid_range: Result >= -1.0 and Result <= 1.0

linear_regression (other: SIMPLE_STATISTICS):
    TUPLE [slope: REAL_64; intercept: REAL_64; r_squared: REAL_64]
    -- Linear regression: y = slope*x + intercept
    -- Current is x, other is y
    require same_count, at_least_two
```

---

*Generated as backwash specification from existing implementation.*
