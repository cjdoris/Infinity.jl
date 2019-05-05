using Infinity, Infinity.Utils, Test

@testset "Infinity" begin

  @testset "Utils" begin
    @test !hasinf(Int)
    @test hasinf(Float64)
    @test hasinf(Rational{Int})
  end

  @testset "rand" begin
    @test typeof(rand(Infinite)) === Infinite
  end

  @testset "InfExtended" begin
    @test InfExtended(Int) === InfExtended{Int}
    @test InfExtended(Float64) === Float64
    @test InfExtended(Rational{Int}) === Rational{Int}
    @test InfExtended(10) === InfExtended{Int}(10)
    @test InfExtended(10.0) === 10.0
    @test InfExtended(2//3) === 2//3
    @inferred InfExtended(Int)
    @inferred InfExtended(Float64)
    @inferred InfExtended(Rational{Int})
    @inferred InfExtended(10)
    @inferred InfExtended(1.2)
    @inferred InfExtended(2//3)
  end

  @testset "arithmetic" begin
    @inferred -∞
    @inferred 2 + ∞
    @inferred ∞ + 2.3
    @test_throws InfMinusInfError ∞+(-∞)
    @inferred 10 - ∞
    @inferred 10.0 - ∞
    @test_throws InfMinusInfError ∞-∞
    @inferred 2 * ∞
    @inferred ∞ * 1.0
    @test_throws DivideError ∞ * 0
    @inferred 1 / ∞
    @inferred 1.2 / ∞
    @inferred -1 / -∞
    @inferred ∞ / 3
    @inferred 0 / ∞
    @test typemin(InfExtended{Int}) === InfExtended{Int}(-∞)
    @test typemax(InfExtended{Int}) === InfExtended{Int}(∞)
  end

  @testset "comparisons" begin
    @test ∞ == ∞
    @test ∞ == Inf
    @test InfExtended(5) == 5
    @test InfExtended(7) == 7.0
    @test InfExtended(4) != InfExtended(1)
    @test hash(∞) == hash(Inf)
    @test hash(InfExtended{Int}(∞)) == hash(Inf)
    @test hash(InfExtended(3)) == hash(3)
    @test isinf(∞)
    @test isinf(InfExtended{Int}(∞))
    @test !isinf(InfExtended(9))
    @test !isfinite(∞)
    @test !isfinite(InfExtended{Int}(∞))
    @test isfinite(InfExtended(-4))
    @test ∞ ≤ ∞
    @test 1 ≤ ∞
    @test -∞ ≤ -∞
    @test !(∞ ≤ 0)
    @test !signbit(∞)
    @test signbit(-∞)
    @test !signbit(InfExtended{Int}(∞))
    @test signbit(InfExtended{Int}(-∞))
    @test !signbit(InfExtended(20))
    @test signbit(InfExtended(-2))
    @test sign(∞) == 1
    @test sign(-∞) == -1
    @test sign(InfExtended{Int}(∞)) == 1
    @test sign(InfExtended{Int}(-∞)) == -1
    @test sign(InfExtended(3)) == 1
    @test sign(InfExtended(-99)) == -1
    @test sign(InfExtended(0)) == 0
    @inferred sign(InfExtended(2))
    @inferred sign(InfExtended{Int32}(∞))
  end

end