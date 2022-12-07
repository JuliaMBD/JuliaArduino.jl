using JuliaArduino
using Test

@testset "JuliaArduino.jl" begin
    # Write your tests here.

    function blink() 
		pinmode(LED_BUILTIN, OUTPUT)

		while true
			digitalwrite(LED_BUILTIN, HIGH)
			delay(int(3000))
			digitalwrite(LED_BUILTIN, LOW)
			delay(int(3000))
		end
	end
	builddump(blink, Tuple{})
    #blink_test
end
