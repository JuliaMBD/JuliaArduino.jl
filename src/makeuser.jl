module makeuser
    include("./JuliaArduino.jl")
	using JuliaArduino

    function blink() 
		pinmode(LED_BUILTIN, OUTPUT)

		while true
			digitalwrite(LED_BUILTIN, HIGH)
			delay(int(3000))
			digitalwrite(LED_BUILTIN, LOW)
			delay(int(3000))
		end
	end
	builddump(blink,Tuple{})
end
