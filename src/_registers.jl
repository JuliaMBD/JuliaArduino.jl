export Register, RegisterBit, RegisterAddr, RegisterMask

export get_addr
export get_bitmask
export get_bitpos
export volatile_load
export volatile_store!
export set
export get

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
    pos::UInt8

    function RegisterBit(addr::RegisterAddr, bit::Int)
        b = 0x1 << bit
        new(addr, b, UInt8(bit))
    end
end

get_addr(r::Register)::RegisterAddr = r.addr
get_addr(b::RegisterBit)::RegisterAddr = b.addr
get_bitmask(b::RegisterBit)::RegisterMask = b.bit
get_bitpos(b::RegisterBit)::RegisterMask = b.pos

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
    set(r::Resister, x::UInt8)
    set(b::ResisterBit, x::UInt8) x is 0x00 or 0x01

Set a value to resiger
"""
function set(r::Register, x::UInt8)::Nothing
    volatile_store!(get_addr(r), x)
end

function set(b::RegisterBit, x::UInt8)::Nothing
    u = volatile_load(get_addr(b))
    volatile_store!(get_addr(b), (u & ~get_bitmask(b)) | (x << get_bitpos(b)))
end

"""
    get(r::Resister)::UInt8
    get(r::ResisterBit)::UInt8

Get a value from resiger
"""
function get(r::Register)::UInt8
    volatile_load(get_addr(r))
end

function get(b::RegisterBit)::UInt8
    u = volatile_load(get_addr(b))
    (u & get_bitmask(b)) >> get_bitpos(b)
end
