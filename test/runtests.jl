using JuliaArduino
using Test

module test1
	using JuliaArduino
	@loadPinConfig "../arduino.json"

	const LED = D13

	function blink()
		pinMode(LED, OUTPUT)

		while true
			delay(Int16(3000))
			digitalWrite(LED, HIGH)
			delay(Int16(3000))
			digitalWrite(LED, LOW)
		end
	end
end

@testset "JuliaArduino.jl" begin
	target = Arduino("atmega2560", "")
	obj = build(test1.blink, Tuple{}, target=target)
	write("./blink.o",obj)
end