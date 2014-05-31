
import IPPMath
using Base.Test

# vector op scalar

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

for x in {xs, xd, xz, xc}
    @test IPPMath.add(x, c) == (x .+ c)
    @test IPPMath.subtract(x, c) == (x .- c)
    @test IPPMath.rsubtract(x, c) == (c .- x)
    @test IPPMath.multiply(x, c) == (x .* c)
    @test IPPMath.divide(x, c) == (x ./ c)
end

@test_approx_eq IPPMath.rdivide(xs, c) c ./ xs
