export LOW, HIGH
export INPUT, OUTPUT
export GPIO

const PinMode = UInt8
const PinState = UInt8

const LOW = PinState(0x00)
const HIGH = PinState(0x01)

const INPUT = PinMode(0x00)
const OUTPUT = PinMode(0x01)

struct GPIO
    DDR::Ptr{UInt8}
    PORT::Ptr{UInt8}
    PIN::Ptr{UInt8}
    bit::UInt8

    function GPIO(ddr::Ptr{UInt8}, port::Ptr{UInt8}, pin::Ptr{UInt8}, bit::Int)
        b = 0x1 << bit
        if Int64(ddr) < Int64(0x100)
            ddr = Ptr{UInt8}(Int64(ddr) + Int64(0x20))
            port = Ptr{UInt8}(Int64(port) + Int64(0x20))
            pin = Ptr{UInt8}(Int64(pin) + Int64(0x20))         
        end
        new(ddr, port, pin, b)
    end
end
