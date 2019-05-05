module Infinity

export Infinite, PosInf, NegInf, ∞, InfMinusInfError, InfExtended

include("utils.jl")
include("base.jl")
include("io.jl")
include("arithmetic.jl")
include("comparison.jl")
include("conversion.jl")
include("rand.jl")

end