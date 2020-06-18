Base.:(==)(x::InfExtendedTime, y::InfExtendedTime) = (isfinite(x) && isfinite(y)) ? x.finitevalue == y.finitevalue : x.flag == y.flag
Base.:(==)(x::Infinite, y::T) where {T<:InfExtendedTime} = T(x) == y
Base.:(==)(x::T, y::Infinite) where {T<:InfExtendedTime} = x == T(y)

Base.hash(x::InfExtendedTime, h::UInt) = isfinite(x) ? hash(x.finitevalue, h) : hash(x.flag, h)

function Base.isless(x::InfExtendedTime, y::InfExtendedTime)
    if isinf(x)
        return isneginf(x) && !isneginf(y)
    elseif isinf(y)
        return isposinf(y)
    else
        return x.finitevalue < y.finitevalue
    end
end
Base.isless(x::Infinite, y::T) where {T<:InfExtendedTime} = isless(T(x), y)
Base.isless(x::T, y::Infinite) where {T<:InfExtendedTime} = isless(x, T(y))

Base.:≤(x::Infinite, y::T) where {T<:InfExtendedTime} = T(x) ≤ y
Base.:≤(x::T, y::Infinite) where {T<:InfExtendedTime} = x ≤ T(y)
