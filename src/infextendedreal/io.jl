function Base.show(io::IO, x::T) where {T<:InfExtendedReal}
    value = x.val
    if get(io, :compact, false)
        print(io, value)
    else
        print(io, "$T(")
        show(io, value)
        print(io, ")")
    end
end
