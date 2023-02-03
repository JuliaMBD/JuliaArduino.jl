export LOW, HIGH
export INPUT, OUTPUT, INPUT_PULLUP
export DGPIO, AGPIO, Register, RegisterBit, RegisterAddr, RegisterMask

const PinState = UInt8
const LOW = PinState(0x0)
const HIGH = PinState(0x1)

abstract type AbstractPinMode end
struct InputPinMode <: AbstractPinMode end
struct OutputPinMode <: AbstractPinMode end
struct InputPullupPinMode <: AbstractPinMode end

const INPUT = InputPinMode()
const INPUT_PULLUP = InputPullupPinMode()
const OUTPUT = OutputPinMode()

const RegisterType = UInt8
const RegisterAddr = Ptr{RegisterType}
const RegisterMask = RegisterType

struct Register
    addr::RegisterAddr

    function Register(addr::RegisterAddr)
        new(addr)
    end
end

struct RegisterBit
    addr::RegisterAddr
    bit::RegisterMask

    function RegisterBit(addr::RegisterAddr, bit::Int)
        b = 0x1 << bit
        new(addr, b)
    end
end

get_addr(r::Register)::RegisterAddr = r.addr
get_addr(b::RegisterBit)::RegisterAddr = b.addr
get_bitmask(b::RegisterBit)::RegisterMask = b.bit

abstract type AbstractGPIO end

struct DGPIO <: AbstractGPIO
    DDR::RegisterBit
    PORT::RegisterBit
    PIN::RegisterBit

    function DGPIO(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit)
        new(ddr, port, pin)
    end
end

struct AGPIO <: AbstractGPIO
    DDR::RegisterBit
    PORT::RegisterBit
    PIN::RegisterBit
    TIMER::RegisterBit
    COMPARE::Register

    function AGPIO(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit, timer::RegisterBit, compare::Register)
        new(ddr, port, pin, timer, compare)
    end
end
