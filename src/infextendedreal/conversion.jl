Base.promote_rule(::Type{Infinite}, ::Type{T}) where {T<:Real} = InfExtendedReal(T)
Base.promote_rule(::Type{InfExtendedReal{T}}, ::Type{InfExtendedReal{S}}) where {T<:Real, S<:Real} = InfExtendedReal(promote_type(T, S))
Base.promote_rule(::Type{InfExtendedReal{T}}, ::Type{S}) where {T<:Real, S<:Real} = InfExtendedReal(promote_type(T, S))
Base.promote_rule(::Type{InfExtendedReal{T}}, ::Type{Infinite}) where {T<:Real} = InfExtendedReal{T}

@generated Base.convert(::Type{T}, x::InfExtendedReal{S}) where {T<:Real,S<:Real} = :(convert($(typeof(convert(T,zero(S)))), x.val))
Base.convert(::Type{Infinite}, x::InfExtendedReal{T}) where {T<:Real} = isinf(x) ? Infinite(signbit(x)) : throw(InexactError(:convert,Infinite,x))
Base.convert(::Type{T}, x::S) where {T<:InfExtendedReal, S<:Real} = T(x)
Base.convert(::Type{T}, x::InfExtendedReal) where {T<:InfExtendedReal} = T(x)
Base.convert(::Type{T}, x::Infinite) where {T<:InfExtendedReal} = T(x)

(::Type{T})(x::InfExtendedReal) where {T<:AbstractFloat} = convert(T, x)

Base.widen(::Type{InfExtendedReal{T}}) where {T<:Real} = InfExtendedReal(widen(T))
Base.big(::Type{InfExtendedReal{T}}) where {T<:Real} = InfExtendedReal(big(T))
Base.big(x::InfExtendedReal) = convert(big(typeof(x)), x)

Base.float(::Type{InfExtendedReal{T}}) where {T} = float(T)
Base.float(::Type{InfExtendedReal}) = float(Infinite)
