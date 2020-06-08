Base.promote_rule(::Type{Infinite}, ::Type{S}) where {S<:TimeType} = S <: InfExtendedTime ? S : InfExtendedTime{S}
Base.promote_rule(::Type{InfExtendedTime{T}}, ::Type{InfExtendedTime{S}}) where {T<:TimeType, S<:TimeType} = InfExtendedTime(promote_type(T, S))
Base.promote_rule(::Type{InfExtendedTime{T}}, ::Type{S}) where {T<:TimeType, S<:TimeType} = InfExtendedTime(promote_type(T, S))
Base.promote_rule(::Type{InfExtendedTime{T}}, ::Type{Infinite}) where {T<:TimeType} = InfExtendedTime{T}

Base.convert(::Type{T}, x::S) where {T<:InfExtendedTime, S<:TimeType} = T(x)
Base.convert(::Type{T}, x::InfExtendedTime) where {T<:InfExtendedTime} = T(x)
Base.convert(::Type{T}, x::Infinite) where {T<:InfExtendedTime} = T(x)
