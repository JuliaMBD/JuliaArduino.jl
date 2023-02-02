export LOW, HIGH
export INPUT, OUTPUT, INPUT_PULLUP
export GPIO

const PinMode = UInt8
const PinState = UInt8

const LOW = PinState(0x00)
const HIGH = PinState(0x01)

const INPUT = PinMode(0x00)
const OUTPUT = PinMode(0x01)
const INPUT_PULLUP = PinMode(0x02)

struct GPIO
    DDR::Ptr{UInt8}
    PORT::Ptr{UInt8}
    PIN::Ptr{UInt8}
    bit::UInt8

    function GPIO(ddr::Ptr{UInt8}, port::Ptr{UInt8}, pin::Ptr{UInt8}, bit::Int)
        b = 0x1 << bit
        new(ddr, port, pin, b)
    end
end
