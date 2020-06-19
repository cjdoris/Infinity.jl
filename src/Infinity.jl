module Infinity

using Dates: Period, TimeType, UTInstant
using Requires

export Infinite, PosInf, NegInf, ∞, InfMinusInfError, InfExtendedReal, InfExtendedTime

function __init__()
    @require TimeZones="f269a46b-ccf7-5d73-abea-4c690281aa53" include("infextendedtime/timezones.jl")
end

# Utils
include("utils.jl")

# Infinite
include("infinite/base.jl")
include("infinite/arithmetic.jl")
include("infinite/io.jl")
include("infinite/comparison.jl")
include("infinite/conversion.jl")
include("infinite/rand.jl")

# InfExtendedReal
include("infextendedreal/base.jl")
include("infextendedreal/arithmetic.jl")
include("infextendedreal/comparison.jl")
include("infextendedreal/conversion.jl")

# InfExtendedTime
include("infextendedtime/base.jl")
include("infextendedtime/arithmetic.jl")
include("infextendedtime/comparison.jl")

# Extended Common Functions
include("common.jl")
end
