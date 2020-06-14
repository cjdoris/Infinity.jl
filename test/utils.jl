@testset "Utils" begin
    @test isnothing(posinf(Int))
    @test posinf(Float64) == Inf
    @test posinf(Rational{Int}) == Inf

    @test isnothing(neginf(Int))
    @test neginf(Float64) == -Inf
    @test neginf(Rational{Int}) == -Inf

    @test !hasposinf(Int)
    @test hasposinf(Float64)
    @test hasposinf(Rational{Int})

    @test !hasneginf(Int)
    @test hasneginf(Float64)
    @test hasneginf(Rational{Int})

    @test !hasinf(Int)
    @test hasinf(Float64)
    @test hasinf(Rational{Int})

    @test !isposinf(1)
    @test isposinf(Inf)
    @test !isposinf(-Inf)

    @test !isneginf(1)
    @test !isneginf(Inf)
    @test isneginf(-Inf)
end
