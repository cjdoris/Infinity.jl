Base.promote_rule(::Type{Infinite}, ::Type{T}) where {T<:Real} = InfExtended(T)
Base.promote_rule(::Type{InfExtended{T}}, ::Type{InfExtended{S}}) where {T<:Real, S<:Real} = InfExtended(promote_type(T, S))
Base.promote_rule(::Type{InfExtended{T}}, ::Type{S}) where {T<:Real, S<:Real} = InfExtended(promote_type(T, S))
Base.promote_rule(::Type{InfExtended{T}}, ::Type{Infinite}) where {T<:Real} = InfExtended{T}

@generated function Base.convert(::Type{T}, x::Infinite) where {T<:Real}
  Infinite <: T && return :(x)
  pinf = posinf(T)
  ninf = neginf(T)
  mkpinf = pinf===nothing ? :(throw(InexactError(:convert,T,x))) : pinf
  mkninf = ninf===nothing ? :(throw(InexactError(:convert,T,x))) : ninf
  :(x.signbit ? $mkninf : $mkpinf)
end
@generated Base.convert(::Type{T}, x::InfExtended{S}) where {T<:Real,S<:Real} = :(convert($(typeof(convert(T,zero(S)))), x.val))
Base.convert(::Type{Infinite}, x::Real) = isinf(x) ? Infinite(signbit(x)) : throw(InexactError(:convert,Infinite,x))
Base.convert(::Type{Infinite}, x::Infinite) = x
Base.convert(::Type{T}, x::S) where {T<:InfExtended, S<:Real} = T(x)
Base.convert(::Type{T}, x::InfExtended) where {T<:InfExtended} = T(x)
Base.convert(::Type{T}, x::Infinite) where {T<:InfExtended} = T(x)

(::Type{T})(x::InfExtended) where {T<:AbstractFloat} = convert(T, x)
(::Type{T})(x::Infinite) where {T<:AbstractFloat} = convert(T, x)

Base.widen(::Type{InfExtended{T}}) where {T<:Real} = InfExtended(widen(T))
Base.big(::Type{InfExtended{T}}) where {T<:Real} = InfExtended(big(T))
Base.big(x::InfExtended) = convert(big(typeof(x)), x)

"""
    UnknownReal()

Represents an unknown real number.
"""
struct UnknownReal <: Real end

Base.one(::Type{Infinite}) = UnknownReal
Base.zero(::Type{Infinite}) = UnknownReal
Base.float(::Type{UnknownReal}) = float(Int)
Base.float(::Type{Infinite}) = float(Int)
Base.float(::Type{InfExtended{T}}) where {T} = float(T)
Base.float(::Type{InfExtended}) = float(Infinite)