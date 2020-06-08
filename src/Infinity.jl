module Infinity

export Infinite, PosInf, NegInf, ∞, InfMinusInfError, InfExtendedReal

# Infinite
include("infinite/utils.jl")
include("infinite/base.jl")
include("infinite/arithmetic.jl")
include("infinite/io.jl")
include("infinite/comparison.jl")
include("infinite/conversion.jl")
include("infinite/rand.jl")

# InfExtendedReal
include("infextendedreal/base.jl")
include("infextendedreal/arithmetic.jl")
include("infextendedreal/io.jl")
include("infextendedreal/comparison.jl")
include("infextendedreal/conversion.jl")

end
