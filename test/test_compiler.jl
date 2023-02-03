module test1
	using JuliaArduino
	@config "../atmega328p.json"

	const LED = D13

	function blink()
		pinMode(LED, OUTPUT)

		while true
			digitalWrite(LED, HIGH)
			digitalWrite(LED, LOW)
		end
	end
end

@testset "blink" begin
	target = Arduino(test1.MMCU, "")
	obj = build(test1.blink, Tuple{}, target=target)
end

module RGB
	using JuliaArduino
	@config "../atmega328p.json"

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
            @delay_ms(50)
            digitalWrite(R, LOW)
            @delay_ms(20)
        end
        return 0
    end
end

@testset "RGB" begin
	target = Arduino(RGB.MMCU, "")
	obj = build(RGB.main, Tuple{}, target=target)
end

module input1
	using JuliaArduino
	@config "../atmega328p.json"

    const SW = D3
    
    function main()::Int8
        pinMode(SW, INPUT)
        return 0
    end
end

@testset "input1" begin
	target = Arduino(input1.MMCU, "")
	obj = build(input1.main, Tuple{}, target=target)
end

module Example
	using JuliaArduino
	@config "../atmega328p.json"

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
            @delay_ms(1)
        end
        return 0
    end
end

@testset "led2" begin
	target = Arduino(Example.MMCU, "")
	obj = build(Example.main, Tuple{}, target=target)
end
