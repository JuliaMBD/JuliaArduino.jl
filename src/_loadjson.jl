export @config

using JSON

"""
    bits, resigters = loadregisters(json)

Define registers and their pins from JSON data
"""
function loadregisters(json)
    registers = Dict{String,Tuple{RegisterAddr,Vector{String}}}()
    bits = Dict{String,Tuple{RegisterAddr,Int}}()
    ## load register
    for (label, register) = json["Registers"]
        addr = parse(UInt64, register["addr"])
        bitlabels = String[]
        for (bitlabel, b) = register["bit"]
            bits[bitlabel] = (addr, b)
            push!(bitlabels, bitlabel)
        end
        registers[label] = (addr, bitlabels)
    end
    bits, registers
end

function loadconfiguration(jsonfile)
    data = JSON.parsefile(jsonfile)
    mmcu = data["MMCU"]
    fcpu = data["F_CPU"]
    bits, registers = loadregisters(data)
    expr = Expr[]
    for (label, config) = data["GPIO"]
        pinlabel = Symbol(label)
        addr, bit = bits[config["DDR"]]
        ddrexpr = :(RegisterBit($addr, $bit))
        addr, bit = bits[config["PORT"]]
        portexpr =:(RegisterBit($addr, $bit))
        addr, bit = bits[config["PIN"]]
        pinexpr = :(RegisterBit($addr, $bit))
        if haskey(config, "TIMER")
            addr, bit = bits[config["TIMER"]]
            timerexpr = :(RegisterBit($addr, $bit))
            addr, _ = registers[config["COMPARE"]]
            compareexpr = :(Register($addr))
            push!(expr, :(const $pinlabel = AGPIO($ddrexpr, $portexpr, $pinexpr, $timerexpr, $compareexpr)))
        else
            push!(expr, :(const $pinlabel = DGPIO($ddrexpr, $portexpr, $pinexpr)))
        end
    end
    push!(expr, :(const MMCU = $mmcu))
    push!(expr, quote
        macro delay_ms(ms)
            busyloop(UInt16(ms), $(UInt16(fcpu * 0.00015)))
        end
    end)
    Expr(:block, expr...)
end

macro config(fn)
    esc(loadconfiguration(fn))
end
