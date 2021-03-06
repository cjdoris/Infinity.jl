Base.:(==)(x::InfExtendedReal, y::InfExtendedReal) = isinf(x)==isinf(y) && x.val==y.val

Base.hash(x::InfExtendedReal, h::UInt) = hash(x.val, h)

Base.:<(x::InfExtendedReal, y::InfExtendedReal) =
  if isinf(x)
    signbit(x) && !isneginf(y)
  elseif isinf(y)
    !signbit(y)
  else
    x.val < y.val
  end

Base.signbit(x::InfExtendedReal) = signbit(x.val)

Base.sign(x::InfExtendedReal{T}) where {T<:Real} = convert(T, sign(x.val))

Base.isapprox(x::InfExtendedReal, y::InfExtendedReal; opts...) = isinf(x)==isinf(y) && isapprox(x.val, y.val; opts...)
