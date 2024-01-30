module Test
	using JuliaArduino
    using StaticArrays

	@config "../atmega2560.json"

    macro c_str(s)
        v = Vector{UInt8}(s)
        esc(:(SVector{$(length(v)+1),UInt8}($(v...), 0x00)))
    end

    function main()::Int8
        cstr = c"Hello"
    #    println("Hello, World!")
    #    num = length(str)

        for s = cstr
            message = UInt8(s)
        end

        return 0
    end
end

@testset "struint8" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
