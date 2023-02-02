using JuliaArduino

module READ
	using JuliaArduino
	@loadPinConfig "./atmega2560.json"

    const ledPin = D5
    const buttonApin = D9
    const buttonBpin = D8
    

    function READ1()::Int8
        leds = 0x0
        pinMode(ledPin, OUTPUT)
        pinMode(buttonBpin, INPUT_PULLUP)

        while true
            leds = digitalRead(buttonBpin)
            if leds == HIGH
                digitalWrite(ledPin, HIGH)
            else
                digitalWrite(ledPin, LOW)
            end
        end
    end
    
    function main()::Int8
        pinMode(ledPin, OUTPUT)
        pinMode(buttonApin, INPUT)
        digitalWrite(buttonApin, HIGH)
        pinMode(buttonBpin, INPUT)
        digitalWrite(buttonBpin, HIGH)

        while true
            if digitalRead(buttonApin) == LOW
                digitalWrite(ledPin, HIGH)
            end
            if digitalRead(buttonBpin) == LOW
                digitalWrite(ledPin, LOW)
            end
        end
    end

    function pullup()::Int8
        pinMode(ledPin, OUTPUT)
        pinMode(buttonApin, INPUT_PULLUP)
        pinMode(buttonBpin, INPUT_PULLUP)

        while true
            if digitalRead(buttonApin) == LOW
                digitalWrite(ledPin, HIGH)
            end
            if digitalRead(buttonBpin) == LOW
                digitalWrite(ledPin, LOW)
            end
        end
    end
end

target = Arduino(READ.MMCU, "")
obj = build(READ.pullup, Tuple{}, target=target)
write("pullup.o", obj)
