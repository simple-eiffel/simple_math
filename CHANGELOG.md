# Changelog: simple_math

## 0.2.0 (2026-10-25)
- Added `tanh`, `erf` (C99 libm) and an overflow-safe `sigmoid` to SIMPLE_MATH (gap G-3 for simple_tensor: GELU needs erf).
- Test `test_math_tanh_erf_sigmoid` checks reference values to 1e-12. Dependents type-check clean: simple_calculus, simple_linalg, simple_statistics (their pre-existing VD81 config warning is unrelated).

## 0.1.0
- Vectors, matrices, statistics, numerical methods.
