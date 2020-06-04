Base.isfinite(x::InfExtendedTime) = x.flag == finite && isfinite(x.finitevalue)
Base.isinf(x::InfExtendedTime) = isposinf(x) || isneginf(x)
Base.:(==)(x::InfExtendedTime, y::InfExtendedTime) = (isfinite(x) && isfinite(y)) ? x.finitevalue == y.finitevalue : x.flag == y.flag
Base.hash(x::InfExtendedTime, h::UInt) = isfinite(x) ? hash(x.finitevalue, h) : hash(x.flag, h)

function Base.:<(x::InfExtendedTime, y::InfExtendedTime)
    if isinf(x)
        return isneginf(x) && !isneginf(y)
    elseif isinf(y)
        return isposinf(y)
    else
        return x.finitevalue < y.finitevalue
    end
end

Base.:≤(x::InfExtendedTime, y::InfExtendedTime) = !(y < x)
