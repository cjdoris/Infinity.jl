"""
    InfExtendedReal{T} <: Real

The type `T` extended with positive and negative infinity.
"""
struct InfExtendedReal{T<:Real} <: Real
  val :: Union{T, Infinite}
  InfExtendedReal{T}(x::Infinite) where {T<:Real} = new(x)
  InfExtendedReal{T}(x::T) where {T<:Real} = new(x)
end

InfExtendedReal{T}(x::Real) where {T<:Real} = InfExtendedReal{T}(isinf(x) ? convert(Infinite, x) : convert(T, x))
InfExtendedReal{T}(x::InfExtendedReal) where {T<:Real} = InfExtendedReal{T}(x.val)
InfExtendedReal{T}(x::InfExtendedReal{T}) where {T<:Real} = x

"""
    InfExtendedReal(T)

The union of `T` and `Infinite`: either `T` if infinity can be represented as a `T`, or else `InfExtendedReal{T}`.
"""
@generated InfExtendedReal(::Type{T}) where {T<:Real} = hasinf(T) ? T : InfExtendedReal{T}

"""
    InfExtendedReal(x)

Converts `x` to a `InfExtendedReal(typeof(x))`.
"""
@generated InfExtendedReal(x::T) where {T<:Real} = hasinf(T) ? :x : :($(InfExtendedReal(T))(x))


Utils.posinf(::Type{T}) where {T<:InfExtendedReal} = T(PosInf)
Utils.neginf(::Type{T}) where {T<:InfExtendedReal} = T(NegInf)
Utils.isposinf(x::InfExtendedReal) = isposinf(x.val)
Utils.isneginf(x::InfExtendedReal) = isneginf(x.val)
