using JuliaArduino
using Test

module test1
	using JuliaArduino
	@loadPinConfig "../arduino.json"

	const LED = D0

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
	target = Arduino("avr6", "")
	obj = build(test1.blink, Tuple{}, target=target)
end
