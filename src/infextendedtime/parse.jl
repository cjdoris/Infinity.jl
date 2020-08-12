function Base.tryparse(::Type{InfExtendedTime{T}}, str::AbstractString) where T
  val = tryparse(Infinite, str)
  if val === nothing
    val = tryparse(T, str)
  end
  return val !== nothing ? InfExtendedTime{T}(val) : nothing
end

function Base.parse(::Type{InfExtendedTime{T}}, str::AbstractString) where T
  val = tryparse(InfExtendedTime{T}, str)
  if val === nothing
    throw(ArgumentError("Unable to parse \"$str\" as $(InfExtendedTime{T})"))
  end
  return val
end
