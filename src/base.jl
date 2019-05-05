"""
    Infinite <: Real

A type with two values, `PosInf` (or `∞`) and `NegInf` representing ``\\pm\\infty``.

Binary operations with types supporting infinity (such as `Float64`) will always promote to that type, otherwise we usually return an `Infinite`. The exception is `/(::Real,::Infinite)` which always returns the type of the first argument.
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

InfExtended(::Type{T}) where {T<:Real} = hasinf(T) ? T : InfExtended{T}

@generated InfExtended(x::T) where {T<:Real} = hasinf(T) ? :x : :(InfExtended{T}(x))

"""
    InfMinusInfError()

Infinity was subtracted from infinity.
"""
struct InfMinusInfError <: Exception end

Base.showerror(io::IO, e::InfMinusInfError) = print("∞-∞ is undefined")

Utils.posinf(::Type{Infinite}) = PosInf
Utils.posinf(::Type{T}) where {T<:InfExtended} = T(PosInf)
Utils.neginf(::Type{Infinite}) = NegInf
Utils.neginf(::Type{T}) where {T<:InfExtended} = T(NegInf)
Utils.isposinf(x::Infinite) = !x.signbit
Utils.isposinf(x::InfExtended) = isposinf(x.val)
Utils.isneginf(x::Infinite) = x.signbit
Utils.isneginf(x::InfExtended) = isneginf(x.val)
