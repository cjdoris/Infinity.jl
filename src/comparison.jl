Base.isfinite(x::Infinite) = false
Base.isfinite(x::InfExtended) = isfinite(x.val)

Base.isinf(x::Infinite) = true
Base.isinf(x::InfExtended) = isinf(x.val)

Base.:(==)(x::Infinite, y::Infinite) = x.signbit == y.signbit
Base.:(==)(x::InfExtended, y::InfExtended) = isinf(x)==isinf(y) && x.val==y.val

Base.hash(x::Infinite, h::UInt) = hash(isposinf(x) ? Inf : -Inf, h)
Base.hash(x::InfExtended, h::UInt) = hash(x.val, h)

Base.:<(x::Infinite, y::Infinite) = isneginf(x) && isposinf(y)
Base.:<(x::InfExtended, y::InfExtended) =
  if isinf(x)
    signbit(x) && !isneginf(y)
  elseif isinf(y)
    !signbit(y)
  else
    x.val < y.val
  end

Base.:≤(x::Infinite, y::Infinite) = !(y < x)
Base.:≤(x::InfExtended, y::InfExtended) = !(y < x)

Base.signbit(x::Infinite) = x.signbit
Base.signbit(x::InfExtended) = signbit(x.val)

Base.sign(x::Infinite) = isposinf(x) ? 1 : -1
Base.sign(x::InfExtended{T}) where {T<:Real} = convert(T, sign(x.val))

Base.isapprox(x::Infinite, y::Infinite) = x==y
Base.isapprox(x::InfExtended, y::InfExtended; opts...) = isinf(x)==isinf(y) && isapprox(x.val, y.val; opts...)