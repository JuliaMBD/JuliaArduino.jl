module gpio
using DelimitedFiles
    export pin, ppstr
    struct ppstr
            DDR::Ptr{UInt8}
            PORT::Ptr{UInt8}
            PIN::Ptr{UInt8}
            bit::UInt8
    end

    function pin(x::Int64)
        io = zeros(Int64, 54,4)
        io = readdlm("./src/2560.txt", ',',Int64, '\n')
        S = ppstr(Ptr{UInt8}(io[x+1,1]), 
            Ptr{UInt8}(io[x+1,2]), 
            Ptr{UInt8}(io[x+1,3]), 
            UInt8(io[x+1,4]))
        return S
    end


end  
