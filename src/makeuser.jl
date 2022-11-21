module makeuser
    include("./TestPkg.jl")
	using TestPkg

    const LED_BUILTIN = 7
    
    function blink() 
		mypinMode(LED_BUILTIN, MYOUTPUT)

		while true
			digitalWrite(LED_BUILTIN, MYHIGH)
			mydelay(Myint(3000))
			digitalWrite(LED_BUILTIN, MYLOW)
			mydelay(Myint(3000))
		end
	end
	builddump(blink, Tuple{})
end
