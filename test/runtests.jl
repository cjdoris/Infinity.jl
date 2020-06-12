using Compat
using Infinity
using Infinity.Utils
using Random
using Test

@testset "Infinity" begin
    include("utils.jl")
    include("infinite.jl")
    include("infextendedreal.jl")
    include("infextendedtime.jl")
end
