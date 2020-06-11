@testset "InfExtendedRealReal" begin
  @testset "Base" begin
    for (T, x) in ((Int, 1), (Float64, 1.0), (Rational{Int}, 2//3))
      @inferred InfExtendedReal(T)
      @inferred InfExtendedReal(x)
      @inferred InfExtendedReal{T}(x)
      @inferred InfExtendedReal{T}(∞)
      @inferred InfExtendedReal{T}(-∞)
    end

    # Specifically test that if a value can represent `Inf` it doesn't get wrapped in
    # `InfExtendedReal`
    @test InfExtendedReal(Int) === InfExtendedReal{Int}
    @test InfExtendedReal(Float64) === Float64
    @test InfExtendedReal(Rational{Int}) === Rational{Int}
    @test InfExtendedReal(10) === InfExtendedReal{Int}(10)
    @test InfExtendedReal(10.0) === 10.0
    @test InfExtendedReal(2//3) === 2//3

    @test InfExtendedReal{Int}(Inf) == InfExtendedReal{Int}(∞)
    @test InfExtendedReal{Float64}(InfExtendedReal{Int}(10)) ===
        InfExtendedReal{Float64}(10.0)
    @test InfExtendedReal{Int}(InfExtendedReal{Int}(1)) === InfExtendedReal{Int}(1)

    a = InfExtendedReal{Int}(1)
    inf = InfExtendedReal{Int}(∞)
    ninf = InfExtendedReal{Int}(-∞)
    @test posinf(typeof(a)) == inf
    @test neginf(typeof(a)) == ninf
    @test !isposinf(a)
    @test !isneginf(a)
    @test isposinf(inf)
    @test !isneginf(inf)
    @test !isposinf(ninf)
    @test isneginf(ninf)
  end

  #=
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
    =#
end
