@generated Base.convert(::Type{T}, x::InfExtendedReal{S}) where {T<:Real,S<:Real} = :(convert($(typeof(convert(T,zero(S)))), x.val))
Base.convert(::Type{Infinite}, x::InfExtendedReal{T}) where {T<:Real} = isinf(x) ? Infinite(signbit(x)) : throw(InexactError(:convert,Infinite,x))

(::Type{T})(x::InfExtendedReal) where {T<:AbstractFloat} = convert(T, x)

Base.widen(::Type{InfExtendedReal{T}}) where {T<:Real} = InfExtendedReal(widen(T))
Base.big(::Type{InfExtendedReal{T}}) where {T<:Real} = InfExtendedReal(big(T))
Base.big(x::InfExtendedReal) = convert(big(typeof(x)), x)

Base.float(::Type{InfExtendedReal{T}}) where {T} = float(T)
Base.float(::Type{InfExtendedReal}) = float(Infinite)
