"""
    Infinite <: Real

A type with two values, `PosInf` (or `∞`) and `NegInf` representing ``±∞``.

Arithmetic with values of other types will be promoted to either the other type if it supports infinity natively or to [`InfExtended`](@ref).
"""
struct Infinite <: Real
  signbit :: Bool
end

const PosInf = Infinite(false)
const NegInf = Infinite(true)
const ∞ = PosInf

"""
    InfExtended{T}

The type `T` extended with positive and negative infinity.
"""
struct InfExtended{T<:Real} <: Real
  val :: Union{T, Infinite}
  InfExtended{T}(x::Infinite) where {T<:Real} = new(x)
  InfExtended{T}(x::T) where {T<:Real} = new(x)
end

InfExtended{T}(x::Real) where {T<:Real} = InfExtended{T}(isinf(x) ? convert(Infinite, x) : convert(T, x))
InfExtended{T}(x::InfExtended) where {T<:Real} = InfExtended{T}(x.val)
InfExtended{T}(x::InfExtended{T}) where {T<:Real} = x

"""
    InfExtended(T)

The union of `T` and `Infinite`: either `T` if infinity can be represented as a `T`, or else `InfExtended{T}`.
"""
@generated InfExtended(::Type{T}) where {T<:Real} = hasinf(T) ? T : InfExtended{T}

"""
    InfExtended(x)

Converts `x` to a `InfExtended(typeof(x))`.
"""
@generated InfExtended(x::T) where {T<:Real} = hasinf(T) ? :x : :($(InfExtended(T))(x))

"""
    InfMinusInfError()

Infinity was subtracted from infinity.
"""
struct InfMinusInfError <: Exception end

Base.showerror(io::IO, e::InfMinusInfError) = print(io, "∞-∞ is undefined")

Utils.posinf(::Type{Infinite}) = PosInf
Utils.posinf(::Type{T}) where {T<:InfExtended} = T(PosInf)
Utils.neginf(::Type{Infinite}) = NegInf
Utils.neginf(::Type{T}) where {T<:InfExtended} = T(NegInf)
Utils.isposinf(x::Infinite) = !x.signbit
Utils.isposinf(x::InfExtended) = isposinf(x.val)
Utils.isneginf(x::Infinite) = x.signbit
Utils.isneginf(x::InfExtended) = isneginf(x.val)
