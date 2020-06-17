using Compat
using Dates
using Infinity
using Infinity.Utils
using Random
using Test
using TimeZones: ZonedDateTime

@testset "Infinity" begin
    include("utils.jl")
    include("infinite.jl")
    include("infextendedreal.jl")
    include("infextendedtime.jl")
end
