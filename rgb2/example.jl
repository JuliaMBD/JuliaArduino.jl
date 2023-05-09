using JuliaArduino

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

        # initTimer(R)
        # initTimer(G)
        # initTimer(B)

        # analogWrite(R, UInt8(0))
        # analogWrite(G, UInt8(0))
        # analogWrite(B, UInt8(0))

        # while true
        #     for i = 0:255
        #         analogWrite(R, UInt8(i))
        #         @delay_ms(500)
        #     end
        #     for i = 0:255
        #         analogWrite(G, UInt8(i))
        #         @delay_ms(500)
        #     end
        #     for i = 0:255
        #         analogWrite(B, UInt8(i))
        #         @delay_ms(500)
        #     end
        # end
        # return 0
        initTimer(R)
        initTimer(G)
        initTimer(B)

        analogWrite(R, UInt8(0))
        analogWrite(G, UInt8(0))
        analogWrite(B, UInt8(0))

        while true
            analogWrite(R, UInt8(255))
            @delay_ms(500)
            analogWrite(G, UInt8(255))
            @delay_ms(500)
            analogWrite(B, UInt8(255))
            @delay_ms(500)
            analogWrite(R, UInt8(0))
            @delay_ms(500)
            analogWrite(G, UInt8(0))
            @delay_ms(500)
            analogWrite(B, UInt8(0))
            @delay_ms(500)
        end
        return 0
    end
end

target = Arduino(RGB.MMCU, "")
obj = build(RGB.main, Tuple{}, target=target)
write("rgb.o", obj)
