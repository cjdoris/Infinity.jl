# Infinity.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliahub.com/docs/Infinity/)
[![Build Status](https://travis-ci.com/cjdoris/Infinity.jl.svg?branch=master)](https://travis-ci.com/cjdoris/Infinity.jl)
[![CodeCov](https://codecov.io/gh/cjdoris/Infinity.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/cjdoris/Infinity.jl)

Provides `∞ :: Infinite <: Real` representing positive infinity and `-∞` is negative infinity.

## Extended Types
### InfExtendedReal

Promotion between `Infinite` and some `T <: Real` will yield either:
* `T` itself if it can natively represent infinity (e.g. `Float64`, `Rational`); or
* `InfExtendedReal{T} <: Real` otherwise, which represents positive/negative infinity, or a finite value of type `T`. (See the examples.)

The following `Base` functions are extended for these types:
* Arithmetic: `typemin`, `typemax`, `+`, `-`, `*`, `/`
* Comparison: `==`, `<`, `≤`, `hash`, `signbit`, `sign`, `isfinite`, `isinf`, `isapprox`
* Conversion: `promote`, `convert`, `float`, `widen`, `big`
* Random: `rand(Infinite)`

Additionally there is a submodule `Utils` exporting infinity-related functions:
* `posinf(T)`, `neginf(T)`: positive or negative infinity as a `T` if possible, or else `nothing`
* `hasposinf(T)`, `hasneginf(T)`: true if `T` contains positive or negative infinity
* `hasinf(T)`: true if `T` contains both positive and negative infinity (this is used to decide to promote to `InfExtendedReal` or not)
* `isposinf(x)`, `isneginf(x)`: true if `x` is positive or negative infinity

### InfExtendedTime

Promotion between `Infinite` and some `T <: Dates.TimeType` will yield:
* `InfExtendedTime{T} <: Dates.TimeType`, which represents positive/negative infinity, or a finite value of type `T`. (See the examples.)

The following `Base` functions are extended for these types:
* Arithmetic: `typemin`, `typemax`, `T+Period`, `T-Period`
* Comparison: `==`. `<`, `≤`, `hash`, `isfinite`, `isinf`
* Conversion: `promote`, `convert`

## Installation

In Julia, type `]` then run

```julia
pkg> add Infinity
```

## Example

```julia
julia> using Infinity

julia> x = [1,2,3,∞,-1,-∞]
6-element Array{InfExtendedReal{Int64},1}:
 InfExtendedReal{Int64}(1)
 InfExtendedReal{Int64}(2)
 InfExtendedReal{Int64}(3)
 InfExtendedReal{Int64}(∞)
 InfExtendedReal{Int64}(-1)
 InfExtendedReal{Int64}(-∞)

julia> sort(x)
6-element Array{InfExtendedReal{Int64},1}:
 InfExtendedReal{Int64}(-∞)
 InfExtendedReal{Int64}(-1)
 InfExtendedReal{Int64}(1)
 InfExtendedReal{Int64}(2)
 InfExtendedReal{Int64}(3)
 InfExtendedReal{Int64}(∞)

julia> float(x)
6-element Array{Float64,1}:
    1.0
    2.0
    3.0
  Inf
   -1.0
 -Inf

julia> using Dates

julia> x = [Date(2012, 1, 1), Date(2013, 1, 1), Date(2013, 1, 2), ∞, Date(1987, 1, 1), -∞]
6-element Array{InfExtendedTime{Date},1}:
 InfExtendedTime{Date}(2012-01-01)
 InfExtendedTime{Date}(2013-01-01)
 InfExtendedTime{Date}(2013-01-02)
 InfExtendedTime{Date}(∞)
 InfExtendedTime{Date}(1987-01-01)
 InfExtendedTime{Date}(-∞)

julia> sort(x)
6-element Array{InfExtendedTime{Date},1}:
 InfExtendedTime{Date}(-∞)
 InfExtendedTime{Date}(1987-01-01)
 InfExtendedTime{Date}(2012-01-01)
 InfExtendedTime{Date}(2013-01-01)
 InfExtendedTime{Date}(2013-01-02)
 InfExtendedTime{Date}(∞)

julia> Day(1) + x
6-element Array{InfExtendedTime{Date},1}:
 InfExtendedTime{Date}(2012-01-02)
 InfExtendedTime{Date}(2013-01-02)
 InfExtendedTime{Date}(2013-01-03)
 InfExtendedTime{Date}(∞)
 InfExtendedTime{Date}(1987-01-02)
 InfExtendedTime{Date}(-∞)
```
