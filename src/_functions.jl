export volatile_load, volatile_store!, keep
export set!, reset!
export offPWM, onPWM, initTimer
export pinMode, digitalRead, digitalWrite, analogWrite
export busyloop, @delay_ms

"""
    volatile_store!(addr::Ptr{UInt8}, v::UInt8)

Return an LLVM-based function to volatile write an 8bit value to a given address.
"""
function volatile_store!(addr::Ptr{UInt8}, v::UInt8)::Nothing
    Base.llvmcall(
        """
        %ptr = inttoptr i64 %0 to i8*
        store volatile i8 %1, i8* %ptr, align 1
        ret void
        """,
        Cvoid, Tuple{Ptr{UInt8},UInt8}, addr, v
    )
end

"""
    volatile_load(addr::Ptr{UInt8})::UInt8

Return an LLVM-based function to volatile read an 8bit value from a given address.
"""
function volatile_load(addr::Ptr{UInt8})::UInt8
    Base.llvmcall(
        """
        %ptr = inttoptr i64 %0 to i8*
        %val = load volatile i8, i8* %ptr, align 1
        ret i8 %val
        """,
        UInt8, Tuple{Ptr{UInt8}}, addr
    )
end

"""
    keep(x)

Sleep for a given x
"""
function keep()::Nothing
    Base.llvmcall(
        """
        call void asm sideeffect "", "" ()
        ret void
        """,
        Cvoid, Tuple{}
    )
    nothing
end

"""
   R |= x
"""
function equal!(addr::RegisterAddr, x::UInt8)::Nothing
    volatile_store!(addr, x)
end

function andequal!(addr::RegisterAddr, x::UInt8)::Nothing
    d = volatile_load(addr)
    volatile_store!(addr, d & x)
end

function orequal!(addr::RegisterAddr, x::UInt8)::Nothing
    d = volatile_load(addr)
    volatile_store!(addr, d | x)
end

function equal!(r::Register, x::UInt8)::Nothing
    equal!(get_addr(r), x)
end

function andequal!(r::Register, x::UInt8)::Nothing
    andequal!(get_addr(r), x)
end

function orequal!(r::Register, x::UInt8)::Nothing
    orequal!(get_addr(r), x)
end

function set!(b::RegisterBit)::Nothing
    orequal!(get_addr(b), get_bitmask(b))
end

function reset!(b::RegisterBit)::Nothing
    andequal!(get_addr(b), ~get_bitmask(b))
end

function isset(b::RegisterBit)::Bool
    x = volatile_load(get_addr(b))
    x & get_bitmask(b) != 0x0
end

"""
    initTimer(timer)

Initialize timer
"""
function initTimer(pin::AGPIO8)::Nothing
    initTimer(pin.TIMER)
end

function initTimer(pin::AGPIO16)::Nothing
    initTimer(pin.TIMER)
end

function resetTimer(timer::AbstractTimer)::Nothing
    volatile_store!(get_addr(timer.TCCRA), 0x00)
    volatile_store!(get_addr(timer.TCCRB), 0x00)
end

function setWGM(timer::Timer8, mode::UInt8)::Nothing
    m = 0b00000011
    x = volatile_load(get_addr(timer.TCCRA))
    volatile_store!(get_addr(timer.TCCRA), (x & ~m) | (mode & m))
    m = 0b00000100
    x = volatile_load(get_addr(timer.TCCRB))
    volatile_store!(get_addr(timer.TCCRB), (x & ~(m << 1)) | ((mode & m) << 1)) 
end

function setWGM(timer::Timer8, mode::UInt8)::Nothing
    m = 0b00000011
    x = volatile_load(get_addr(timer.TCCRA))
    volatile_store!(get_addr(timer.TCCRA), (x & ~m) | (mode & m))
    m = 0b00001100
    x = volatile_load(get_addr(timer.TCCRB))
    volatile_store!(get_addr(timer.TCCRB), (x & ~(m << 1)) | ((mode & m) << 1)) 
end

function setCS(timer::AbstractTimer, mode::UInt8)::Nothing
    x = volatile_load(get_addr(timer.TCCRB))
    volatile_store!(get_addr(timer.TCCRB), (x & 0x07) | mode)
end

function initTimer(timer::Timer8)::Nothing
    resetTimer(timer)
    ## fast pwm
    setWGM(timer, 0b011)
    ## divide 64
    setCS(timer, 0b011)
end

function initTimer(timer::Timer16)::Nothing
    resetTimer(timer)
    ## fast pwm
    setWGM(timer, 0b0001)
    ## divide 64
    setCS(timer, 0b011)
end

"""
    onPWM(timer, x)

Set PWM with x (0 - 255)
"""
function onPWM(timer::Timer8, x::UInt8)::Nothing
    set!(timer.COM1)
    equal!(timer.OCR, x)
end

function onPWM(timer::Timer16, x::UInt8)::Nothing
    set!(timer.COM1)
    equal!(timer.OCRL, x)
end

"""
    offPWM(timer, x)

Set PWM with x (0 - 255)
"""
function offPWM(timer::AbstractTimer)::Nothing
    reset!(timer.COM1)
end

"""
    pinMode(pin::GPIO, m::AbstractPinMode)

Set a given pinmode
"""
function pinMode(pin::AbstractGPIO, ::OutputPinMode)::Nothing
    set!(pin.DDR)
    reset!(pin.PORT)
end

function pinMode(pin::AbstractGPIO, ::InputPinMode)::Nothing
    reset!(pin.DDR)
    reset!(pin.PORT)
end

function pinMode(pin::AbstractGPIO, ::InputPullupPinMode)::Nothing
    reset!(pin.DDR)
    set!(pin.PORT)
end

"""
    digitalRead(pin::GPIO)

Read a state (high or low) of a given GPIO.
"""
function digitalRead(pin::AbstractGPIO)::PinState
    if isset(pin.DDR) ## OUTPUT
        isset(pin.PORT) ? HIGH : LOW
    else
        isset(pin.PIN) ? HIGH : LOW
    end
end

"""
    digitalWrite(pin::GPIO, v::PinState)

Write a given pin state (high or low) to GPIO.
"""
function digitalWrite(pin::AbstractDigitalGPIO, x::PinState)::Nothing
    if x == HIGH
        set!(pin.PORT)
    else
        reset!(pin.PORT)
    end
end

function digitalWrite(pin::AbstractAnalogGPIO, x::PinState)::Nothing
    offPWM(pin.TIMER) # reset pwm
    if x == HIGH
        set!(pin.PORT)
    else
        reset!(pin.PORT)
    end
end

"""
    analogWrite(pin::GPIO, val::UInt8)

Write a given pin to GPIO.
"""
function analogWrite(pin::AbstractAnalogGPIO, val::UInt8)::Nothing
    if val == 0
        digitalWrite(pin, LOW)
    elseif val == 255
        digitalWrite(pin, HIGH)
    else
        onPWM(pin.TIMER, val)
    end
end

"""
    busyloop(x, unit)

Execute a busy loop for x * unit times
"""
function busyloop(x::UInt16, unit::UInt16)::Nothing
    for i = UInt16(1):x
        for j = UInt16(1):unit
            keep()
        end
    end
end

