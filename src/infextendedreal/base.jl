"""
    InfExtendedReal{T} <: Real

The type `T` extended with positive and negative infinity.
"""
struct InfExtendedReal{T<:Real} <: Real
  flag :: InfFlag
  finitevalue :: T

  InfExtendedReal{T}(x::T) where {T<:Real} = new(FINITE, x)
  InfExtendedReal{T}(x::Infinite) where {T<:Real} = new(x==PosInf ? POSINF : NEGINF)
end

# Since InfExtendedReal is a subtype of Real, and Infinite is also a subtype of real,
# we can just use `x.val` to get either the finite value, or the infinite value. This will
# make arithmetic much simpler.
function Base.getproperty(x::InfExtendedReal, s::Symbol)
    if s === :val
        return x.flag != FINITE ? (x.flag == NEGINF ? -∞ : ∞) : x.finitevalue
    else
        return getfield(x, s)
    end
end

InfExtendedReal{T}(x::Real) where {T<:Real} = InfExtendedReal{T}(isinf(x) ? convert(Infinite, x) : convert(T, x))
InfExtendedReal{T}(x::InfExtendedReal) where {T<:Real} = InfExtendedReal{T}(x.val)

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


Utils.isposinf(x::InfExtendedReal) = x.flag == POSINF || x.flag == FINITE && isposinf(x.finitevalue)
Utils.isneginf(x::InfExtendedReal) = x.flag == NEGINF || x.flag == FINITE && isneginf(x.finitevalue)
