module Test
	using JuliaArduino
    using StaticArrays
	@config "../atmega328p.json"

    const R = D6
    const G = D5
    const B = D3
    
    function main()::Int8
        inittimer(get_timer(R))
        inittimer(get_timer(G))
        inittimer(get_timer(B))

        pinMode(R, OUTPUT)
        pinMode(G, OUTPUT)
        pinMode(B, OUTPUT)

        digitalWrite(R, HIGH)
        digitalWrite(G, LOW)
        digitalWrite(B, LOW)

        redValue::UInt8 = 0
        greenValue::UInt8 = 0
        blueValue::UInt8 = 0

        while true
            redValue, greenValue, blueValue = 255, 0, 0
            for _ = 0:255
                redValue -= UInt8(1)
                greenValue += UInt8(1)
                analogWrite(R, redValue)
                analogWrite(G, greenValue)
                @delay_ms(10)
            end
            redValue, greenValue, blueValue = 0, 255, 0
            for _ = 0:255
                greenValue -= UInt8(1)
                blueValue += UInt8(1)
                analogWrite(G, greenValue)
                analogWrite(B, blueValue)
                @delay_ms(10)
            end
            redValue, greenValue, blueValue = 0, 0, 255
            for _ = 0:255
                blueValue -= UInt8(1)
                redValue += UInt8(1)
                analogWrite(B, blueValue)
                analogWrite(R, redValue)
                @delay_ms(10)
            end
        end
        return 0
    end
end

@testset "rgbanalog" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	write("Test_main.o", obj)
end
