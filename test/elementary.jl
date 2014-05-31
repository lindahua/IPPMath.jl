
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
    @test IPPMath.add(xs, c) == (xs .+ c)
    @test IPPMath.subtract(xs, c) == (xs .- c)
    @test IPPMath.rsubtract(xs, c) == (c .- xs)
    @test IPPMath.multiply(xs, c) == (xs .* c)
    @test IPPMath.divide(xs, c) == (xs ./ c)
end

