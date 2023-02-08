module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const R = D6
    const G = D5
    const B = D3
    
    function main()::Int8
        pinmode(R, OUTPUT)
        pinmode(G, OUTPUT)
        pinmode(B, OUTPUT)

        digitalwrite(R, LOW)
        digitalwrite(G, LOW)
        digitalwrite(B, LOW)

        while true
            digitalwrite(R, HIGH)
            @delay_ms(50)
            digitalwrite(R, LOW)
            @delay_ms(20)
        end
        return 0
    end
end

@testset "RGB" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
