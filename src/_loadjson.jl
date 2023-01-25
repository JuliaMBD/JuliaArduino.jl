export @loadPinConfig

using JSON

function loadPinConfiguration(jsonfile)
    data = JSON.parsefile(jsonfile)
    expr = Expr[]
    for (p,d) = data["GPIO"]
        local ddr::Ptr{UInt8}
        local port::Ptr{UInt8}
        local pin::Ptr{UInt8}
        local bit::Int
        x = Symbol(p)
        for (k,v) = d
            if k == "DDR"
                ddr = Ptr{UInt8}(parse(UInt64, data["Registers"][v]))
            elseif k == "PORT"
                port = Ptr{UInt8}(parse(UInt64, data["Registers"][v]))
            elseif k == "PIN"
                pin = Ptr{UInt8}(parse(UInt64, data["Registers"][v]))
            elseif k == "bit"
                bit = v
            end
        end
        push!(expr, :(const $x = GPIO($ddr, $port, $pin, $bit)))
    end
    Expr(:block, expr...)
end

macro loadPinConfig(fn)
    esc(loadPinConfiguration(fn))
end
