using JuliaArduino

module Example
	using JuliaArduino
	@loadPinConfig "../atmega328p.json"

    const LED = D13
    const BUTTON = D3
    
    function main()::Int8
        pinMode(LED, OUTPUT)
        pinMode(BUTTON, INPUT_PULLUP)

        while true
            if digitalRead(BUTTON) == LOW
                digitalWrite(LED, HIGH)
            else
                digitalWrite(LED, LOW)
            end
            @delay(1)
        end
        return 0
    end
end

target = Arduino(Example.MMCU, "")
obj = build(Example.main, Tuple{}, target=target)
write("led.o", obj)
