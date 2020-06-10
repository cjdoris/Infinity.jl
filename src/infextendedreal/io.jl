function Base.show(io::IO, x::T) where {T<:InfExtendedReal}
    value = isposinf(x) ? ∞ : isneginf(x) ? -∞ : x.finitevalue
    if get(io, :compact, false)
        print(io, value)
    else
        print(io, "$T(")
        show(io, value)
        print(io, ")")
    end
end
