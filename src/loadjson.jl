using JSON

data = JSON.parsefile("./src/ArduinoPin.json")

for (p,d) = data["GPIO"]
    local ddr::UInt8
    local port::UInt8
    local pin::UInt8
    local bit::Int
    x = Symbol(p)
    for (k,v) = d
        if k == "DDR"
            ddr = parse(UInt8, data["Registers"][v])
        elseif k == "PORT"
            port = parse(UInt8, data["Registers"][v])
        elseif k == "PIN"
            pin = parse(UInt8, data["Registers"][v])
        elseif k == "bit"
            bit = v
        end
    end
    println(:($x = GPIO($ddr, $port, $pin, $bit)))
end
