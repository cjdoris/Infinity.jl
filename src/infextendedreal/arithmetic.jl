# todo: ^, fma, muladd, div, fld, cld, rem, mod, mod1, fld1

Base.typemin(::Type{T}) where {T<:InfExtendedReal} = T(NegInf)

Base.typemax(::Type{T}) where {T<:InfExtendedReal} = T(PosInf)

Base.:+(x::T) where {T<:InfExtendedReal} = T(+x.val)

Base.:-(x::T) where {T<:InfExtendedReal} = T(-x.val)

Base.:+(x::T, y::T) where {T<:InfExtendedReal} = isinf(x) ? isinf(y) ? T(x.val+y.val) : x : isinf(y) ? y : T(x.val+y.val)

Base.:-(x::T, y::T) where {T<:InfExtendedReal} = isinf(x) ? isinf(y) ? T(x.val - y.val) : x : isinf(y) ? -y : T(x.val-y.val)

Base.:*(x::T, y::T) where {T<:InfExtendedReal} =
  if isinf(x)
    if isinf(y)
      T(x.val * y.val)
    else
      iszero(y) ? throw(DivideError()) : T(Infinite(signbit(x) ⊻ signbit(y)))
    end
  else
    if isinf(y)
      iszero(x) ? throw(DivideError()) : T(Infinite(signbit(x) ⊻ signbit(y)))
    else
      T(x.val * y.val)
    end
  end

@generated Base.:/(x::InfExtendedReal{T}, y::InfExtendedReal{T}) where {T<:Real} = :(convert($(InfExtendedReal(typeof(one(T)/one(T)))),
  if isinf(x)
    if isinf(y)
      throw(DivideError())
    else
      Infinite(signbit(x) ⊻ signbit(y))
    end
  else
    if isinf(y)
      zero(T)
    else
      x.val / y.val
    end
  end))

Base.abs(x::InfExtendedReal{T}) where {T<:Real} = InfExtendedReal{T}(abs(x.val))

@generated Base.:(//)(x::InfExtendedReal{T}, y::InfExtendedReal{S}) where {T<:Real,S<:Real} = :(convert($(InfExtendedReal(typeof(one(T)//one(S)))),
  if isinf(x)
    if isinf(y)
      throw(DivideError())
    else
      Infinite(signbit(x) ⊻ signbit(y))
    end
  else
    if isinf(y)
      zero(T)
    else
      x.val // y.val
    end
  end))
Base.:(//)(x::InfExtendedReal, y::Real) = //(promote(x,y)...)
Base.:(//)(x::Real, y::InfExtendedReal) = //(promote(x,y)...)
