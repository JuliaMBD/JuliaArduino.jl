
export native_job
export build_ir
export build_obj
export build
export Arduino

using GPUCompiler
using LLVM

import GPUCompiler

struct Arduino <: GPUCompiler.AbstractCompilerTarget
    cpu::String
    feature::String
end

GPUCompiler.llvm_triple(::Arduino) = "avr-unknown-unknown"
GPUCompiler.runtime_slug(::GPUCompiler.CompilerJob{Arduino}) = "native_avr-jl_blink"

struct ArduinoParams <: GPUCompiler.AbstractCompilerParams end

function GPUCompiler.llvm_machine(@nospecialize(target::Arduino))
    triple = GPUCompiler.llvm_triple(target)
    t = LLVM.API.Target(triple=triple)
    tm = LLVM.API.TargetMachine(t, triple, target.cpu, target.feature)
    # println(unsafe_string(LLVM.API.LLVMGetTargetMachineCPU(tm)))
    # println(unsafe_string(LLVM.API.LLVMGetTargetMachineFeatureString(tm)))
    LLVM.API.asm_verbosity!(tm, true)
    return tm
end

module StaticRuntime
    # the runtime library
    signal_exception() = return
    malloc(sz) = C_NULL
    report_oom(sz) = return
    report_exception(ex) = return
    report_exception_name(ex) = return
    report_exception_frame(idx, func, file, line) = return
end

GPUCompiler.runtime_module(::GPUCompiler.CompilerJob{<:Any,ArduinoParams}) = StaticRuntime
GPUCompiler.runtime_module(::GPUCompiler.CompilerJob{Arduino}) = StaticRuntime
GPUCompiler.runtime_module(::GPUCompiler.CompilerJob{Arduino,ArduinoParams}) = StaticRuntime

function native_job(@nospecialize(func), @nospecialize(types), target)
    @info "Creating compiler job for '$func($types)'"
    source = GPUCompiler.FunctionSpec(
                func,                              # target function
                Base.to_tuple_type(types),         # signature
                false,                             # whether this is a GPU kernel
                GPUCompiler.safe_name(repr(func))) # the name to use in the asm
    # target = Arduino()
    params = ArduinoParams()
    job = GPUCompiler.CompilerJob(target, source, params)
    job
end

function build_ir(job, @nospecialize(func), @nospecialize(types))
    @info "Bulding LLVM IR for '$func($types)'"
    mi, _ = GPUCompiler.emit_julia(job)
    GPUCompiler.emit_llvm(
                    job,                    # target job
                    mi;                     # the method instance to compile
                    libraries=false,        # whether this code uses libraries
                    deferred_codegen=false, # is there runtime codegen?
                    optimize=true,          # do we want to optimize the llvm?
                    only_entry=false,       # is this an entry point?
                    ctx=JuliaContext())     # the LLVM context to use
end

function build_obj(@nospecialize(func), @nospecialize(types); target=target) #, kwargs...)
    job = native_job(func, types, target)
    @info "Compiling AVR ASM for '$func($types)'"
    ir, ir_meta = build_ir(job, func, types)
    obj, _ = GPUCompiler.emit_asm(
                job,                            # target job
                ir;                             # the IR we got
                strip=true,                     # should the binary be stripped of debug info?
                validate=true,                  # should the LLVM IR be validated?
                format=LLVM.API.LLVMObjectFile) # What format would we like to create?
    obj
end

function build(fun, args; target=target)
    obj = build_obj(fun, args, target=target)
    mktemp() do path, io
        write(io, obj)
        flush(io)
        str = read(`avr-objdump -dr $path`, String)
    end |> print
    obj
end
