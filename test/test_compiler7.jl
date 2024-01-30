module Test
	using JuliaArduino
	@config "../atmega2560.json"

    const RED = D4
    const GREEN = D3
    const BLUE = D6

    function main()
        pinmode(RED, OUTPUT)
        pinmode(GREEN, OUTPUT)
        pinmode(BLUE, OUTPUT)
    
        digitalwrite(RED, LOW)
        digitalwrite(GREEN, LOW)
        digitalwrite(BLUE, LOW)
    
        while true
            digitalwrite(RED, HIGH)
            @delay_ms(1000)
            digitalwrite(RED, LOW)
            @delay_ms(1000)
            digitalwrite(GREEN, HIGH)
            @delay_ms(1000)
            digitalwrite(GREEN, LOW)
            @delay_ms(1000)
            digitalwrite(BLUE, HIGH)
            @delay_ms(1000)
            digitalwrite(BLUE, LOW)
            @delay_ms(1000)
        end
    end
end

@testset "digitalwrite" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
	# obj2 = build(Test.test2, Tuple{}, target=target, name="timer_ovf")
	# write("Test_main2.o", obj2)
end
