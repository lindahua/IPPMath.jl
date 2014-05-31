# benchmarking of vector math

import IPPMath

macro bench1(f, g!, n)
	f! = symbol(string(f, '!'))
	test1 = symbol(string(f, "_test1"))
	test2 = symbol(string(f, "_test2"))

	quote
		function $(f!)(y, x::AbstractArray)
			for i = 1:length(x)
				@inbounds y[i] = $(f)(x[i])
			end
			y
		end

		function $(test1)(y, x::AbstractArray, k::Int)
			for i = 1:k
				$(f!)(y, x)
			end
		end

		function $(test2)(y, x::AbstractArray, k::Int)
			for i = 1:k
				$(g!)(y, x)
			end
		end

		$(test1)(y, x, 10)
		$(test2)(y, x, 10)

		t1 = @elapsed $(test1)(y, x, $n)
		t2 = @elapsed $(test2)(y, x, $n)
		@printf("%-5s: IPP gain = %8.4fx\n", $(string(f)), t1 / t2)
	end
end

const x = rand(10^4)
const y = zeros(10^4) 


@bench1 abs  IPPMath.abs!  1000
@bench1 abs2 IPPMath.sqr!  1000
@bench1 sqrt IPPMath.sqrt! 1000
@bench1 exp  IPPMath.exp!  1000
@bench1 log  IPPMath.log!  1000
@bench1 atan IPPMath.atan! 1000

