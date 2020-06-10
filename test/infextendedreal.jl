@testset "InfExtendedRealReal" begin
  @testset "base" begin
    @test InfExtendedReal(Int) === InfExtendedReal{Int}
    @test InfExtendedReal(Float64) === Float64
    @test InfExtendedReal(Rational{Int}) === Rational{Int}
    @test InfExtendedReal(10) === InfExtendedReal{Int}(10)
    @test InfExtendedReal(10.0) === 10.0
    @test InfExtendedReal(2//3) === 2//3
    @inferred InfExtendedReal(Int)
    @inferred InfExtendedReal(Float64)
    @inferred InfExtendedReal(Rational{Int})
    @inferred InfExtendedReal(10)
    @inferred InfExtendedReal(1.2)
    @inferred InfExtendedReal(2//3)
  end

  @testset "arithmetic" begin
    @inferred -∞
    @inferred InfExtendedReal 2 + ∞
    @inferred ∞ + 2.3
    @test_throws InfMinusInfError ∞+(-∞)
    @inferred InfExtendedReal 10 - ∞
    @inferred InfExtendedReal 10.0 - ∞
    @test_throws InfMinusInfError ∞-∞
    @inferred InfExtendedReal 2 * ∞
    @inferred ∞ * 1.0
    @test_throws DivideError ∞ * 0
    @inferred Float64 1 / ∞
    @inferred Float64 1.2 / ∞
    @inferred Float64 -1 / -∞
    @inferred Float64 ∞ / 3
    @inferred Float64 0 / ∞
    @test typemin(InfExtendedReal{Int64}) == InfExtendedReal{Int64}(-∞)
    @test typemax(InfExtendedReal{Int64}) == InfExtendedReal{Int64}(∞)
  end

  @testset "comparisons" begin
    @test ∞ == ∞
    @test ∞ == Inf
    @test InfExtendedReal(5) == 5
    @test InfExtendedReal(7) == 7.0
    @test InfExtendedReal(4) != InfExtendedReal(1)
    @test hash(∞) == hash(Inf)
    @test hash(InfExtendedReal{Int}(∞)) == hash(Inf)
    @test hash(InfExtendedReal(3)) == hash(3)
    @test isinf(∞)
    @test isinf(InfExtendedReal{Int}(∞))
    @test !isinf(InfExtendedReal(9))
    @test !isfinite(∞)
    @test !isfinite(InfExtendedReal{Int}(∞))
    @test isfinite(InfExtendedReal(-4))
    @test ∞ ≤ ∞
    @test 1 ≤ ∞
    @test -∞ ≤ -∞
    @test !(∞ ≤ 0)
    @test !signbit(∞)
    @test signbit(-∞)
    @test !signbit(InfExtendedReal{Int}(∞))
    @test signbit(InfExtendedReal{Int}(-∞))
    @test !signbit(InfExtendedReal(20))
    @test signbit(InfExtendedReal(-2))
    @test sign(∞) == 1
    @test sign(-∞) == -1
    @test sign(InfExtendedReal{Int}(∞)) == 1
    @test sign(InfExtendedReal{Int}(-∞)) == -1
    @test sign(InfExtendedReal(3)) == 1
    @test sign(InfExtendedReal(-99)) == -1
    @test sign(InfExtendedReal(0)) == 0
    @inferred sign(InfExtendedReal(2))
    @inferred sign(InfExtendedReal{Int32}(∞))
  end

  @testset "conversions" begin
    @test convert(Infinite, InfExtendedReal{Int}(∞)) === ∞
  end

end
