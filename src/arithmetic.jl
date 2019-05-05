# todo: ^, fma, muladd, div, fld, cld, rem, mod, mod1, fld1

Base.typemin(::Type{Infinite}) = NegInf
Base.typemin(::Type{T}) where {T<:InfExtended} = T(NegInf)

Base.typemax(::Type{Infinite}) = PosInf
Base.typemax(::Type{T}) where {T<:InfExtended} = T(PosInf)

Base.:+(x::Infinite) = x
Base.:+(x::InfExtended) = InfExtended(+x.val)

Base.:-(x::Infinite) = Infinite(!x.signbit)
Base.:-(x::InfExtended) = InfExtended(-x.val)

_add(x::Real, y::Real) = x + y
_add(x::Infinite, y::Infinite) = signbit(x) == signbit(y) ? x : throw(InfMinusInfError())
@generated _add(x::Infinite, y::Real) = hasinf(y) ? :(oftype(y,x) + y) : :((isfinite(y) || (isinf(y) && signbit(x)==signbit(y))) ? x : throw(InfMinusInfError()))
@generated _add(x::Real, y::Infinite) = hasinf(x) ? :(x + oftype(x,y)) : :((isfinite(x) || (isinf(x) && signbit(y)==signbit(x))) ? y : throw(InfMinusInfError()))
Base.:+(x::T, y::T) where {T<:InfExtended} = T(_add(x.val, y.val))

_sub(x::Real, y::Real) = x - y
_sub(x::Infinite, y::Infinite) = x.signbit != y.signbit ? x : throw(InfMinusInfError())
@generated _sub(x::Infinite, y::Real) = hasinf(y) ? :(oftype(y,x) - y) : :((isfinite(y) || (isinf(y) && signbit(x)!=signbit(y))) ? x : throw(InfMinusInfError()))
@generated _sub(x::Real, y::Infinite) = hasinf(x) ? :(x - oftype(x,y)) : :((isfinite(x) || (isinf(x) && signbit(y)!=signbit(x))) ? -y : throw(InfMinusInfError()))
Base.:-(x::T, y::T) where {T<:InfExtended} = T(_sub(x.val, y.val))

_mul(x::Real, y::Real) = x * y
_mul(x::Infinite, y::Infinite) = Infinite(x.signbit ⊻ y.signbit)
@generated _mul(x::Infinite, y::Real) = hasinf(y) ? :(oftype(y,x) * y) : :(y>0 ? x : y<0 ? -x : throw(DivideError()))
@generated _mul(x::Real, y::Infinite) = hasinf(x) ? :(x * oftype(x,y)) : :(x>0 ? y : x<0 ? -y : throw(DivideError()))
Base.:*(x::T, y::T) where {T<:InfExtended} = T(_mul(x.val, y.val))

_div(x::Real, y::Real) = x / y
_div(x::Infinite, y::Infinite) = throw(DivideError())
@generated _div(x::Infinite, y::Real) = hasinf(y) ? :(oftype(y,x) / y) : :(isinf(y) ? throw(DivideError()) : y>0 ? x : y<0 ? -x : throw(DivideError()))
@generated _div(x::Real, y::Infinite) = hasinf(x) ? :(x / oftype(x,y)) : :(isinf(x) ? throw(DivideError()) : zero(x))
Base.:/(x::InfExtended{T}, y::InfExtended{T}) where {T<:Real} = InfExtended{typeof(one(T)/one(T))}(_div(x.val, y.val))
