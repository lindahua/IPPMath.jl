
import IPPMath
using Base.Test

using IPPMath: add, subtract, rsubtract, multiply, divide, rdivide
using IPPMath: add!, subtract!, rsubtract!, multiply!, divide!, rdivide!

# vector op vector

for (f, f!, op) in {(add, add!, .+), 
                    (subtract, subtract!, .-), 
                    (multiply, multiply!, .*),
                    (divide, divide!, ./)}

    for T in [Float32, Float64]
        @test isempty(f(T[], T[]))

        x1 = rand(T, 8)
        x2 = rand(T, 8)
        gt = op(x1, x2)

        @test_approx_eq f(x1, x2) gt

        y = copy(x1)
        @test f!(y, x2) === y
        @test_approx_eq y gt
    end
end

# vector op scalar

rsub(x, y) = y .- x

for (f, f!, op) in {(add, add!, .+), 
                    (subtract, subtract!, .-), 
                    (rsubtract, rsubtract!, rsub),
                    (multiply, multiply!, .*),
                    (divide, divide!, ./)}

    for T in [Float32, Float64]
        @test isempty(f(T[], one(T)))

        x = rand(T, 8)
        c = rand(T)
        gt = op(x, c)

        @test_approx_eq f(x, c) gt

        y = copy(x)
        @test f!(y, c) === y
        @test_approx_eq y gt
    end
end

# unary functions

for (f, f!, op) in {(IPPMath.abs, IPPMath.abs!, abs), 
                    (IPPMath.sqr, IPPMath.sqr!, abs2), 
                    (IPPMath.sqrt, IPPMath.sqrt!, sqrt), 
                    (IPPMath.exp, IPPMath.exp!, exp), 
                    (IPPMath.log, IPPMath.log!, log), 
                    (IPPMath.atan, IPPMath.atan!, atan)}

    for T in [Float32, Float64]
        @test isempty(f(T[]))

        x = rand(T, 8)
        if is(op, abs)
            x .-= convert(T, 0.5)
        end
        gt = op(x)

        @test_approx_eq f(x) gt

        y = copy(x)
        @test f!(y) === y
        @test_approx_eq y gt
    end
end


