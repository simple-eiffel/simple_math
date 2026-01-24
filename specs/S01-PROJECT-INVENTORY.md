# S01-PROJECT-INVENTORY.md

**Library:** simple_math
**Status:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Project Overview

| Field | Value |
|-------|-------|
| Name | simple_math |
| Purpose | Mathematical operations library (vectors, matrices, statistics, numerical methods) |
| Phase | Production |
| Primary Facade | SIMPLE_MATH |
| ECF | simple_math.ecf |

## 2. File Inventory

### Source Files

| File | Class | LOC | Purpose |
|------|-------|-----|---------|
| src/simple_math.e | SIMPLE_MATH | ~500 | Main facade with factory methods and numerical functions |
| src/simple_vector.e | SIMPLE_VECTOR | ~380 | N-dimensional vector operations |
| src/simple_matrix.e | SIMPLE_MATRIX | ~670 | Matrix operations and linear algebra |
| src/simple_statistics.e | SIMPLE_STATISTICS | ~450 | Statistical functions |

### Configuration Files

| File | Purpose |
|------|---------|
| simple_math.ecf | EiffelStudio project configuration |
| simple_math.rc | Windows resource file |

### Documentation Files

| File | Purpose |
|------|---------|
| README.md | Library overview and usage |
| MML_INTEGRATION.md | Mathematical Model Library integration notes |
| research/SIMPLE_MATH_RESEARCH.md | 7-step research document |

### Test Files

| File | Purpose |
|------|---------|
| testing/math_test_app.e | Test application |

## 3. Dependencies

### ISE Libraries

| Library | ECF Path | Purpose |
|---------|----------|---------|
| base | $ISE_LIBRARY/library/base/base.ecf | Base classes |
| mml | Mathematical Model Library | Contract models |

### simple_* Libraries

| Library | Purpose |
|---------|---------|
| simple_sorter | Sorting for statistics calculations |

## 4. Build Targets

| Target | Type | Purpose |
|--------|------|---------|
| simple_math | library | Main library build |
| simple_math_tests | executable | Test runner |

## 5. Mathematical Coverage

### Standards Implemented

| Standard | Coverage |
|----------|----------|
| BLAS Level 1 | Vector operations (dot, scale, add) |
| BLAS Level 2 | Matrix-vector multiply |
| BLAS Level 3 | Matrix multiplication |
| Statistics | Mean, median, mode, variance, std dev, correlation, regression |
| Numerical | Root finding, integration, interpolation |

---

*Generated as backwash specification from existing implementation.*
