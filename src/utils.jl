module Utils
  export posinf, neginf, hasposinf, hasneginf, hasinf, isposinf, isneginf
  """
      posinf(T)

  Positive infinity of type `T`, or `nothing` if this is not possible.
  """
  posinf(::Type{T}) where {T<:Real} = try convert(T, Inf); catch; nothing; end

  """
      neginf(T)

  Negative infinity of type `T`, or `nothing` if this is not possible.
  """
  neginf(::Type{T}) where {T<:Real} = try convert(T, -Inf); catch; nothing; end

  """
      hasposinf(T)

  True if positive infinity is representable in type `T`.
  """
  hasposinf(::Type{T}) where {T<:Real} = posinf(T) !== nothing

  """
      hasneginf(T)

  True if negative infinity is representable in type `T`.
  """
  hasneginf(::Type{T}) where {T<:Real} = neginf(T) !== nothing

  """
      hasinf(T)

  True if positive and negative infinity are representable in type `T`.
  """
  hasinf(::Type{T}) where {T<:Real} = hasposinf(T) && hasneginf(T)

  """
      isposinf(x)

  True if `x` is positive infinity.
  """
  isposinf(x::Real) = isinf(x) && !signbit(x)

  """
      isneginf(x)

  True if `x` is negative infinity.
  """
  isneginf(x::Real) = isinf(x) && signbit(x)
end

using .Utils

