# Arithmetics and elementary math functions

## vec op vec

for (f, ippfpre) in [ (:add,        "ippsAdd"), 
                      (:subtract,   "ippsSub"), 
                      (:multiply,   "ippsMul"), 
                      (:divide,     "ippsDiv")]

    f! = symbol(string(f, '!'))

    for (T, suf) in [(:Float32, "32f"), 
                     (:Float64, "64f")]

        ippf = string(ippfpre, '_', suf)
        ippfI = string(ippf, "_I")

        @eval begin
            function $(f!)(y::ContiguousArray{$T}, x1::ContiguousArray{$T}, x2::ContiguousArray{$T})
                n = length(y)
                length(x1) == length(x2) == n || throw(DimensionMismatch("Inconsistent array lengths."))
                if n > 0
                    @ippscall($ippf, (Ptr{$T}, Ptr{$T}, Ptr{$T}, IPPInt), 
                        pointer(x2), pointer(x1), pointer(y), n)
                end
                return y
            end

            function $(f!)(y::ContiguousArray{$T}, x::ContiguousArray{$T})
                n = length(y)
                length(x) == n || throw(DimensionMismatch("Inconsistent array lengths."))
                if n > 0
                    @ippscall($ippfI, (Ptr{$T}, Ptr{$T}, IPPInt), pointer(x), pointer(y), n)
                end
                return y
            end

            $(f)(x1::ContiguousArray{$T}, x2::ContiguousArray{$T}) = $(f!)(similar(x1), x1, x2)
        end
    end
end


## vec op scalar

for (f, ippfpre) in [(:add,         "ippsAddC"), 
                     (:subtract,    "ippsSubC"), 
                     (:multiply,    "ippsMulC"), 
                     (:divide,      "ippsDivC"),
                     (:rsubtract,   "ippsSubCRev"), 
                     (:rdivide,     "ippsDivCRev")]

    f! = symbol(string(f, '!'))

    for (T, S, suf) in [(:Float32, :Real, "32f"), 
                        (:Float64, :Real, "64f")]

        if f == :rdivide && suf != "32f"
            continue  # ippsDivCRev over float32
        end

        ippf = string(ippfpre, '_', suf)
        ippfI = string(ippf, "_I")

        @eval begin
            function $(f!)(y::ContiguousArray{$T}, x::ContiguousArray{$T}, c::$S)
                n = length(x)
                length(y) == n || throw(DimensionMismatch("Inconsistent array lengths."))
                if n > 0
                    @ippscall($ippf, (Ptr{$T}, $T, Ptr{$T}, IPPInt), 
                        pointer(x), c, pointer(y), n)
                end
                return y
            end

            function $(f!)(y::ContiguousArray{$T}, c::$S)
                n = length(y)
                if n > 0
                    @ippscall($ippfI, ($T, Ptr{$T}, IPPInt), c, pointer(y), n)
                end
                return y
            end
            
            $(f)(x::ContiguousArray{$T}, c::$S) = $(f!)(similar(x), x, c)
        end
    end
end


# unary elementary math functions

for (f, ippfpre) in [(:abs,     "ippsAbs"), 
                     (:sqr,     "ippsSqr"), 
                     (:sqrt,    "ippsSqrt"), 
                     (:exp,     "ippsExp"), 
                     (:log,     "ippsLn"), 
                     (:atan,    "ippsArctan")]

    f! = symbol(string(f, '!'))

    for (T, suf) in [(:Float32, "32f"), 
                     (:Float64, "64f")]

        ippf = string(ippfpre, '_', suf)
        ippfI = string(ippf, "_I")

        @eval begin
            function $(f!)(y::ContiguousArray{$T}, x::ContiguousArray{$T})
                n = length(x)
                length(y) == n || throw(DimensionMismatch("Inconsistent array lengths."))
                if n > 0
                    @ippscall($ippf, (Ptr{$T}, Ptr{$T}, IPPInt), pointer(x), pointer(y), n)
                end
                return y
            end

            function $(f!)(y::ContiguousArray{$T})
                n = length(y)
                if n > 0
                    @ippscall($ippfI, (Ptr{$T}, IPPInt), pointer(y), n)
                end
                return y
            end

            $(f)(x::ContiguousArray{$T}) = $(f!)(similar(x), x)
        end
    end
end

