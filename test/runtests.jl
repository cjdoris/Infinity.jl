using Infinity, Infinity.Utils, Test

@testset "Infinity" begin
  @testset "utils" begin
    @test !hasinf(Int)
    @test hasinf(Float64)
    @test hasinf(Rational{Int})
  end

  @testset "rand" begin
    @test typeof(rand(Infinite)) === Infinite
  end

  include("infextendedreal.jl")
end
