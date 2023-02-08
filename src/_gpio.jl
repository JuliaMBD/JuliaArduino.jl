export LOW, HIGH
export INPUT, OUTPUT, INPUT_PULLUP
export DGPIO, AGPIO, AGPIO8, AGPIO16
export pinMode
export digitalRead
export digitalWrite
export analogWrite
export get_timer

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

"""
    pinMode(pin::GPIO, m::AbstractPinMode)

Set a given pinmode
"""
function pinMode(pin::AbstractGPIO, ::OutputPinMode)::Nothing
    set(pin.DDR, 0b1)
    set(pin.PORT, 0b0)
end

function pinMode(pin::AbstractGPIO, ::InputPinMode)::Nothing
    set(pin.DDR, 0b0)
    set(pin.PORT, 0b0)
end

function pinMode(pin::AbstractGPIO, ::InputPullupPinMode)::Nothing
    set(pin.DDR, 0b0)
    set(pin.PORT, 0b1)
end

"""
    digitalRead(pin::GPIO)

Read a state (high or low) of a given GPIO.
"""
function digitalRead(pin::AbstractGPIO)::PinState
    (get(pin.DDR) == 0b0) ? PinState(get(pin.PORT)) : PinState(get(pin.PIN))
    # if get(pin.DDR) == 0b0 ## OUTPUT
    #     get(pin.PORT) == 0b1 ? HIGH : LOW
    # else
    #     get(pin.PIN) == 0b1 ? HIGH : LOW
    # end
end

"""
    digitalWrite(pin::GPIO, v::PinState)

Write a given pin state (high or low) to GPIO.
"""
function digitalWrite(pin::AbstractDigitalGPIO, x::PinState)::Nothing
    set(pin.PORT, UInt8(x))
    # if x == HIGH
    #     set(pin.PORT, 0b1)
    # else
    #     set(pin.PORT)
    # end
end

function digitalWrite(pin::AbstractAnalogGPIO, x::PinState)::Nothing
    offpwm(pin.TIMER) # reset pwm
    set(pin.PORT, UInt8(x))
    # if x == HIGH
    #     set!(pin.PORT)
    # else
    #     reset!(pin.PORT)
    # end
end

"""
    analogWrite(pin::GPIO, val::UInt8)

Write a given pin to GPIO.
"""
function analogWrite(pin::AbstractAnalogGPIO, val::UInt8)::Nothing
    # if val == 0
    #     digitalWrite(pin, LOW)
    # elseif val == 255
    #     digitalWrite(pin, HIGH)
    # else
    onpwm(pin.TIMER)
    setpwmlevel(pin.TIMER, val)
    # end
end

"""
   get_timer(pin::AbstractAnalogGPIO)

Get timer
"""
function get_timer(pin::AbstractAnalogGPIO)
    pin.TIMER
end
