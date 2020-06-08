@generated function Base.convert(::Type{T}, x::Infinite) where {T<:Real}
  Infinite <: T && return :(x)
  pinf = posinf(T)
  ninf = neginf(T)
  mkpinf = pinf===nothing ? :(throw(InexactError(:convert,T,x))) : pinf
  mkninf = ninf===nothing ? :(throw(InexactError(:convert,T,x))) : ninf
  :(x.signbit ? $mkninf : $mkpinf)
end
Base.convert(::Type{Infinite}, x::Real) = isinf(x) ? Infinite(signbit(x)) : throw(InexactError(:convert,Infinite,x))
Base.convert(::Type{Infinite}, x::Infinite) = x

(::Type{T})(x::Infinite) where {T<:AbstractFloat} = convert(T, x)

"""
    UnknownReal()

Represents an unknown real number.
"""
struct UnknownReal <: Real end

Base.one(::Type{Infinite}) = UnknownReal
Base.zero(::Type{Infinite}) = UnknownReal
Base.float(::Type{UnknownReal}) = float(Int)
Base.float(::Type{Infinite}) = float(Int)
