using JuliaArduino

module RGB
	using JuliaArduino
	@loadPinConfig "../atmega328p.json"

    const R = D6
    const G = D5
    const B = D3
    
    function main()::Int8
        pinMode(R, OUTPUT)
        pinMode(G, OUTPUT)
        pinMode(B, OUTPUT)

        digitalWrite(R, LOW)
        digitalWrite(G, LOW)
        digitalWrite(B, LOW)

        while true
            digitalWrite(R, HIGH)
            for i = Int16(1):Int16(30)
                delay(Int16(32760))
            end
            digitalWrite(G, HIGH)
            for i = Int16(1):Int16(30)
                delay(Int16(32760))
            end
            digitalWrite(B, HIGH)
            for i = Int16(1):Int16(30)
                delay(Int16(32760))
            end
            digitalWrite(R, LOW)
            for i = Int16(1):Int16(30)
                delay(Int16(32760))
            end
            digitalWrite(G, LOW)
            for i = Int16(1):Int16(30)
                delay(Int16(32760))
            end
        end
        return 0
    end
end

target = Arduino(RGB.MMCU, "")
obj = build(RGB.main, Tuple{}, target=target)
write("rgb.o", obj)
