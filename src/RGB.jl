module RGB
    include("./JuliaArduino.jl")
    using .JuliaArduino

    const R = pin(6)
    const G = pin(5)
    const B = pin(3)

    function RED()
        pinmode(R, OUTPUT)

        while true
            digitalwrite(R, HIGH)
            delay(int(3000))
            digitalwrite(R, LOW)
            delay(int(3000))
        end
    end

    function RG()
        pinmode(R, OUTPUT)
        pinmode(G, OUTPUT)

        while true
            digitalwrite(R, HIGH)
            delay(int(3000))
            digitalwrite(R, LOW)
            delay(int(3000))
            digitalwrite(G,HIGH)
            delay(int(3000))
            digitalwrite(G,LOW)
            delay(int(3000))
        end
    end

    function RGB3()
        pinmode(R, OUTPUT)
        pinmode(G, OUTPUT)
        pinmode(B, OUTPUT)

        while true
            digitalwrite(R, HIGH)
            delay(int(3000))
            digitalwrite(R, LOW)
            delay(int(3000))
            digitalwrite(G, HIGH)
            delay(int(3000))
            digitalwrite(G, LOW)
            delay(int(3000))
            digitalwrite(B, HIGH)
            delay(int(3000))
            digitalwrite(B, LOW)
            delay(int(3000))
        end
    end

end
