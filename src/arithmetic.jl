# todo: ^, fma, muladd, div, fld, cld, rem, mod, mod1, fld1

Base.typemin(::Type{Infinite}) = NegInf
Base.typemin(::Type{T}) where {T<:InfExtended} = T(NegInf)

Base.typemax(::Type{Infinite}) = PosInf
Base.typemax(::Type{T}) where {T<:InfExtended} = T(PosInf)

Base.:+(x::Infinite) = x
Base.:+(x::T) where {T<:InfExtended} = T(+x.val)

Base.:-(x::Infinite) = Infinite(!x.signbit)
Base.:-(x::T) where {T<:InfExtended} = T(-x.val)

Base.:+(x::Infinite, y::Infinite) = signbit(x)==signbit(y) ? x : throw(InfMinusInfError())
Base.:+(x::T, y::T) where {T<:InfExtended} = isinf(x) ? isinf(y) ? T(x.val+y.val) : x : isinf(y) ? y : T(x.val+y.val)

Base.:-(x::Infinite, y::Infinite) = x.signbit != y.signbit ? x : throw(InfMinusInfError())
Base.:-(x::T, y::T) where {T<:InfExtended} = isinf(x) ? isinf(y) ? T(x.val - y.val) : x : isinf(y) ? -y : T(x.val-y.val)

Base.:*(x::Infinite, y::Infinite) = Infinite(x.signbit ⊻ y.signbit)
Base.:*(x::T, y::T) where {T<:InfExtended} =
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

Base.:/(x::Infinite, y::Infinite) = throw(DivideError())
@generated Base.:/(x::InfExtended{T}, y::InfExtended{T}) where {T<:Real} = :(convert($(InfExtended(typeof(one(T)/one(T)))),
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

Base.abs(x::Infinite) = PosInf
Base.abs(x::InfExtended{T}) where {T<:Real} = InfExtended{T}(abs(x.val))

Base.:(//)(x::Infinite, y::Infinite) = throw(DivideError())
@generated Base.:(//)(x::InfExtended{T}, y::InfExtended{S}) where {T<:Real,S<:Real} = :(convert($(InfExtended(typeof(one(T)//one(S)))), 
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
Base.:(//)(x::InfExtended, y::Real) = //(promote(x,y)...)
Base.:(//)(x::Real, y::InfExtended) = //(promote(x,y)...)
Base.:(//)(x::Infinite, y::Real) = //(promote(x,y)...)
Base.:(//)(x::Real, y::Infinite) = //(promote(x,y)...)
