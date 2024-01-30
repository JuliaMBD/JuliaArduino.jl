export Serial

export @initserial
export serialwrite
export serialprint
export serialprintln
export @c_str

abstract type AbstractSerial end

struct Serial <: AbstractSerial
    UDR::Register
    UCSRA::Register
    UCSRB::Register
    UCSRC::Register
    UBRR::RegisterBit

    function Serial(UDR::Register, UCSRA::Register, UCSRB::Register,
        UCSRC::Register, UBRR::RegisterBit)
        new(UDR, UCSRA, UCSRB, UCSRC, UBRR)
    end
end

macro initserial(serial, baudrate)
    bps = UInt8(div(16_000_000, 16 * baudrate - 1))
    esc(quote
    set($serial.UCSRA, 0b00000000)
    set($serial.UCSRB, 0b00011000)
    set($serial.UCSRC, 0b00000110)
    set($serial.UBRR, $bps)
    end)
end

function serialwrite(x::Serial, data::UInt8)::Nothing
    while (get(x.UCSRA) & 0b00100000) == 0x0
    end
    set(x.UDR, data)
end

function serialprint(x::Serial, str::SVector{N, UInt8})::Nothing where N
    for s = str
        serialwrite(x, s)
    end
    nothing
end

function serialprintln(x::Serial, str::SVector{N, UInt8})::Nothing where N
    serialprint(x, str)
    serialwrite(x, UInt8('\n'))
    nothing
end

macro c_str(s)
    v = Vector{UInt8}(s)
    esc(:(SVector{$(length(v)+1),UInt8}($(v...), 0x00)))
end