
import IPPMath
using Base.Test

using IPPMath: add, subtract, rsubtract, multiply, divide, rdivide
using IPPMath: add!, subtract!, rsubtract!, multiply!, divide!, rdivide!

# vector op scalar

rsub(x, y) = y .- x

xd = [3.0, 4.0, 5.0, 6.0]
xs = float32(xd)
xz = [3.0+4.0im, 4.0+5.0im, 5.0+6.0im, 7.0+8.0im]
xc = complex64(xz)

c = 2

@test isempty(IPPMath.add(Float64[], c))
@test isempty(IPPMath.subtract(Float64[], c))
@test isempty(IPPMath.rsubtract(Float64[], c))
@test isempty(IPPMath.multiply(Float64[], c))
@test isempty(IPPMath.divide(Float64[], c))

for (f, f!, op) in {(add, add!, .+),
                    (subtract, subtract!, .-),
                    (rsubtract, rsubtract!, rsub),
                    (multiply, multiply!, .*),
                    (divide, divide!, ./)}
    for x in {xs, xd, xz, xc}
        @test f(x, c) == op(x, c)

        x2 = copy(x)
        @test f!(x2, c) === x2
        @test x2 == op(x, c)
    end
end

@test_approx_eq IPPMath.rdivide(xs, c) c ./ xs

x2 = copy(xs)
@test rdivide!(x2, c) === x2
@test x2 == c ./ xs

