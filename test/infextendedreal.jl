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

        # Emulate issue https://github.com/cjdoris/Infinity.jl/issues/23 where
        # `InfExtendedReal{Float64}(-∞)` was called and the undefined `Float64` bits ended
        # up being an `Inf` with the opposite sign.
        #
        # Note: Since we're relying on non-deterministic behaviour of undefined fields we
        # need to limit the possiblities for `finitevalue` such that we get an infinite
        # value with the opposite sign from `flag`. By using `Infinite` we ensure we always
        # have a infinite value but we cannot be sure that `finitevalue` and `flag` have
        # opposite signs. Finally, defining two instances improves our chances of producing
        # a instance with opposite signs.
        x = InfExtendedReal{InfExtendedReal{Infinite}}(-∞)
        y = InfExtendedReal{InfExtendedReal{Infinite}}(∞)
        # @assert x.finitevalue == ∞ || y.finitevalue == -∞  # Cannot be guaranteed

        @test x.flag == Infinity.NEGINF
        @test x.val == -∞
        @test isneginf(x)
        @test !isposinf(x)

        @test y.flag == Infinity.POSINF
        @test y.val == ∞
        @test !isneginf(y)
        @test isposinf(y)
    end

    @testset "IO" begin
        x = InfExtendedReal{Int64}(2)
        i = InfExtendedReal{Int64}(∞)
        f = InfExtendedReal{Float64}(Inf)

        @test string(x) == "InfExtendedReal{Int64}(2)"
        @test sprint(show, x, context=:compact=>true) == "2"
        @test sprint(show, x) == string(x)

        @test string(i) == "InfExtendedReal{Int64}(∞)"
        @test sprint(show, i, context=:compact=>true) == "∞"
        @test sprint(show, i) == string(i)

        @test string(f) == "InfExtendedReal{Float64}(Inf)"
        @test sprint(show, f, context=:compact=>true) == "Inf"
        @test sprint(show, f) == string(f)
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
