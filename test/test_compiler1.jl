module Test
	using JuliaArduino
	@config "../atmega328p.json"

	mutable struct Global
		cnt::UInt8
	end

	const LED = D13
	const globalenv = Global(UInt8(0))

	function test2()
		globalenv.cnt += UInt8(1)
		nothing
	end

	function main()
		# cli() ## test whether it creates or not
		# sei() ## test whether it creates or not
		pinmode(LED, OUTPUT)

		while true
			digitalwrite(LED, HIGH)
			# @delay_ms(500)
			digitalwrite(LED, LOW)
			# @delay_ms(500)
		end
	end
end

@testset "blink" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
	# obj2 = build(Test.test2, Tuple{}, target=target, name="timer_ovf")
	# write("Test_main2.o", obj2)
end
