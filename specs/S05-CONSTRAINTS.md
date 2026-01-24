# S05-CONSTRAINTS.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Numeric Constraints

### REAL_64 Precision

| Aspect | Value |
|--------|-------|
| Type | IEEE 754 double precision |
| Significant digits | ~15-17 |
| Smallest positive | ~2.2e-308 |
| Largest | ~1.8e+308 |
| Epsilon used | 1.0e-10 to 1.0e-15 |

### Tolerance Usage

| Context | Tolerance | Purpose |
|---------|-----------|---------|
| Equality comparison | 1.0e-10 | is_equal, is_zero |
| Invertibility check | 1.0e-10 | determinant threshold |
| Derivative check | 1.0e-15 | Newton-Raphson |
| Normalization check | 1.0e-10 | Unit length verification |

## 2. Dimension Constraints

### SIMPLE_VECTOR

| Constraint | Value | Enforcement |
|------------|-------|-------------|
| Minimum dimension | 1 | Precondition |
| Maximum dimension | Memory-limited | Practical ~10^6 |
| Index range | 1 to dimension | Precondition |

### SIMPLE_MATRIX

| Constraint | Value | Enforcement |
|------------|-------|-------------|
| Minimum rows | 1 | Precondition |
| Minimum cols | 1 | Precondition |
| Maximum size | Memory-limited | rows * cols elements |
| Row index range | 1 to rows | Precondition |
| Column index range | 1 to cols | Precondition |

### Operation Compatibility

| Operation | Constraint |
|-----------|------------|
| Vector + Vector | Same dimension |
| Vector dot Vector | Same dimension |
| Vector cross Vector | Both dimension = 3 |
| Matrix + Matrix | Same rows and cols |
| Matrix * Matrix | A.cols = B.rows |
| Matrix * Vector | M.cols = V.dimension |

## 3. Statistical Constraints

### Minimum Data Requirements

| Feature | Minimum count |
|---------|---------------|
| sum, mean, median, mode | 1 |
| variance, std_dev | 1 |
| sample_variance, sample_std_dev | 2 |
| geometric_mean, harmonic_mean | 1 (all positive) |
| covariance, correlation | 1 (same count) |
| linear_regression | 2 (same count) |

### Percentile Range

| Parameter | Valid Range |
|-----------|-------------|
| percentile p | 0 to 100 |
| quartile | 1, 2, or 3 |

## 4. Function Domain Constraints

### Trigonometric Inverse

| Function | Valid Input |
|----------|-------------|
| asin | [-1, 1] |
| acos | [-1, 1] |
| atan | Any REAL_64 |
| atan2 | Any y, x (handles x=0) |

### Logarithmic

| Function | Valid Input |
|----------|-------------|
| log | x > 0 |
| log10 | x > 0 |
| log2 | x > 0 |
| sqrt | x >= 0 |
| cbrt | Any (handles negative) |

### Special Cases

| Operation | Input | Result |
|-----------|-------|--------|
| pow(0, 0) | Base case | 1 (convention) |
| factorial(0) | Base case | 1 |
| gcd, lcm | Must be positive | Positive result |

## 5. Numerical Method Constraints

### Bisection Method

| Constraint | Requirement |
|------------|-------------|
| Interval | a < b |
| Sign change | f(a) * f(b) < 0 |
| Tolerance | > 0 |
| Max iterations | > 0 |

### Newton-Raphson

| Constraint | Requirement |
|------------|-------------|
| Initial guess | Any (affects convergence) |
| Derivative | Must not be zero near root |
| Tolerance | > 0 |
| Max iterations | > 0 |

### Simpson's Rule

| Constraint | Requirement |
|------------|-------------|
| Interval | a < b |
| Intervals | n > 0 and n is even |

## 6. Memory Constraints

### Storage Requirements

| Object | Memory |
|--------|--------|
| SIMPLE_VECTOR(n) | n * 8 bytes (REAL_64) |
| SIMPLE_MATRIX(m,n) | m * n * 8 bytes |
| SIMPLE_STATISTICS | Variable (list of REAL_64) |

### Practical Limits

| Object | Recommended Max |
|--------|-----------------|
| Vector dimension | 10,000 |
| Matrix size | 1000 x 1000 |
| Statistics count | 1,000,000 |

## 7. Computational Complexity

### Vector Operations

| Operation | Complexity |
|-----------|------------|
| Access item | O(1) |
| Add/Subtract | O(n) |
| Dot product | O(n) |
| Cross product | O(1) (3D only) |
| Magnitude | O(n) |
| Normalize | O(n) |

### Matrix Operations

| Operation | Complexity |
|-----------|------------|
| Access item | O(1) |
| Add/Subtract | O(m*n) |
| Multiply (A*B) | O(m*n*p) |
| Transpose | O(m*n) |
| Determinant | O(n^3) |
| Inverse | O(n^3) |

### Statistics Operations

| Operation | Complexity |
|-----------|------------|
| Add | O(1) |
| Sum, Mean | O(n) |
| Median | O(n log n) sorting |
| Mode | O(n) with hash |
| Variance | O(n) |
| Percentile | O(n log n) sorting |

## 8. Thread Safety

### Not Thread-Safe

All classes are NOT thread-safe. Concurrent access requires external synchronization.

### SCOOP Compatibility

Classes can be made separate for SCOOP:
```eiffel
separate math: SIMPLE_MATH
separate vector: SIMPLE_VECTOR
```

## 9. IEEE 754 Special Values

### Handling

| Value | Behavior |
|-------|----------|
| NaN | Propagates through operations |
| +Infinity | From overflow |
| -Infinity | From underflow |
| -0.0 | Treated as 0.0 |

### Not Explicitly Handled

The library does not have special NaN/Infinity checks. Users should validate inputs if needed.

---

*Generated as backwash specification from existing implementation.*
