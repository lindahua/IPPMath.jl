# Arithmetics and elementary math functions

## vec op scalar

for (f, ippfpre) in [(:add, "ippsAddC"), 
                     (:subtract, "ippsSubC"), 
                     (:multiply, "ippsMulC"), 
                     (:divide, "ippsDivC"),
                     (:rsubtract, "ippsSubCRev")]

    f! = symbol(string(f, '!'))

    for (T, C, suf) in [(:Float32, :Real, "32f"), 
                        (:Float64, :Real, "64f"), 
                        (:Complex64, :Number, "32fc"), 
                        (:Complex128, :Number, "64fc")]

        ippf = string(ippfpre, '_', suf)

        # functions
        @eval begin
            function $(f!)(y::ContiguousArray{$T}, x::ContiguousArray{$T}, c::$C)
                n = length(x)
                length(y) == n || throw(DimensionMismatch("Inconsistent array lengths."))
                if n > 0
                    @ippscall($ippf, (Ptr{$T}, $T, Ptr{$T}, IppInt), 
                        pointer(x), c, pointer(y), n)
                end
                return y
            end

            $(f!)(x::ContiguousArray{$T}, c::$C) = $(f!)(x, x, c)
            $(f)(x::ContiguousArray{$T}, c::$C) = $(f!)(similar(x), x, c)
        end
    end
end

