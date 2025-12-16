# simple_math

Scientific computing for Eiffel: vectors, matrices, statistics, numerical methods.

## Features

- **SIMPLE_VECTOR** - N-dimensional vectors with arithmetic, dot/cross products, normalization
- **SIMPLE_MATRIX** - Matrix operations, determinant, inverse, LU decomposition
- **SIMPLE_STATISTICS** - Mean, median, variance, correlation, regression
- **SIMPLE_MATH** - Facade with trig, exp/log, integration, root finding, interpolation

## Installation

Set the ecosystem environment variable (one-time setup for all simple_* libraries):
```bash
# Windows
set SIMPLE_EIFFEL=D:\prod

# Linux/macOS
export SIMPLE_EIFFEL=/path/to/prod
```

Add to your ECF file:
```xml
<library name="simple_math" location="$SIMPLE_EIFFEL/simple_math/simple_math.ecf"/>
```

## Quick Start

```eiffel
local
    math: SIMPLE_MATH
    v1, v2: SIMPLE_VECTOR
    m: SIMPLE_MATRIX
    stats: SIMPLE_STATISTICS
do
    create math.make

    -- Vectors
    v1 := math.new_vector_3d (1.0, 2.0, 3.0)
    v2 := math.new_vector_3d (4.0, 5.0, 6.0)
    print (v1.dot (v2))  -- 32.0
    print (v1.magnitude) -- 3.74...

    -- Matrices
    m := math.new_identity_matrix (3)
    print (m.determinant) -- 1.0

    -- Statistics
    stats := math.new_statistics_from_array (<<1.0, 2.0, 3.0, 4.0, 5.0>>)
    print (stats.mean)               -- 3.0
    print (stats.standard_deviation) -- 1.41...

    -- Numerical methods
    print (math.sin (math.pi / 2))   -- 1.0
    print (math.sqrt (2.0))          -- 1.41...
    print (math.factorial (5))       -- 120
end
```

## API Overview

### Vectors

```eiffel
v := math.new_vector (3)              -- Zero vector
v := math.new_vector_from_array (<<1.0, 2.0, 3.0>>)
v := math.new_vector_2d (x, y)
v := math.new_vector_3d (x, y, z)

v1 + v2                  -- Addition
v1 - v2                  -- Subtraction
v1 * 2.0                 -- Scalar multiply
v1.dot (v2)              -- Dot product
v1.cross (v2)            -- Cross product (3D)
v.magnitude              -- Euclidean length
v.normalized             -- Unit vector
v.sum, v.mean, v.min, v.max
```

### Matrices

```eiffel
m := math.new_matrix (rows, cols)
m := math.new_matrix_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
m := math.new_identity_matrix (n)

m1 + m2                  -- Addition
m1 * m2                  -- Multiplication
m.scaled (2.0)           -- Scalar multiply
m.transposed             -- Transpose
m.multiply_vector (v)    -- Matrix-vector multiply
m.trace                  -- Sum of diagonal
m.determinant            -- Determinant
m.inverse                -- Matrix inverse
m.is_square, m.is_symmetric, m.is_diagonal
```

### Statistics

```eiffel
stats := math.new_statistics_from_array (<<...>>)

stats.mean, stats.median, stats.mode
stats.variance, stats.standard_deviation
stats.minimum, stats.maximum, stats.range
stats.percentile (75)    -- 75th percentile
stats.quartile_1, stats.quartile_3
stats.correlation (other_stats)
stats.linear_regression (y_stats)  -- Returns [slope, intercept, r_squared]
```

### Numerical Methods

```eiffel
-- Trigonometry
math.sin (x), math.cos (x), math.tan (x)
math.asin (x), math.acos (x), math.atan (x)
math.degrees_to_radians (d), math.radians_to_degrees (r)

-- Exponential/Logarithmic
math.exp (x), math.log (x), math.log10 (x), math.log2 (x)
math.pow (base, exp), math.sqrt (x), math.cbrt (x)

-- Integration
math.trapezoidal (f, a, b, n)   -- Trapezoidal rule
math.simpson (f, a, b, n)       -- Simpson's rule

-- Root finding
math.bisection (f, a, b, tol, max_iter)
math.newton_raphson (f, df, x0, tol, max_iter)

-- Interpolation
math.linear_interpolate (x1, y1, x2, y2, x)
math.lagrange_interpolate (x_points, y_points, x)

-- Utilities
math.factorial (n), math.binomial (n, k)
math.gcd (a, b), math.lcm (a, b)
math.clamp (val, min, max), math.lerp (a, b, t)
```

### Constants

```eiffel
math.pi           -- 3.14159...
math.e            -- 2.71828...
math.golden_ratio -- 1.61803...
math.sqrt_2       -- 1.41421...
```

## Tests

46 tests covering vectors, matrices, statistics, and numerical methods.

## License

MIT License - Copyright (c) 2024-2025, Larry Rix
