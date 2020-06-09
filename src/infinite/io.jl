Base.show(io::IO, x::Infinite) = print(io, isposinf(x) ? "∞" : "-∞")
