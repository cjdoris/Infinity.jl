# todo: ^, fma, muladd, div, fld, cld, rem, mod, mod1, fld1

Base.typemin(::Type{Infinite}) = NegInf
Base.typemax(::Type{Infinite}) = PosInf

Base.:+(x::Infinite) = x
Base.:-(x::Infinite) = Infinite(!x.signbit)

Base.:+(x::Infinite, y::Infinite) = signbit(x)==signbit(y) ? x : throw(InfMinusInfError())
Base.:-(x::Infinite, y::Infinite) = x + -y

Base.:*(x::Infinite, y::Infinite) = Infinite(x.signbit ⊻ y.signbit)
Base.:/(x::Infinite, y::Infinite) = throw(DivideError())

Base.abs(x::Infinite) = PosInf

Base.:(//)(x::Infinite, y::Infinite) = throw(DivideError())
Base.:(//)(x::Infinite, y::Real) = //(promote(x,y)...)
Base.:(//)(x::Real, y::Infinite) = //(promote(x,y)...)
