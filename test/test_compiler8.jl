module Test
	using JuliaArduino
	@config "../atmega2560.json"

    const LED = D4
    const BTN = D5

    function main()
        pinmode(LED, OUTPUT)
        pinmode(BTN, INPUT_PULLUP)
    
        while true
            if digitalread(BTN) == LOW
                digitalwrite(LED, HIGH)
            else
                digitalwrite(LED, LOW)
            end
            @delay_ms(1)
        end
    end
end

@testset "digitalread" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
