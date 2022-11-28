module makeuser
    include("./JuliaArduino.jl")
	using JuliaArduino

    const LED_BUILTIN = pin(13) 
    
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
end
