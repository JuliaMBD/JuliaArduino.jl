export volatile_load, volatile_store!
export pinMode, digitalRead, digitalWrite
export busyloop

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
    pinMode(pin::GPIO, m::PinMode)

Set a given pinmode
"""
function pinMode(pin::GPIO, m::PinMode)::Nothing
    d = volatile_load(pin.DDR)
    s = volatile_load(pin.PORT)
    if m == OUTPUT
        volatile_store!(pin.PORT, s & ~pin.bit)
        volatile_store!(pin.DDR, d | pin.bit)
    elseif m == INPUT
        volatile_store!(pin.PORT, s & ~pin.bit)
        volatile_store!(pin.DDR, d & ~pin.bit)
    elseif m == INPUT_PULLUP
        volatile_store!(pin.DDR, d & ~pin.bit)
        volatile_store!(pin.PORT, s | pin.bit)
    end
    nothing
end

"""
    digitalRead(pin::GPIO)

Read a state (high or low) of a given GPIO.
"""
function digitalRead(pin::GPIO)::PinState
    d = volatile_load(pin.DDR)
    if d & pin.bit == 0x1 ## OUTPUT
        s = volatile_load(pin.PORT)
        (s & pin.bit != 0x0) ? HIGH : LOW
    else
        s = volatile_load(pin.PIN)
        (s & pin.bit != 0x0) ? HIGH : LOW
    end
end

"""
    digitalWrite(pin::GPIO, v::PinState)

Write a given pin state (high or low) to GPIO.
"""
function digitalWrite(pin::GPIO, v::PinState)::Nothing
    s = volatile_load(pin.PORT)
    if v == HIGH
        volatile_store!(pin.PORT, s | pin.bit)
    else
        volatile_store!(pin.PORT, s & ~pin.bit)
    end
    nothing
end

"""
    busyloop(x, unit)

Execute a busy loop for x * unit times
"""
function busyloop(x::UInt16, unit::UInt16)::Nothing
    for _ = UInt16(1):x
        for _ = UInt16(1):unit
            keep()
        end
    end
end

function delay_ms(ms::UInt16)
    msec1 = UInt16(F_CPU * 0.001)
    busyloop(ms, msec1)
end

# macro delay_ms(ms)
#     global F_CPU
#     msec1 = UInt16(F_CPU * 0.001)
#     :(busyloop(UInt16($ms), $msec1))
# end
