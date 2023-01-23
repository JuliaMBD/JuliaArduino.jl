module gpio
using JSON
    export pin, ppstr, alphabet, bitor

    const alphabet = zeros(UInt8, 12, 3)

    struct ppstr
            DDR::Ptr{UInt8}
            PORT::Ptr{UInt8}
            PIN::Ptr{UInt8}
            bit::UInt8
            name::Int64
    end

    function pin(x::Int64)
        io = JSON.parsefile("./src/ArduinoPin.json")
        S = ppstr(Ptr{UInt8}(io["data"][x+1]["DDR"]), 
            Ptr{UInt8}(io["data"][x+1]["PORT"]), 
            Ptr{UInt8}(io["data"][x+1]["PIN"]), 
            UInt8(io["data"][x+1]["bit"]),
            io["data"][x+1]["bit"])
        return S
    end

    function bitor(P::ppstr, reg::Int64)
        for i = 1:12
            if P.name == i
                alphabet[i,reg] = alphabet[i,reg] ⊻ P.bit
                return alphabet[i,reg]
            end
        end
    end

end  
