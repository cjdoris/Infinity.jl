Base.isfinite(x::Infinite) = false
Base.isfinite(x::InfExtended) = isfinite(x.val)

Base.isinf(x::Infinite) = true
Base.isinf(x::InfExtended) = isfinite(x.val)

Base.:(==)(x::Infinite, y::Infinite) = x.signbit == y.signbit
Base.:(==)(x::Infinite, y::Real) = isfinite(y) ? false : signbit(x)==signbit(y)
Base.:(==)(x::Real, y::Infinite) = isfinite(x) ? false : signbit(y)==signbit(x)
Base.:(==)(x::T, y::T) where {T<:InfExtended} = x.val == y.val

Base.hash(x::Infinite, h::UInt) = hash(isposinf(x) ? Inf : -Inf, h)
Base.hash(x::InfExtended, h::UInt) = hash(x.val)

Base.:<(x::Infinite, y::Infinite) = isneginf(x) && isposinf(y)
Base.:<(x::Infinite, y::Real) = isneginf(x) ? !isneginf(y) : false
Base.:<(x::Real, y::Infinite) = isposinf(y) ? !isposinf(x) : false
Base.:<(x::T, y::T) where {T<:InfExtended} = x.val < y.val

Base.:≤(x::Infinite, y::Infinite) = !(y < x)
Base.:≤(x::Infinite, y::Real) = !(y < x)
Base.:≤(x::Real, y::Infinite) = !(y < x)
Base.:≤(x::T, y::T) where {T<:InfExtended} = x.val ≤ y.val

Base.:>(x::Infinite, y::Infinite) = y < x
Base.:>(x::Infinite, y::Real) = y < x
Base.:>(x::Real, y::Infinite) = y < x
Base.:>(x::T, y::T) where {T<:InfExtended} = x.val > y.val

Base.:≥(x::Infinite, y::Infinite) = y ≤ x
Base.:≥(x::Infinite, y::Real) = y ≤ x
Base.:≥(x::Real, y::Infinite) = y ≤ x
Base.:≥(x::T, y::T) where {T<:InfExtended} = x.val ≥ y.val

Base.signbit(x::Infinite) = x.signbit
Base.signbit(x::InfExtended) = signbit(x.val)

Base.sign(x::Infinite) = isposinf(x) ? 1 : -1
Base.sign(x::InfExtended) = sign(x.val)

# Base.min(x::Infinite, y::Real) = x<y ? x : y
# Base.min(x::Real, y::Infinite) = x<y ? x : y

# Base.max(x::Infinite, y::Real) = x<y ? y : x
# Base.max(x::Real, y::Infinite) = x<y ? y : x

# Base.minmax(x::Infinite, y::Real) = x<y ? (x,y) : (y,x)
# Base.minmax(x::Real, y::Infinite) = x<y ? (x,y) : (y,x)
