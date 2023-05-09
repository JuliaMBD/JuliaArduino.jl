module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const LED = D13
    const BUTTON = D3
    
    function main()::Int8
        pinmode(LED, OUTPUT)
        pinmode(BUTTON, INPUT_PULLUP)

        while true
            if digitalread(BUTTON) == LOW
                digitalwrite(LED, HIGH)
            else
                digitalwrite(LED, LOW)
            end
            @delay_ms(1)
        end
        return 0
    end
end

@testset "led2" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
