test_date = Date(2012, 1 ,1)
test_datetime = DateTime(2012, 1, 1, 1, 1, 1, 1)
test_time = Time(1, 1, 1, 1)

@testset "InfExtendedTime" begin
    @testset "Base" begin
        @inferred InfExtendedTime{Date}(test_date)
        @inferred InfExtendedTime{Date}(∞)
        @inferred InfExtendedTime{Date}(-∞)
        @inferred InfExtendedTime{Time}(test_time)
        @inferred InfExtendedTime{Time}(∞)
        @inferred InfExtendedTime{Time}(-∞)
        @inferred InfExtendedTime{DateTime}(test_datetime)
        @inferred InfExtendedTime{DateTime}(∞)
        @inferred InfExtendedTime{DateTime}(-∞)
        @test_throws MethodError InfExtendedTime{Time}(test_date)
        @test_throws MethodError InfExtendedTime{Date}(test_time)
        @test_throws MethodError InfExtendedTime{DateTime}(test_time)

        d = InfExtendedTime{Date}(test_date)
        t = InfExtendedTime{Time}(test_time)
        dt = InfExtendedTime{DateTime}(test_datetime)
        @test InfExtendedTime{Date}(dt) == d
        @test InfExtendedTime{Date}(test_datetime) == d
        @test InfExtendedTime{Time}(dt) == t
        @test InfExtendedTime{Time}(test_datetime) == t
        @test InfExtendedTime{DateTime}(dt) == dt

        @test InfExtendedTime(Date) == InfExtendedTime{Date}
        @test InfExtendedTime(Time) == InfExtendedTime{Time}
        @test InfExtendedTime(DateTime) == InfExtendedTime(DateTime)

        @test InfExtendedTime(test_date) == InfExtendedTime{Date}(test_date)
        @test InfExtendedTime(test_time) == InfExtendedTime{Time}(test_time)
        @test InfExtendedTime(test_datetime) == InfExtendedTime{DateTime}(test_datetime)

        @test posinf(typeof(d)) == InfExtendedTime{Date}(∞)
        @test neginf(typeof(d)) == InfExtendedTime{Date}(-∞)
        @test isposinf(InfExtendedTime{Date}(∞))
        @test !isposinf(InfExtendedTime{Date}(-∞))
        @test !isposinf(d)
        @test !isneginf(InfExtendedTime{Date}(∞))
        @test isneginf(InfExtendedTime{Date}(-∞))
        @test !isneginf(d)

        @test posinf(typeof(t)) == InfExtendedTime{Time}(∞)
        @test neginf(typeof(t)) == InfExtendedTime{Time}(-∞)
        @test isposinf(InfExtendedTime{Time}(∞))
        @test !isposinf(InfExtendedTime{Time}(-∞))
        @test !isposinf(t)
        @test !isneginf(InfExtendedTime{Time}(∞))
        @test isneginf(InfExtendedTime{Time}(-∞))
        @test !isneginf(t)

        @test posinf(typeof(dt)) == InfExtendedTime{DateTime}(∞)
        @test neginf(typeof(dt)) == InfExtendedTime{DateTime}(-∞)
        @test isposinf(InfExtendedTime{DateTime}(∞))
        @test !isposinf(InfExtendedTime{DateTime}(-∞))
        @test !isposinf(dt)
        @test !isneginf(InfExtendedTime{DateTime}(∞))
        @test isneginf(InfExtendedTime{DateTime}(-∞))
        @test !isneginf(dt)

        inf = InfExtendedTime{Date}(∞)
        @test d.instant == test_date.instant
        @test t.instant == test_time.instant
        @test inf.instant == ∞
    end

    @testset "IO" begin
        d = InfExtendedTime{Date}(test_date)
        i = InfExtendedTime{Date}(∞)

        @test string(d) == "InfExtendedTime{Date}($(repr(test_date)))"
        @test sprint(show, d, context=:compact=>true) == "2012-01-01"
        @test sprint(show, d) == string(d)

        @test string(i) == "InfExtendedTime{Date}(∞)"
        @test sprint(show, i, context=:compact=>true) == "∞"
        @test sprint(show, i) == string(i)
    end

    @testset "Conversion" begin
        @test promote_rule(InfExtendedTime{DateTime}, InfExtendedTime{Date}) ==
            InfExtendedTime{DateTime}
        @test promote_rule(InfExtendedTime{DateTime}, Date) == InfExtendedTime{DateTime}
        @test promote_rule(InfExtendedTime{Date}, Infinite) == InfExtendedTime{Date}
        @test promote_rule(Infinite, Date) == InfExtendedTime{Date}

        @test convert(InfExtendedTime{Date}, test_datetime) ==
            InfExtendedTime{Date}(test_date)
        @test convert(InfExtendedTime{Date}, InfExtendedTime{DateTime}(test_datetime)) ==
            InfExtendedTime{Date}(InfExtendedTime{DateTime}(test_datetime))
        @test convert(InfExtendedTime{Date}, ∞) == InfExtendedTime{Date}(∞)

        @test promote_rule(InfExtendedTime{ZonedDateTime}, ZonedDateTime) ==
            InfExtendedTime{ZonedDateTime}
    end

    @testset "Parse" begin
        val = tryparse(InfExtendedTime{Date}, "∞")
        @test val == ∞
        @test val isa InfExtendedTime{Date}

        val = tryparse(InfExtendedTime{Date}, "2012-01-01")
        @test val == Date(2012, 1, 1)
        @test val isa InfExtendedTime{Date}

        val = tryparse(InfExtendedTime{Date}, "a")
        @test val == nothing
        @test val isa Nothing
    end

    @testset "Comparison" begin
        @test isfinite(InfExtendedTime{Date}(test_date))
        @test !isfinite(InfExtendedTime{Date}(∞))

        @test isinf(InfExtendedTime{Date}(∞))
        @test isinf(InfExtendedTime{Date}(-∞))
        @test !isinf(InfExtendedTime{Date}(test_date))

        @test InfExtendedTime{Date}(test_date) == InfExtendedTime{Date}(test_date)
        @test InfExtendedTime{Date}(test_date) != InfExtendedTime{Date}(test_date + Day(1))
        @test InfExtendedTime{Date}(∞) == InfExtendedTime{Date}(∞)
        @test InfExtendedTime{Date}(-∞) == InfExtendedTime{Date}(-∞)
        @test InfExtendedTime{Date}(∞) != InfExtendedTime{Date}(-∞)
        @test InfExtendedTime{Date}(-∞) != InfExtendedTime{Date}(∞)
        @test InfExtendedTime{Date}(∞) != InfExtendedTime{Date}(test_date)
        @test InfExtendedTime{Date}(test_date) != InfExtendedTime{Date}(∞)

        @test hash(InfExtendedTime{Date}(∞)) == hash(InfExtendedTime{Date}(∞))
        @test hash(InfExtendedTime{Date}(-∞)) == hash(InfExtendedTime{Date}(-∞))
        @test hash(InfExtendedTime{Date}(∞)) != hash(InfExtendedTime{Date}(-∞))
        @test hash(InfExtendedTime{Date}(test_date)) ==
            hash(InfExtendedTime{Date}(test_date))
        @test hash(InfExtendedTime{Date}(test_date)) !=
            hash(InfExtendedTime{Date}(test_date + Day(1)))

        d1 = InfExtendedTime(test_date)
        d2 = InfExtendedTime(test_date - Day(1))
        d3 = InfExtendedTime(test_date + Day(1))
        @test d1 == d1
        @test d1 <= d1
        @test d1 != d2
        @test d2 < d1
        @test d1 < d3
        @test d2 < d3
        @test d3 > d2
        @test d3 > d1
        @test d1 >= d1

        inf = InfExtendedTime{Date}(∞)
        ninf = InfExtendedTime{Date}(-∞)
        @test ninf < inf
        @test ninf <= ninf
        @test ninf < inf
        @test inf > ninf
        @test inf >= inf

        @test ninf < d1
        @test d3 < inf
        @test inf > d1
        @test d3 > ninf

        @test ∞ == inf
        @test -∞ == ninf
        @test inf == ∞
        @test ninf == -∞

        @test -∞ < inf
        @test ninf < ∞
        @test inf <= ∞
        @test ninf <= -∞
        @test -∞ <= ninf
    end

    @testset "Arithmetic" begin
        @test typemin(InfExtendedTime{Date}) == InfExtendedTime{Date}(-∞)
        @test typemax(InfExtendedTime{Date}) == InfExtendedTime{Date}(∞)

        @test InfExtendedTime(test_date) + Day(1) == InfExtendedTime(test_date + Day(1))
        @test Day(1) + InfExtendedTime(test_date) == InfExtendedTime(test_date + Day(1))
        @test InfExtendedTime(test_date) - Day(1) == InfExtendedTime(test_date - Day(1))
        @test Day(1) - InfExtendedTime(test_date) == InfExtendedTime(test_date - Day(1))
        @test InfExtendedTime{Date}(∞) + Day(1) == InfExtendedTime{Date}(∞)
        @test InfExtendedTime{Date}(∞) - Day(1) == InfExtendedTime{Date}(∞)
        @test InfExtendedTime{Date}(-∞) + Day(1) == InfExtendedTime{Date}(-∞)
        @test InfExtendedTime{Date}(-∞) - Day(1) == InfExtendedTime{Date}(-∞)

        a = InfExtendedTime{Date}(∞)
        b = InfExtendedTime{Date}(-∞)
        c = InfExtendedTime(test_date)

        @test a + ∞ == ∞ + a == a
        @test_throws InfMinusInfError b + ∞
        @test_throws InfMinusInfError ∞ + b
        @test c + ∞ == ∞ + c == a

        @test_throws InfMinusInfError a - ∞
        @test_throws InfMinusInfError ∞ - a
        @test b - ∞ == b
        @test ∞ - b == a
        @test c - ∞ == b
        @test ∞ - c == a

        @test ∞ + test_date == ∞
        @test test_date + ∞ == ∞
        @test ∞ - test_date == ∞
        @test test_date - ∞ == -∞

        @test ∞ + Day(1) == ∞
        @test Day(1) + ∞ == ∞
        @test ∞ - Day(1) == ∞
        @test Day(1) - ∞ == -∞

        @test ∞ + test_date.instant == ∞
        @test test_date.instant + ∞ == ∞
        @test ∞ - test_date.instant == ∞
        @test test_date.instant - ∞ == -∞
    end
end
