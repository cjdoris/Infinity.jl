Base.show(io::IO, x::Infinite) = print(io, isposinf(x) ? "∞" : "-∞")
Base.show(io::IO, x::InfExtended) = show(io, x.val)
