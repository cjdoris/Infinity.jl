function Base.:+(x::T, y::S) where {T<:InfExtendedTime, S<:Period}
    isinf(x) ? x : T(x.finitevalue + y)
end
Base.:+(x::S, y::T) where {T<:InfExtendedTime, S<:Period} = y + x
Base.:-(x::T, y::S) where {T<:InfExtendedTime, S<:Period} = x + -y
Base.:-(x::S, y::T) where {T<:InfExtendedTime, S<:Period} = isposinf(y) ? neginf(T) : y + -x

for TType in (TimeType, Period, UTInstant)
    @eval begin
        Base.:+(x::Infinite, y::T) where {T<:$TType} = x
        Base.:+(x::T, y::Infinite) where {T<:$TType} = y
        Base.:-(x::Infinite, y::T) where {T<:$TType} = x
        Base.:-(x::T, y::Infinite) where {T<:$TType} = Infinite(!y.signbit)
    end
end

function Base.:+(x::T, y::Infinite) where {T<:InfExtendedTime}
    if isfinite(x)
        return T(y)
    else
        val = isposinf(x) ? ∞ : -∞
        return T(val + y)
    end
end
Base.:+(x::Infinite, y::T) where {T<:InfExtendedTime} = y + x
function Base.:-(x::T, y::Infinite) where {T<:InfExtendedTime}
    if isfinite(x)
        return T(-y)
    else
        val = isposinf(x) ? ∞ : -∞
        return T(val - y)
    end
end
function Base.:-(x::Infinite, y::T) where {T<:InfExtendedTime}
    if isfinite(y)
        return T(x)
    else
        val = isposinf(y) ? ∞ : -∞
        return T(x - val)
    end
end
