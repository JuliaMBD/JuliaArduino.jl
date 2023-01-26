using JuliaArduino

module RGB
	using JuliaArduino
	@loadPinConfig "../arduino.json"

    const R = D6
    const G = D5
    const B = D3
    
    function main()::Int16
        pinMode(R, OUTPUT)
        pinMode(G, OUTPUT)
        pinMode(B, OUTPUT)

        digitalWrite(R, HIGH)
        digitalWrite(G, LOW)
        digitalWrite(B, LOW)

        while true
            delay(Int16(3000))
        end
        return 0
    end
end

target = Arduino("atmega2560", "")
obj = build(RGB.main, Tuple{}, target=target)
write("rgb.o", obj)
