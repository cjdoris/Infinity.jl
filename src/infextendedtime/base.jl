"""
    InfExtendedTime{T} <: TimeType

The type `T` extended with positive and negative infinity.
"""
struct InfExtendedTime{T<:TimeType} <: TimeType
    flag :: InfFlag
    finitevalue :: T

    InfExtendedTime{T}(x::T) where {T<:TimeType} = new{T}(FINITE, x)
    InfExtendedTime{T}(x::Infinite) where {T<:TimeType} = new{T}(x==PosInf ? POSINF : NEGINF)
end

InfExtendedTime{T}(x::TimeType) where {T<:TimeType} = InfExtendedTime{T}(convert(T, x))
InfExtendedTime{T}(x::InfExtendedTime) where {T<:TimeType} = InfExtendedTime{T}(convert(T, x.finitevalue))
InfExtendedTime{T}(x::InfExtendedTime{T}) where {T<:TimeType} = x

"""
    InfExtendedTime(T)

Return `InfExtendedTime{T}` for any TimeType `T`.
"""
InfExtendedTime(::Type{T}) where {T<:TimeType} = InfExtendedTime{T}

"""
    InfExtendedTime(x)

Converts `x` to `InfExtendedTime(typeof(x))`.
"""
InfExtendedTime(x::T) where {T<:TimeType} = InfExtendedTime{T}(x)

Utils.posinf(::Type{T}) where {T<:InfExtendedTime} = T(PosInf)
Utils.neginf(::Type{T}) where {T<:InfExtendedTime} = T(NegInf)
Utils.isposinf(x::InfExtendedTime) = x.flag == POSINF
Utils.isneginf(x::InfExtendedTime) = x.flag == NEGINF
