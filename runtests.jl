
println("Testing IPPMath")
println("-------------------")

tests = ["elementary"]

for t in tests
	fp = joinpath("test", "$(t).jl")
	println("* running $(fp) ...")
	include(fp)
end

println()
