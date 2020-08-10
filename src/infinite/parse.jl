function Base.tryparse(::Type{Infinite}, str::AbstractString)
  if str == "∞"
    ∞
  elseif str == "-∞"
    -∞
  else
    nothing
  end
end
