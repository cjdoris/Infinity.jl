Base.isfinite(x::Infinite) = false

Base.isinf(x::Infinite) = true

Base.iszero(::Infinite) = false

Base.:(==)(x::Infinite, y::Infinite) = x.signbit == y.signbit

Base.hash(x::Infinite, h::UInt) = hash(isposinf(x) ? Inf : -Inf, h)

Base.:<(x::Infinite, y::Infinite) = isneginf(x) && isposinf(y)

Base.:≤(x::Infinite, y::Infinite) = !(y < x)

Base.signbit(x::Infinite) = x.signbit

Base.sign(x::Infinite) = isposinf(x) ? 1 : -1

Base.isapprox(x::Infinite, y::Infinite) = x==y
