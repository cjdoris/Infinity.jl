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

    @testset "IO" begin
        x = InfExtendedReal{Int64}(2)
        i = InfExtendedReal{Int64}(∞)

        @test string(x) == "InfExtendedReal{Int64}(2)"
        @test sprint(show, x, context=:compact=>true) == "2"
        @test sprint(show, x) == string(x)

        @test string(i) == "InfExtendedReal{Int64}(∞)"
        @test sprint(show, i, context=:compact=>true) == "∞"
        @test sprint(show, i) == string(i)
    end

    @testset "Conversion" begin
        @test promote_rule(Infinite, Float64) === InfExtendedReal{Float64}
        @test promote_rule(InfExtendedReal{Int64}, InfExtendedReal{Float64}) === Float64
        @test promote_rule(InfExtendedReal{Int32}, InfExtendedReal{Int64}) ===
            InfExtendedReal{Int64}
        @test promote_rule(InfExtendedReal{Int64}, Float64) === Float64
        @test promote_rule(InfExtendedReal{Int64}, Infinite) === InfExtendedReal{Int64}

        @test convert(Int64, InfExtendedReal{Float64}(2.0)) == 2
        @test convert(Infinite, InfExtendedReal{Int}(∞)) === ∞
        @test convert(InfExtendedReal{Int64}, 2.0) === InfExtendedReal{Int64}(2.0)
        @test convert(InfExtendedReal{Int64}, InfExtendedReal{Float64}(2.0)) === InfExtendedReal{Int64}(2.0)
        @test convert(InfExtendedReal{Int64}, ∞) == InfExtendedReal{Int64}(∞)

        @test Float64(InfExtendedReal{Int64}(2)) === 2.0

        @test widen(InfExtendedReal{Int32}) === InfExtendedReal{Int64}
        @test big(InfExtendedReal{Int}) === InfExtendedReal{BigInt}
        @test big(InfExtendedReal{Int64}(2)) == InfExtendedReal{BigInt}(2)

        @test float(InfExtendedReal{Int}) === Float64
        @test float(InfExtendedReal) === Float64
    end

    @testset "comparisons" begin
        @test !isfinite(InfExtendedReal{Int}(∞))
        @test isfinite(InfExtendedReal(-4))
        @test !isfinite(InfExtendedReal{Float64}(Inf))

        @test isinf(InfExtendedReal{Int}(∞))
        @test !isinf(InfExtendedReal(9))
        @test isinf(InfExtendedReal{Float64}(Inf))

        @test !iszero(InfExtendedReal{Int}(∞))
        @test iszero(InfExtendedReal(0))
        @test !iszero(InfExtendedReal{Float64}(Inf))

        @test InfExtendedReal(5) == 5
        @test InfExtendedReal(7) == 7.0
        @test InfExtendedReal(4) != InfExtendedReal(1)

        @test hash(InfExtendedReal(3)) == hash(3)

        @test InfExtendedReal(2) < InfExtendedReal{Int}(∞)
        @test InfExtendedReal{Int}(-∞) < InfExtendedReal(2)
        @test InfExtendedReal(2) <= InfExtendedReal(4)

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

        @test isapprox(InfExtendedReal{Float64}(2.000000001), InfExtendedReal{Float64}(2.0000000004))
    end

    @testset "arithmetic" begin
        @inferred -∞
        @inferred InfExtendedReal 2 + ∞
        @inferred InfExtendedReal ∞ + 2.3
        @test_throws InfMinusInfError ∞+(-∞)
        @inferred InfExtendedReal 10 - ∞
        @inferred InfExtendedReal 10.0 - ∞
        @test_throws InfMinusInfError ∞-∞
        @inferred InfExtendedReal 2 * ∞
        @inferred InfExtendedReal ∞ * 1.0
        @test_throws DivideError ∞ * 0
        @inferred Float64 1 / ∞
        @inferred Float64 1.2 / ∞
        @inferred Float64 -1 / -∞
        @inferred Float64 ∞ / 3
        @inferred Float64 0 / ∞

        @test typemin(InfExtendedReal{Int64}) == InfExtendedReal{Int64}(-∞)
        @test typemax(InfExtendedReal{Int64}) == InfExtendedReal{Int64}(∞)

        @test +InfExtendedReal(2) == InfExtendedReal(2)
        @test -InfExtendedReal(2) == InfExtendedReal(-2)

        @test InfExtendedReal(2) + InfExtendedReal(3) == InfExtendedReal(5)
        @test InfExtendedReal(3) - InfExtendedReal(2) == InfExtendedReal(1)
        @test InfExtendedReal(2) * InfExtendedReal(3) == InfExtendedReal(6)
        @test InfExtendedReal{Int}(∞) * InfExtendedReal{Int}(∞) == InfExtendedReal{Int}(∞)
        @test_throws DivideError InfExtendedReal(0) * InfExtendedReal{Int}(∞)
        @test InfExtendedReal(10) / InfExtendedReal(5) == InfExtendedReal(2)
        @test_throws DivideError InfExtendedReal{Int}(∞) / InfExtendedReal{Int}(∞)
        @test InfExtendedReal(10) / InfExtendedReal{Int}(∞) == InfExtendedReal(0)

        @test abs(InfExtendedReal(-5)) == InfExtendedReal(5)

        @test InfExtendedReal(1) // InfExtendedReal(0) == InfExtendedReal(1//0)
        @test_throws DivideError InfExtendedReal{Int}(∞) // InfExtendedReal{Int}(∞)
        @test InfExtendedReal(1) // 0 == InfExtendedReal(1//0)
        @test 1 // InfExtendedReal(0) == InfExtendedReal(1//0)
    end
end
