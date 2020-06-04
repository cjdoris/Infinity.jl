"""
    InfExtendedTime{T} <: TimeType

The type `T` extended with positive and negative infinity.
"""
struct InfExtendedTime{T<:TimeType} <: TimeType
    flag :: InfFlag
    finitevalue :: T

    InfExtendedTime{T}(x::T) where {T<:TimeType} = new{T}(finite, x)
    InfExtendedTime{T}(x::S) where {T<:TimeType, S<:TimeType} = new{T}(finite, convert(T, x))
    InfExtendedTime{T}(x::Infinite) where {T<:TimeType} = new{T}(x==PosInf ? posinf : neginf)
end

InfExtendedTime{T}(x::InfExtendedTime) where {T<:TimeType} = InfExtendedTime{T}(convert(T, x.finitevalue))
InfExtendedTime{T}(x::InfExtendedTime{T}) where {T<:TimeType} = x

"""
+     InfExtendedTime(T)
+
+ The union of `T` and `Infinite`: Since TimeType can't be represented by Inf, we
+ just return `InfExtendedTime{T}`.
+ """
@generated InfExtendedTime(::Type{T}) where {T<:TimeType} = InfExtendedTime{T}

"""
+     InfExtendedTime(x)
+
+ Converts `x` to a `InfExtendedTime(typeof(x))`.
+ """
@generated InfExtendedTime(x::T) where {T<:TimeType} = :($(InfExtendedTime(T))(x))

Utils.posinf(::Type{T}) where {T<:InfExtendedTime} = T(PosInf)
Utils.neginf(::Type{T}) where {T<:InfExtendedTime} = T(NegInf)
Utils.isposinf(x::InfExtendedTime) = x.flag == posinf
Utils.isneginf(x::InfExtendedTime) = x.flag == neginf
