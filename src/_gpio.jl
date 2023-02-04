export LOW, HIGH
export INPUT, OUTPUT, INPUT_PULLUP
export Register, RegisterBit, RegisterAddr, RegisterMask
export Timer8, Timer16
export DGPIO, AGPIO, AGPIO8, AGPIO16

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

abstract type AbstractTimer end

struct Timer8 <: AbstractTimer
    TCCRA::Register
    TCCRB::Register
    OCR::Register
    WGM2::RegisterBit
    WGM1::RegisterBit
    WGM0::RegisterBit
    CS2::RegisterBit
    CS1::RegisterBit
    CS0::RegisterBit
    COM1::RegisterBit
    COM0::RegisterBit

    function Timer8(TCCRA::Register, TCCRB::Register, OCR::Register,
        WGM2::RegisterBit, WGM1::RegisterBit, WGM0::RegisterBit,
        CS2::RegisterBit, CS1::RegisterBit, CS0::RegisterBit,
        COM1::RegisterBit, COM0::RegisterBit)
        new(TCCRA, TCCRB, OCR, WGM2, WGM1, WGM0, CS2, CS1, CS0, COM1, COM0)
    end
end

struct Timer16 <: AbstractTimer
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

    function Timer16(TCCRA::Register, TCCRB::Register, OCRH::Register, OCRL::Register,
        WGM3::RegisterBit, WGM2::RegisterBit, WGM1::RegisterBit, WGM0::RegisterBit,
        CS2::RegisterBit, CS1::RegisterBit, CS0::RegisterBit,
        COM1::RegisterBit, COM0::RegisterBit)
        new(TCCRA, TCCRB, OCRH, OCRL, WGM3, WGM2, WGM1, WGM0, CS2, CS1, CS0, COM1, COM0)
    end
end

abstract type AbstractGPIO end
abstract type AbstractDigitalGPIO <: AbstractGPIO end
abstract type AbstractAnalogGPIO <: AbstractGPIO end

struct DGPIO <: AbstractDigitalGPIO
    DDR::RegisterBit
    PORT::RegisterBit
    PIN::RegisterBit

    function DGPIO(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit)
        new(ddr, port, pin)
    end
end

struct AGPIO8 <: AbstractAnalogGPIO
    DDR::RegisterBit
    PORT::RegisterBit
    PIN::RegisterBit
    TIMER::Timer8

    function AGPIO8(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit, timer::Timer8)
        new(ddr, port, pin, timer)
    end
end

struct AGPIO16 <: AbstractAnalogGPIO
    DDR::RegisterBit
    PORT::RegisterBit
    PIN::RegisterBit
    TIMER::Timer16

    function AGPIO16(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit, timer::Timer16)
        new(ddr, port, pin, timer)
    end
end

function AGPIO(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit, timer::Timer8)
    AGPIO8(ddr, port, pin, timer)
end

function AGPIO(ddr::RegisterBit, port::RegisterBit, pin::RegisterBit, timer::Timer16)
    AGPIO16(ddr, port, pin, timer)
end

