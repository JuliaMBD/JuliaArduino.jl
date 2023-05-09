export busyloop
export @delay_ms
export @clockCyclesPerMicrosecond

"""
    keep()

NOP with sideeffect
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

"""
    delay_ms(ms)

Execute a busy loop
"""
macro delay_ms(ms)
    esc(:(busyloop(UInt16($ms), M_MSEC1)))
end

"""
    clockCyclesPerMicrosecond()

A value of clockCyclesPerMicrosecond
"""
macro clockCyclesPerMicrosecond()
    esc(:(M_CCPM))
end

macro clockCyclesToMicroseconds(a)
    esc(:($a / M_CCPM))
end

macro microsecondsToClockCycles(a)
    esc(:($a * M_CCPM))
end
