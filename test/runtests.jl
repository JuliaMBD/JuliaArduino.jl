using JuliaArduino
using Test

module test1
	using JuliaArduino
	@loadPinConfig "../atmega2560.json"

	const LED = D13

	function blink()
		pinMode(LED, OUTPUT)

		while true
			digitalWrite(LED, HIGH)
			digitalWrite(LED, LOW)
		end
	end
end

@testset "atmega2560" begin
	target = Arduino(test1.MMCU, "")
	obj = build(test1.blink, Tuple{}, target=target)
end

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
            @delay(50)
            digitalWrite(R, LOW)
            @delay(20)
        end
        return 0
    end
end

@testset "atmega328p" begin
	target = Arduino(RGB.MMCU, "")
	obj = build(RGB.main, Tuple{}, target=target)
end

module input1
	using JuliaArduino
	@loadPinConfig "../atmega328p.json"

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
