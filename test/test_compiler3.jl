module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const SW = D3
    
    function main()::Int8
        pinmode(SW, INPUT)
        return 0
    end
end

@testset "input1" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
