using Infinity, Infinity.Utils, Test, Dates

@testset "Infinity" begin
  @testset "utils" begin
    @test !hasinf(Int)
    @test hasinf(Float64)
    @test hasinf(Rational{Int})
  end

  @testset "Infinite" begin
    @testset "identity" begin
        @test Infinite(∞) == ∞
    end

    @testset "rand" begin
      @test typeof(rand(Infinite)) === Infinite
    end
  end

  include("infextendedreal.jl")
  include("infextendedtime.jl")
end
