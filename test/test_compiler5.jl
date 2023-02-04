module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const R = D6
    const G = D5
    const B = D3
    
    function main()::Int8
        pinMode(R, OUTPUT)
        pinMode(G, OUTPUT)
        pinMode(B, OUTPUT)

        initTimer(R)
        initTimer(G)
        initTimer(B)

        analogWrite(R, UInt8(0))
        analogWrite(G, UInt8(0))
        analogWrite(B, UInt8(0))

        while true
            for i = 0:255
                analogWrite(R, UInt8(i))
                @delay_ms(50)
            end
            for i = 0:255
                analogWrite(G, UInt8(i))
                @delay_ms(50)
            end
            for i = 0:255
                analogWrite(B, UInt8(i))
                @delay_ms(50)
            end
        end
        return 0
    end
end

@testset "rgbanalog" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	# write("Test_main.o", obj)
end
