module Test
	using JuliaArduino
    using StaticArrays
	@config "../atmega2560.json"

    const R = D6 #D13
    const G = D5 #D4
    const B = D3 #D9
    
    function main()::Int8
        inittimer(get_timer(R))
        inittimer(get_timer(G))
        inittimer(get_timer(B))

        pinmode(R, OUTPUT)
        pinmode(G, OUTPUT)
        pinmode(B, OUTPUT)

        digitalwrite(R, HIGH)
        digitalwrite(G, LOW)
        digitalwrite(B, LOW)

        redValue::UInt8 = 0
        greenValue::UInt8 = 0
        blueValue::UInt8 = 0

        while true
            redValue, greenValue, blueValue = 0, 0, 0
            for _ = 0:255
                redValue += UInt8(1)
                analogwrite(R, redValue)
                @delay_ms(10)
            end
            redValue, greenValue, blueValue = 0, 0, 0
            for _ = 0:255
                greenValue += UInt8(1)
                analogwrite(G, greenValue)
                @delay_ms(10)
            end
            redValue, greenValue, blueValue = 0, 0, 0
            for _ = 0:255
                blueValue += UInt8(1)
                analogwrite(B, blueValue)
                @delay_ms(10)
            end
        end
        return 0
    end
end

@testset "rgbanalog" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target, name="main")
	write("Test_main.o", obj)
end
