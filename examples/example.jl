using JuliaArduino

module RGB
	using JuliaArduino
	@config "atmega328p.json"

    const R = D6
    # const G = D5
    # const B = D3
    
    function main()::Int8
        pinMode(R, OUTPUT)
        # pinMode(G, OUTPUT)
        # pinMode(B, OUTPUT)

        # digitalWrite(R, LOW)
        # digitalWrite(G, LOW)
        # digitalWrite(B, LOW)

            digitalWrite(R, HIGH)
            # digitalWrite(R, LOW)
        return 0
    end
end

target = Arduino(RGB.MMCU, "")
obj = build(RGB.main, Tuple{}, target=target)
write("rgb.o", obj)
