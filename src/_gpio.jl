export LOW, HIGH
export INPUT, OUTPUT
export GPIO

const PinState = UInt8
const LOW = PinState(0x00)
const HIGH = PinState(0x01)

abstract type AbstractPinMode end
struct InputPinMode <: AbstractPinMode end
struct OutputPinMode <: AbstractPinMode end
struct InputPullupPinMode <: AbstractPinMode end
const INPUT = InputPinMode()
const INPUT_PULLUP = InputPullupPinMode()
const OUTPUT = OutputPinMode()

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
