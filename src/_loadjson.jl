export @config

using JSON

"""
    expr = loadregisters(json)

Expr to define registers and their pins from JSON data
"""
function loadregisters(json)
    expr = Expr[]
    for (label, register) = json["Registers"]
        x = Symbol(label)
        addr = parse(UInt64, register["addr"])
        push!(expr, :(const $x = Register(RegisterAddr($addr))))
        for (bitlabel, b) = register["bit"]
            x = Symbol(bitlabel)
            push!(expr, :(const $x = RegisterBit(RegisterAddr($addr), $b)))
        end
    end
    expr
end

"""
    expr = loadtimers(json)

Expr to define timers from JSON data

TCCRA::Register
TCCRB::Register
OCRH::Register
OCRL::Register
WGM3::RegisterBit
WGM2::RegisterBit
WGM1::RegisterBit
WGM0::RegisterBit
CS2::RegisterBit
CS1::RegisterBit
CS0::RegisterBit
COM1::RegisterBit
COM0::RegisterBit
"""
function loadtimers(json)
    ## load
    expr = Expr[]
    for (label, timer) = json["Timers"]
        timerlabel = Symbol(label)
        tccra = Symbol(timer["Registers"][1])
        tccrb = Symbol(timer["Registers"][2])
        cs2 = Symbol(timer["Clock"][1])
        cs1 = Symbol(timer["Clock"][2])
        cs0 = Symbol(timer["Clock"][3])
        com1 = Symbol(timer["Control"][1])
        com0 = Symbol(timer["Control"][2])
        if length(timer["OCR"]) == 1
            wgm2 = Symbol(timer["Wave"][1])
            wgm1 = Symbol(timer["Wave"][2])
            wgm0 = Symbol(timer["Wave"][3])
            ocr = Symbol(timer["OCR"][1])
            push!(expr, Expr(:const, Expr(:(=), timerlabel,
                Expr(:call, :Timer8, tccra, tccrb, ocr,
                    wgm2, wgm1, wgm0, cs2, cs1, cs0, com1, com0))))
        else
            wgm3 = Symbol(timer["Wave"][1])
            wgm2 = Symbol(timer["Wave"][2])
            wgm1 = Symbol(timer["Wave"][3])
            wgm0 = Symbol(timer["Wave"][4])
            ocrh = Symbol(timer["OCR"][1])
            ocrl = Symbol(timer["OCR"][2])
            push!(expr, Expr(:const, Expr(:(=), timerlabel,
                Expr(:call, :Timer16, tccra, tccrb, ocrh, ocrl,
                    wgm3, wgm2, wgm1, wgm0, cs2, cs1, cs0, com1, com0))))
        end
    end
    expr
end

"""
    expr = loadgpio(json)

Expr to define GPIO from JSON data
"""
function loadgpio(data)
    expr = Expr[]
    for (label, config) = data["GPIO"]
        x = Symbol(label)
        ddr = Symbol(config["DDR"])
        port = Symbol(config["PORT"])
        pin = Symbol(config["PIN"])
        if haskey(config, "TIMER")
            timer = Symbol(config["TIMER"])
            push!(expr, :(const $x = AGPIO($ddr, $port, $pin, $timer)))
        else
            push!(expr, :(const $x = DGPIO($ddr, $port, $pin)))
        end
    end
    expr
end

"""
    expr = loadgpio(json)

Expr to define GPIO from JSON data
"""
function loadconfiguration(jsonfile)
    data = JSON.parsefile(jsonfile)
    mmcu = data["MMCU"]
    fcpu = data["F_CPU"]
    ccpm = UInt16(fcpu / 1000000.0)
    msec1 = UInt16(fcpu * 0.00015)
    expr = loadregisters(data)
    push!(expr, loadtimers(data)...)
    push!(expr, loadgpio(data)...)
    push!(expr, :(const MMCU = $mmcu))
    push!(expr, :(const F_CPU = $fcpu))
    push!(expr, :(const M_MSEC1 = $msec1))
    push!(expr, :(const M_CCPM = $ccpm))
    Expr(:block, expr...)
end

macro config(fn)
    esc(loadconfiguration(fn))
end
