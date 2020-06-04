Base.typemin(::Type{T}) where {T<:InfExtendedTime} = Utils.neginf(T)
Base.typemax(::Type{T}) where {T<:InfExtendedTime} = Utils.posinf(T)

function Base.:+(x::T, y::S) where {T<:InfExtendedTime, S<:Period}
    isinf(x) ? x : T(x.finitevalue + y)
end
Base.:+(x::S, y::T) where {T<:InfExtendedTime, S<:Period} = y + x
Base.:-(x::T, y::S) where {T<:InfExtendedTime, S<:Period} = x + -y
Base.:-(x::S, y::T) where {T<:InfExtendedTime, S<:Period} = isposinf(y) ? Utils.neginf(T) : y + -x

function Base.:+(x::T, y::Infinite) where {T<:InfExtendedTime}
    if isfinite(x)
        return T(y)
    else
        val = x.flag == posinf ? ∞ : -∞
        return T(val + y)
    end
end
Base.:+(x::Infinite, y::T) where {T<:InfExtendedTime} = y + x
function Base.:-(x::T, y::Infinite) where {T<:InfExtendedTime}
    if isfinite(x)
        return T(-y)
    else
        val = x.flag == posinf ? ∞ : -∞
        return T(val - y)
    end
end
function Base.:-(x::Infinite, y::T) where {T<:InfExtendedTime}
    if isfinite(y)
        return T(x)
    else
        val = y.flag == posinf ? ∞ : -∞
        return T(x - val)
    end
end
