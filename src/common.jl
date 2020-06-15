# Extract out common functions/etc for the Extended Types

for (Name, T) in ((InfExtendedReal, Real), (InfExtendedTime, TimeType))
    @eval begin
        # base.jl
        $Name{T}(x::$Name{T}) where {T<:$T} = x

        Utils.posinf(::Type{T}) where {T<:$Name} = T(PosInf)
        Utils.neginf(::Type{T}) where {T<:$Name} = T(NegInf)

        # arithmetic.jl
        Base.typemin(::Type{T}) where {T<:$Name} = neginf(T)
        Base.typemax(::Type{T}) where {T<:$Name} = posinf(T)

        # io.jl
        function Base.show(io::IO, x::T) where {T<:$Name}
            value = isposinf(x) ? ∞ : isneginf(x) ? -∞ : x.finitevalue
            if get(io, :compact, false)
                print(io, value)
            else
                print(io, "$T(")
                show(io, value)
                print(io, ")")
            end
        end

        # comparison.jl
        Base.isfinite(x::$Name) = x.flag == FINITE && isfinite(x.finitevalue)
        Base.isinf(x::$Name) = isposinf(x) || isneginf(x)

        Base.:≤(x::$Name, y::$Name) = !(y < x)

        # conversion.jl
        Base.promote_rule(::Type{Infinite}, ::Type{T}) where {T<:$T} = T <: $Name ? T : $Name{T}
        Base.promote_rule(::Type{$Name{T}}, ::Type{$Name{S}}) where {T<:$T, S<:$T} = $Name(promote_type(T, S))
        Base.promote_rule(::Type{$Name{T}}, ::Type{S}) where {T<:$T, S<:$T} = $Name(promote_type(T, S))
        Base.promote_rule(::Type{$Name{T}}, ::Type{Infinite}) where {T<:$T} = $Name{T}

        Base.convert(::Type{T}, x::S) where {T<:$Name, S<:$T} = T(x)
        Base.convert(::Type{T}, x::$Name) where {T<:$Name} = T(x)
        Base.convert(::Type{T}, x::Infinite) where {T<:$Name} = T(x)
    end
end
