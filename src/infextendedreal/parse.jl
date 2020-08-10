function Base.tryparse(::Type{InfExtendedReal{T}}, str::AbstractString) where T
  val = tryparse(Infinite, str)
  if val === nothing
    val = tryparse(T, str)
  end
  return val !== nothing ? InfExtendedReal{T}(val) : nothing
end
