module JuliaArduino
using StaticArrays
export SVector

include("_registers.jl")
include("_timer.jl")
include("_serial.jl")
include("_gpio.jl")
include("_clock.jl")
include("_interrupt.jl")

include("_loadjson.jl")
include("_compiler.jl")

end # module
