# S07-SPEC-SUMMARY.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Library Purpose

simple_math provides mathematical operations for Eiffel applications:

- **Vectors:** N-dimensional vectors with arithmetic, products, metrics
- **Matrices:** Matrix operations and linear algebra (determinant, inverse)
- **Statistics:** Descriptive statistics, correlation, regression
- **Numerical Methods:** Root finding, integration, interpolation
- **Utilities:** Trigonometry, logarithms, combinatorics

Design principles:
- Pure Eiffel (no external C dependencies)
- Contract-based dimension safety
- MML model integration for formal verification
- Simple API, complex internals

## 2. API Summary

### Four Classes

| Class | Purpose | Key Operations |
|-------|---------|----------------|
| SIMPLE_MATH | Facade + numerics | Factory methods, trig, log, integration |
| SIMPLE_VECTOR | N-dimensional vector | +, -, dot, cross, normalized |
| SIMPLE_MATRIX | Matrix algebra | *, transpose, determinant, inverse |
| SIMPLE_STATISTICS | Data analysis | mean, std_dev, correlation, regression |

### Factory Methods (SIMPLE_MATH)

```eiffel
math: SIMPLE_MATH
create math.make

v := math.new_vector_3d (1.0, 2.0, 3.0)
m := math.new_identity_matrix (3)
s := math.new_statistics_from_array (<<1.0, 2.0, 3.0, 4.0, 5.0>>)
```

## 3. Contract Highlights

### Key Invariants

- Vector: dimension > 0, elements.count = dimension
- Matrix: rows > 0, cols > 0, data.count = rows * cols
- Statistics: count >= 0

### Key Preconditions

- Dimension matching for vector/matrix operations
- Non-zero for normalization and inverse
- Valid ranges for trig inverse, logarithms
- Data presence for statistics

### Key Postconditions

- Dimension preservation in arithmetic
- Unit length after normalization
- Correlation in [-1, 1]

## 4. Usage Patterns

### Vector Operations

```eiffel
v1 := math.new_vector_3d (1.0, 0.0, 0.0)
v2 := math.new_vector_3d (0.0, 1.0, 0.0)

sum := v1 + v2                    -- [1, 1, 0]
dot := v1.dot (v2)                -- 0.0 (orthogonal)
cross := v1.cross (v2)            -- [0, 0, 1]
len := v1.magnitude               -- 1.0
unit := v1.normalized             -- Same as v1
```

### Matrix Operations

```eiffel
a := math.new_matrix_from_array (2, 2, <<1.0, 2.0, 3.0, 4.0>>)
b := math.new_identity_matrix (2)

c := a * b                        -- Same as a
det := a.determinant              -- -2.0
inv := a.inverse                  -- [[-2, 1], [1.5, -0.5]]
trans := a.transposed             -- [[1, 3], [2, 4]]
```

### Statistics

```eiffel
stats := math.new_statistics_from_array (<<1.0, 2.0, 3.0, 4.0, 5.0>>)

avg := stats.mean                 -- 3.0
med := stats.median               -- 3.0
sd := stats.standard_deviation    -- ~1.41
q1 := stats.quartile_1            -- 1.5
```

### Numerical Methods

```eiffel
-- Find sqrt(2) by solving x^2 - 2 = 0
f := agent (x: REAL_64): REAL_64 do Result := x*x - 2.0 end
root := math.bisection (f, 1.0, 2.0, 1.0e-10, 100)  -- ~1.414

-- Integrate sin(x) from 0 to pi
g := agent math.sin
integral := math.simpson (g, 0.0, math.pi, 100)  -- ~2.0
```

## 5. Design Decisions

| Decision | Rationale |
|----------|-----------|
| Pure Eiffel | No external dependencies, portable |
| 1-based indexing | Eiffel convention |
| Row-major storage | Standard for arrays |
| MML models | Formal verification support |
| Operator aliases | Natural mathematical notation |
| Tolerance-based equality | Floating-point practicality |

## 6. Limitations

| Limitation | Workaround |
|------------|------------|
| O(n^3) matrix operations | Acceptable for moderate sizes |
| No sparse matrices | Use specialized library |
| No complex numbers | Extend if needed |
| No eigenvalues | Future enhancement |
| No BLAS/LAPACK integration | Pure Eiffel simplicity |

## 7. Dependencies

| Dependency | Purpose |
|------------|---------|
| ISE base | ARRAY, DOUBLE_MATH |
| ISE mml | MML_SEQUENCE for models |
| simple_sorter | Sorting for statistics |

## 8. Performance Notes

| Operation | Complexity | 1000x1000 Matrix |
|-----------|------------|------------------|
| Matrix multiply | O(n^3) | ~seconds |
| Determinant | O(n^3) | ~seconds |
| Inverse | O(n^3) | ~seconds |
| Statistics mean | O(n) | <1ms |
| Statistics median | O(n log n) | <10ms |

## 9. Test Coverage

Expected tests (from research):
- Vector arithmetic and products
- Matrix multiplication and inverse
- Statistics mean, variance, std_dev
- Root finding convergence
- Integration accuracy

---

*Generated as backwash specification from existing implementation.*
