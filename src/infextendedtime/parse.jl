function Base.tryparse(::Type{InfExtendedTime{T}}, str::AbstractString) where T
  val = tryparse(Infinite, str)
  if val === nothing
    val = tryparse(T, str)
  end
  return val !== nothing ? InfExtendedTime{T}(val) : nothing
end
