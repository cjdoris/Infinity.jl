# Infinity.jl

Provides `∞ :: Infinite <: Real` representing positive infinity and `-∞` is negative infinity.

Promotion between `Infinite` and some `T <: Real` will yield either:
* `T` itself if it can natively represent infinity (e.g. `Float64`, `Rational`); or
* `InfExtended{T} <: Real` otherwise, which represents the union of `T` and `Infinite`. (See the examples.)

The following `Base` functions are extended for these types:
* Arithmetic: `+`, `-`, `*`, `/`
* Comparison: `==`, `<`, `≤`, `hash`, `signbit`, `sign`, `isfinite`, `isinf`, `isapprox`
* Conversion: `promote`, `convert`, `float`, `widen`, `big`
* Random: `rand(Infinite)`

Additionally there is a submodule `Utils` exporting infinity-related functions:
* `posinf(T)`, `neginf(T)`: positive or negative infinity as a `T` if possible, or else `nothing`
* `hasposinf(T)`, `hasneginf(T)`: true if `T` contains positive or negative infinity
* `hasinf(T)`: true if `T` contains both positive and negative infinity (this is used to decide to promote to `InfExtended` or not)
* `isposinf(x)`, `isneginf(x)`: true if `x` is positive or negative infinity

## Installation

In Julia, type `]` then run

```
pkg> install https://github.com/cjdoris/Infinity.jl
```

## Example

```
julia> using Infinity

julia> x = [1,2,3,∞,-1,-∞]
6-element Array{InfExtended{Int64},1}:
  1
  2
  3
  ∞
 -1
 -∞

julia> sort(x)
6-element Array{InfExtended{Int64},1}:
 -∞
 -1
  1
  2
  3
  ∞

julia> float(x)
6-element Array{Float64,1}:
   1.0
   2.0
   3.0
 Inf
  -1.0
 Inf
```