@testset "Infinite" begin
    @testset "Base" begin
        @test_throws MethodError Infinite()
        @inferred Infinite(true)
        @inferred Infinite(false)

        @test Infinite(∞) == ∞

        buf = IOBuffer()
        showerror(buf, InfMinusInfError())
        msg = String(take!(buf))
        @test msg == "∞-∞ is undefined"
    end

    @testset "IO" begin
        inf = Infinite(false)
        ninf = Infinite(true)

        @test string(inf) == "∞"
        @test sprint(show, inf, context=:compact=>true) == "∞"
        @test sprint(show, inf) == string(inf)

        @test string(ninf) == "-∞"
        @test sprint(show, ninf, context=:compact=>true) == "-∞"
        @test sprint(show, ninf) == string(ninf)
    end

    @testset "Conversion" begin
        @test_throws InexactError convert(Int, ∞)
        @test convert(Float64, ∞) == Inf
        @test convert(Rational{Int}, ∞) == 1//0

        @test_throws InexactError convert(Infinite, 2)
        @test convert(Infinite, Inf) == ∞
        @test convert(Infinite, 1//0) == ∞

        @test convert(Infinite, ∞) == ∞

        @test one(Infinite) == Infinity.UnknownReal
        @test zero(Infinite) == Infinity.UnknownReal
        @test float(Infinite) == float(Int)
        @test float(Infinity.UnknownReal) == float(Int)
    end

    @testset "Comparison" begin
        x = ∞
        @test !isfinite(x)
        @test !isfinite(-x)
        @test isinf(x)
        @test isinf(-x)
        @test x == x
        @test x != -x
        @test hash(x) != hash(-x)
        @test -x < x
        @test x > -x
        @test x <= x
        @test -x >= -x
        @test signbit(-x)
        @test !signbit(x)
        @test sign(x) == 1
        @test sign(-x) == -1
        @test isapprox(x, x)
        @test !isapprox(x, -x)
    end

    @testset "Arithmetic" begin
        x = ∞
        @test typemin(Infinite) == -x
        @test typemax(Infinite) == x

        @test +x == x
        @test -x == -x
        @test -(-x) == x

        @test_throws InfMinusInfError x - x
        @test x + x == x
        @test -x + -x == -x
        @test -x - x == -x

        @test x * x == x
        @test x * -x == -x
        @test -x * x == -x
        @test -x * -x == x

        @test_throws DivideError x / x

        @test abs(x) == x
        @test abs(-x) == x

        @test_throws DivideError x // x
        @test x // 2 == 1//0
        @test 2 // x == 0//1
    end

    @testset "Rand" begin
        @test typeof(rand(Infinite)) === Infinite

        Random.seed!(1)
        @test rand(Infinite) == ∞
        @test rand(Infinite) == ∞
        @test rand(Infinite) == -∞
    end
end
