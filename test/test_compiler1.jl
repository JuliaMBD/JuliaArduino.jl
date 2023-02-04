module Test
	using JuliaArduino
	@config "../atmega328p.json"

	const LED = D6

	function main()
		pinMode(LED, OUTPUT)

		initTimer(LED)

		while true
			analogWrite(LED, UInt8(10))
			@delay_ms(500)
			analogWrite(LED, UInt8(200))
			@delay_ms(500)
			# digitalWrite(LED, LOW)
			# # analogWrite(LED, UInt8(200))
			# @delay_ms(500)
			# analogWrite(LED, 0x41)
		end
	end
end

@testset "blink" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	write("Test_main.o", obj)
end
