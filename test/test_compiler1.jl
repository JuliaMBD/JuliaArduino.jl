module Test
	using JuliaArduino
	@config "../atmega328p.json"

	const LED = D6

	function main()
		pinMode(LED, OUTPUT)

		# initTimer(LED)

		while true
			digitalWrite(LED, HIGH)
			keep(0x50)
			digitalWrite(LED, LOW)
			keep(0x50)
			# digitalWrite(LED, HIGH)
			# analogWrite(LED, 0x41)
		end
	end
end

@testset "blink" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	write("Test_main.o", obj)
end
