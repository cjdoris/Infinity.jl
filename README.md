# Infinity.jl

Provides `∞ :: Infinite <: Real` representing positive infinity and `-∞` is negative infinity.

Promotion between `Infinite` and some `T <: Real` will yield either:
* `T` itself if it can natively represent infinity (e.g. `Float64`, `Rational`); or
* `InfExtended{T} <: Real` otherwise, which represents the union of `T` and `Infinite`. (See the examples.)

These types support:
* Arithmetic: `+`, `-`, `*`, `/`
* Comparison: `==`, `<`, `hash`, `signbit`, `sign`, `isfinite`, `isinfinite`
* Conversion: `promote`, `convert`, `float`, `widen`, `big`
* Random generation: `rand(Infinite)`

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