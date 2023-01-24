"""
    volatile_store!(addr::Ptr{UInt8}, v::UInt8)

Return an LLVM-based function to volatile write an 8bit value to a given address.
"""
function volatile_store!(addr::Ptr{UInt8}, v::UInt8)
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
    digitalRead(pin::GPIO)

Read a state (high or low) of a given GPIO.
"""
function digitalRead(pin::GPIO)
    s = volatile_load(pin.PORT)
    if s & pin.bit != 0x0
        return HIGH
    else
        return LOW
    end
end

"""
    digitalWrite(pin::GPIO, ::PinState)

Write a given pin state (high or low) to GPIO.
"""
function digitalWrite(pin:GPIO, v::PinState)
    s = volatile_load(pin.PORT)
    if v == HIGH
        volatile_store(pin.PORT, s | pin.bit)
    else
        volatile_store(pin.PORT, s & ~pin.bit)
    end
end
