using JuliaArduino

module RGB
	using JuliaArduino
	@loadPinConfig "./arduino.json"

    const R = D6
    const G = D5
    const B = D3
    const RG = D7
    const RB = D8
    
    function RGB3()::Int16
        pinMode(R, OUTPUT)
        pinMode(G, OUTPUT)
        pinMode(B, OUTPUT)

        while true

            for i = 1:100
                delay(Int16(30000))
            end

            digitalWrite(R, HIGH)
            digitalWrite(G, LOW)
            digitalWrite(B, LOW)

            for i = 1:100
                delay(Int16(30000))
            end

            digitalWrite(R, LOW)
            digitalWrite(G, HIGH)
            digitalWrite(B, LOW)

            for i = 1:100
                delay(Int16(30000))
            end

            digitalWrite(R, LOW)
            digitalWrite(G, LOW)
            digitalWrite(B, HIGH)

        end
        return 0
    end
end

target = Arduino("atmega2560", "")
obj = build(RGB.RGB3, Tuple{}, target=target)
write("RGB3.o", obj)