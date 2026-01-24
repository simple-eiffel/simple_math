# S06-BOUNDARIES.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Input Boundaries

### Dimension Inputs

| Input | Boundary | Behavior |
|-------|----------|----------|
| dimension = 0 | Invalid | Precondition violation |
| dimension = 1 | Valid | Scalar-like vector |
| dimension = 3 | Valid | 3D vector (cross product works) |
| dimension = 10000 | Valid | Large but practical |
| dimension = 10^9 | Valid | May cause memory issues |

### Index Inputs

| Input | Boundary | Behavior |
|-------|----------|----------|
| index = 0 | Invalid | Precondition violation |
| index = 1 | Valid | First element |
| index = dimension | Valid | Last element |
| index = dimension + 1 | Invalid | Precondition violation |

### Numeric Inputs

| Input | Boundary | Behavior |
|-------|----------|----------|
| x = 0.0 | Valid | Special handling in some ops |
| x = -0.0 | Valid | Same as 0.0 |
| x = 1.0e-400 | Underflow | Becomes 0.0 |
| x = 1.0e+400 | Overflow | Becomes Infinity |
| x = NaN | Valid | Propagates |

## 2. Output Boundaries

### Vector Operations

| Operation | Edge Case | Result |
|-----------|-----------|--------|
| magnitude(zero vector) | All zeros | 0.0 |
| normalized(zero vector) | Invalid | Precondition violation |
| dot(orthogonal) | Perpendicular | 0.0 |
| cross(parallel) | Same direction | Zero vector |

### Matrix Operations

| Operation | Edge Case | Result |
|-----------|-----------|--------|
| determinant(singular) | Not invertible | 0.0 |
| inverse(singular) | Invalid | Precondition violation |
| trace(1x1) | Single element | That element |
| product(1xn * nx1) | Scalars | 1x1 matrix |

### Statistics Operations

| Operation | Edge Case | Result |
|-----------|-----------|--------|
| mean(single value) | n=1 | That value |
| variance(single value) | n=1 | 0.0 |
| sample_variance(single) | n=1 | Precondition violation |
| median(even count) | n even | Average of middle two |
| mode(all unique) | No repetition | First value |

## 3. Mathematical Boundaries

### Trigonometric

| Input | sin | cos | tan |
|-------|-----|-----|-----|
| 0 | 0 | 1 | 0 |
| pi/2 | 1 | ~0 | large |
| pi | ~0 | -1 | ~0 |
| 3pi/2 | -1 | ~0 | large |
| 2pi | ~0 | 1 | ~0 |

### Inverse Trigonometric

| Input | asin | acos | Result Range |
|-------|------|------|--------------|
| -1 | -pi/2 | pi | Valid |
| 0 | 0 | pi/2 | Valid |
| 1 | pi/2 | 0 | Valid |
| <-1 | Invalid | Invalid | Precondition |
| >1 | Invalid | Invalid | Precondition |

### Logarithmic

| Input | log | Behavior |
|-------|-----|----------|
| 0 | -Infinity | Allowed (IEEE 754) |
| Negative | NaN | Allowed (IEEE 754) |
| 1 | 0 | Exact |
| e | 1 | Near 1.0 |

## 4. Statistical Boundaries

### Correlation Coefficient

| Condition | correlation | Meaning |
|-----------|-------------|---------|
| Perfect positive | 1.0 | Exact linear positive |
| Perfect negative | -1.0 | Exact linear negative |
| No correlation | 0.0 | No linear relationship |
| Constant data | Undefined | Zero variance (precondition) |

### Percentiles

| Percentile | Equivalent |
|------------|------------|
| 0 | minimum |
| 25 | quartile_1 |
| 50 | median |
| 75 | quartile_3 |
| 100 | maximum |

### Linear Regression

| Condition | slope | r_squared |
|-----------|-------|-----------|
| Perfect fit | Exact | 1.0 |
| No correlation | 0 | 0.0 |
| Vertical line | Undefined | 0.0 (handled) |

## 5. Numerical Method Boundaries

### Bisection

| Condition | Behavior |
|-----------|----------|
| f(a) = 0 | Returns a immediately |
| f(b) = 0 | Converges to b |
| Same sign at ends | Precondition violation |
| Multiple roots | Finds one |
| No root (tangent) | Would violate precondition |

### Newton-Raphson

| Condition | Behavior |
|-----------|----------|
| Good initial guess | Fast convergence |
| Poor initial guess | May diverge |
| df(x) = 0 | Exits (derivative too small) |
| Multiple roots | Finds nearest |

### Integration

| Condition | Accuracy |
|-----------|----------|
| Smooth function | Good |
| Discontinuity | Poor |
| Oscillating | May need many intervals |
| Unbounded | May overflow |

## 6. Interpolation Boundaries

### Linear Interpolation

| Condition | Behavior |
|-----------|----------|
| x = x1 | Returns y1 |
| x = x2 | Returns y2 |
| x1 = x2 | Precondition violation |
| x outside [x1,x2] | Extrapolates |

### Lagrange Interpolation

| Condition | Behavior |
|-----------|----------|
| x at a point | Returns that y |
| Duplicate x values | Undefined (division by zero) |
| Many points | Runge's phenomenon possible |

## 7. Array Boundaries

### make_from_array

| Input | Behavior |
|-------|----------|
| Empty array | Precondition violation |
| Array with 1 element | Creates 1D vector |
| Array lower != 1 | Handled (copies from lower) |

### Matrix make_from_array

| Input | Behavior |
|-------|----------|
| Wrong size | Precondition violation |
| Exact size | Creates matrix |
| Row-major order | Required |

## 8. Capacity Boundaries

### Factorial

| Input | factorial | Notes |
|-------|-----------|-------|
| 0 | 1 | By definition |
| 1 | 1 | Base case |
| 12 | 479001600 | Fits INTEGER_32 |
| 20 | 2432902008176640000 | Fits INTEGER_64 |
| 21 | Overflow | Exceeds INTEGER_64 |

### Binomial

| Input | binomial | Notes |
|-------|----------|-------|
| C(0,0) | 1 | Edge case |
| C(n,0) | 1 | Always 1 |
| C(n,n) | 1 | Always 1 |
| C(20,10) | 184756 | Typical |
| Large n,k | May overflow | Use factorial |

---

*Generated as backwash specification from existing implementation.*
