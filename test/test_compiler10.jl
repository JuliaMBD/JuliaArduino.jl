module Test
	using JuliaArduino

	@config "../atmega2560.json"

    function main()::Int8
        message = c"Hello, World!"
        @initserial(USART0, 4800)

        while true
            serialprintln(USART0, message)
            @delay_ms(1000)
        end

        return 0
    end
end

@testset "serial" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
