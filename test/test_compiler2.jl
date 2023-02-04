module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const R = D6
    const G = D5
    const B = D3
    
    function main()::Int8
        pinMode(R, OUTPUT)
        pinMode(G, OUTPUT)
        pinMode(B, OUTPUT)

        digitalWrite(R, LOW)
        digitalWrite(G, LOW)
        digitalWrite(B, LOW)

        while true
            digitalWrite(R, HIGH)
            @delay_ms(50)
            digitalWrite(R, LOW)
            @delay_ms(20)
        end
        return 0
    end
end

@testset "RGB" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	# write("Test_main.o", obj)
end
