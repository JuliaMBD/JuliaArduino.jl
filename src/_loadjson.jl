export @loadPinConfig

using JSON

function loadPinConfiguration(jsonfile)
    data = JSON.parsefile(jsonfile)
    expr = Expr[]
    mmcu = data["MMCU"]
    fcpu = data["F_CPU"]
    push!(expr, :(const MMCU = $mmcu))
    push!(expr, quote
        macro delay(ms)
            msec1 = UInt16($fcpu * 0.001)
            :(busyloop(UInt16($ms), $msec1))
        end
    end)
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
