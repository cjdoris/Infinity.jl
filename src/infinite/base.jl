@enum InfFlag::UInt8 FINITE POSINF NEGINF

"""
    Infinite <: Real

A type with two values, `∞` and `-∞` (or `PosInf` and `NegInf`).

Arithmetic with values of other types will be promoted to either the other type if it supports infinity natively or to [`InfExtended`](@ref).
"""
struct Infinite <: Real
  signbit :: Bool
end
const PosInf = Infinite(false)
const NegInf = Infinite(true)
const ∞ = PosInf

"""
    InfMinusInfError()

Infinity was subtracted from infinity.
"""
struct InfMinusInfError <: Exception end

Base.showerror(io::IO, e::InfMinusInfError) = print(io, "∞-∞ is undefined")
