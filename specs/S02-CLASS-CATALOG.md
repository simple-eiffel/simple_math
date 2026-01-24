# S02-CLASS-CATALOG.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Class Summary

| Class | Type | Role | LOC |
|-------|------|------|-----|
| SIMPLE_MATH | Effective | Main facade + numerical methods | ~500 |
| SIMPLE_VECTOR | Effective | N-dimensional vector | ~380 |
| SIMPLE_MATRIX | Effective | Matrix operations | ~670 |
| SIMPLE_STATISTICS | Effective | Statistical analysis | ~450 |

## 2. SIMPLE_MATH (Facade)

**Purpose:** Factory methods for creating vectors, matrices, statistics calculators, plus numerical constants and methods.

**Creation:** `make`

**Feature Groups:**

| Group | Features | Purpose |
|-------|----------|---------|
| Vector Factory | new_vector, new_vector_from_array, new_vector_2d, new_vector_3d | Create vectors |
| Matrix Factory | new_matrix, new_matrix_from_array, new_identity_matrix | Create matrices |
| Statistics Factory | new_statistics, new_statistics_from_array | Create statistics |
| Constants | pi, e, golden_ratio, sqrt_2 | Mathematical constants |
| Trigonometric | sin, cos, tan, asin, acos, atan, atan2 | Trig functions |
| Angle Conversion | degrees_to_radians, radians_to_degrees | Unit conversion |
| Exponential | exp, log, log10, log2, pow, sqrt, cbrt | Exp/log functions |
| Root Finding | bisection, newton_raphson | Find function zeros |
| Integration | trapezoidal, simpson | Numerical integration |
| Interpolation | linear_interpolate, lagrange_interpolate | Polynomial interpolation |
| Utility | factorial, binomial, gcd, lcm, clamp, lerp, is_close | Helper functions |

## 3. SIMPLE_VECTOR

**Purpose:** N-dimensional vector for linear algebra operations.

**Creation Procedures:**
- `make (a_dimension)` - Zero vector
- `make_from_array (a_values)` - From array
- `make_zero (a_dimension)` - Explicit zero vector
- `make_unit (a_dimension, a_index)` - Unit vector with 1 at index

**Feature Groups:**

| Group | Features | Purpose |
|-------|----------|---------|
| Model | model | MML_SEQUENCE model for contracts |
| Access | dimension, item [], elements | Read elements |
| Element Change | put | Modify elements |
| Status | is_zero, is_equal | State queries |
| Basic Operations | plus +, minus -, scaled *, negated - | Arithmetic |
| Products | dot, cross | Vector products |
| Metrics | magnitude, magnitude_squared, distance, normalized | Lengths and norms |
| Statistics | sum, mean, min, max | Element statistics |
| Conversion | to_array, out | Output |

## 4. SIMPLE_MATRIX

**Purpose:** Matrix class for linear algebra operations.

**Creation Procedures:**
- `make (a_rows, a_cols)` - Zero matrix
- `make_from_array (a_rows, a_cols, a_values)` - From row-major array
- `make_identity (a_size)` - Identity matrix
- `make_zero (a_rows, a_cols)` - Explicit zero matrix

**Feature Groups:**

| Group | Features | Purpose |
|-------|----------|---------|
| Model | model | MML_SEQUENCE[MML_SEQUENCE] for contracts |
| Access | rows, cols, item [], row, column, diagonal | Read elements |
| Element Change | put, set_row, set_column | Modify elements |
| Status | is_square, is_symmetric, is_diagonal, is_identity, is_equal | State queries |
| Basic Operations | plus +, minus -, product *, scaled | Arithmetic |
| Vector Operations | multiply_vector | Matrix-vector product |
| Transformations | transposed | Matrix transpose |
| Linear Algebra | trace, determinant, inverse | Advanced operations |
| Conversion | out | String output |

## 5. SIMPLE_STATISTICS

**Purpose:** Statistical functions for data analysis.

**Creation:** `make`

**Feature Groups:**

| Group | Features | Purpose |
|-------|----------|---------|
| Model | model | MML_SEQUENCE for contracts |
| Access | count, data | Data access |
| Element Change | add, add_all, clear | Modify data |
| Central Tendency | sum, mean, median, mode, geometric_mean, harmonic_mean | Averages |
| Dispersion | variance, sample_variance, standard_deviation, sample_standard_deviation, range, coefficient_of_variation | Spread measures |
| Extremes | minimum, maximum | Min/max values |
| Percentiles | percentile, quartile_1, quartile_2, quartile_3, interquartile_range | Position measures |
| Correlation | covariance, correlation | Relationship measures |
| Regression | linear_regression | Fitting |
| Status | all_positive | Data queries |

## 6. Class Relationships

```
SIMPLE_MATH (facade)
    |
    +-- creates --> SIMPLE_VECTOR
    +-- creates --> SIMPLE_MATRIX
    +-- creates --> SIMPLE_STATISTICS

SIMPLE_MATRIX
    |
    +-- uses --> SIMPLE_VECTOR (row, column, multiply_vector)

SIMPLE_STATISTICS
    |
    +-- uses --> SIMPLE_SORTER (for median, percentiles)
```

---

*Generated as backwash specification from existing implementation.*
