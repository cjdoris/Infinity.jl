Base.promote_rule(::Type{InfExtendedTime{T}}, ::Type{S}) where {T<:TimeType, S<:ZonedDateTime} = InfExtendedTime(promote_type(T, S))
