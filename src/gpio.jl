module gpio
using JSON
    export pin, ppstr
    struct ppstr
            DDR::Ptr{UInt8}
            PORT::Ptr{UInt8}
            PIN::Ptr{UInt8}
            bit::UInt8
    end

    function pin(x::Int64)
        io = JSON.parsefile("./src/ArduinoPin.json")
        S = ppstr(Ptr{UInt8}(io["data"][x+1]["DDR"]), 
            Ptr{UInt8}(io["data"][x+1]["PORT"]), 
            Ptr{UInt8}(io["data"][x+1]["PIN"]), 
            UInt8(io["data"][x+1]["bit"]))
        return S
    end
end  
