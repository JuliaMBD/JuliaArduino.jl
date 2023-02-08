export Timer8, Timer16

export resettimer
export setwgm
export setcs
export setpwm
export setpwmlevel

export inittimer
export onpwm
export offpwm

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

"""
    resettimer(timer)

Clear all control registers
"""
function resettimer(timer::AbstractTimer)::Nothing
    volatile_store!(get_addr(timer.TCCRA), 0x00)
    volatile_store!(get_addr(timer.TCCRB), 0x00)
end

"""
    setwgm(timer, mode)

Set WGM as a given mode. mode is given by 3 or 4 bits
"""
function setwgm(timer::Timer8, mode::UInt8)::Nothing
    m = 0b0000_0011
    x = volatile_load(get_addr(timer.TCCRA))
    volatile_store!(get_addr(timer.TCCRA), (x & ~m) | (mode & m))
    m = 0b0000_0100
    x = volatile_load(get_addr(timer.TCCRB))
    volatile_store!(get_addr(timer.TCCRB), (x & ~(m << 1)) | ((mode & m) << 1)) 
end

function setwgm(timer::Timer16, mode::UInt8)::Nothing
    m = 0b0000_0011
    x = volatile_load(get_addr(timer.TCCRA))
    volatile_store!(get_addr(timer.TCCRA), (x & ~m) | (mode & m))
    m = 0b0000_1100
    x = volatile_load(get_addr(timer.TCCRB))
    volatile_store!(get_addr(timer.TCCRB), (x & ~(m << 1)) | ((mode & m) << 1)) 
end

"""
    setcs(timer, mode)

Set frequency as a given mode. mode is 3 bits
"""
function setcs(timer::AbstractTimer, mode::UInt8)::Nothing
    m = 0b0000_0111
    x = volatile_load(get_addr(timer.TCCRB))
    volatile_store!(get_addr(timer.TCCRB), (x & ~m) | (mode & m))
end

"""
    setpwm(timer, c)

Set COM bits for the timer. COM bits are 2 bits.
"""
function setpwm(timer::AbstractTimer, c::UInt8)::Nothing
    m = get_bitmask(timer.COM1) | get_bitmask(timer.COM0)
    x = volatile_load(get_addr(timer.TCCRA))
    volatile_store!(get_addr(timer.TCCRA), (x & ~m) | (c & m))
end

"""
    setpwmlevel(timer, x)

Set PWM on with x (0 - 255). Put x into OCR
"""
function setpwmlevel(timer::Timer8, x::UInt8)::Nothing
    volatile_store!(get_addr(timer.OCR), x)
end

function setpwmlevel(timer::Timer16, x::UInt8)::Nothing
    volatile_store!(get_addr(timer.OCRL), x)
end

"""
    initiimer(timer)

Initialize timer
"""
function inittimer(timer::Timer8)::Nothing
    resettimer(timer)
    ## set fast pwm
    setwgm(timer, 0b011)
    ## set frequency as divide 64
    setcs(timer, 0b011)
end

function inittimer(timer::Timer16)::Nothing
    resettimer(timer)
    ## set Phase correct 8bit
    setwgm(timer, 0b0001)
    ## set frequency as divide 64
    setcs(timer, 0b011)
end

"""
    onpwm(timer)
    offpwm(timer)

Set on/off of PWM with only COM1
"""
function onpwm(timer::AbstractTimer)::Nothing
    x = volatile_load(get_addr(timer.COM1))
    volatile_store!(get_addr(timer.COM1), x | get_bitmask(timer.COM1))
end

function offpwm(timer::AbstractTimer)::Nothing
    x = volatile_load(get_addr(timer.COM1))
    volatile_store!(get_addr(timer.COM1), x & ~get_bitmask(timer.COM1))
end
