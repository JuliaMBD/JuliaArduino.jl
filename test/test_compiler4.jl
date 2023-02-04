module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const LED = D13
    const BUTTON = D3
    
    function main()::Int8
        pinMode(LED, OUTPUT)
        pinMode(BUTTON, INPUT_PULLUP)

        while true
            if digitalRead(BUTTON) == LOW
                digitalWrite(LED, HIGH)
            else
                digitalWrite(LED, LOW)
            end
            @delay_ms(1)
        end
        return 0
    end
end

@testset "led2" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	# write("Test_main.o", obj)
end
