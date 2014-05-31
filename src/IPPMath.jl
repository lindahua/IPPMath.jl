module IPPMath

    using ArrayViews
    using IPPCore
    import IPPCore: IppInt, ippint

    export ippversion


    # common

    macro ippscall(ippf, argtypes, args...)
        quote
            ret = ccall(($ippf, "libipps"), IppStatus,
                $argtypes, $(args...))
            ret == 0 || error(ippstatus_string(ret))
        end
    end

    # source files

    include("elementary.jl")

end # module
