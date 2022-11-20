module JuliaArduino

    export myint, volatile_store, digitalWrite, mydelay, MYHIGH, MYLOW, MYOUTPUT, builddump, mypinMode

    const myint = Int16
    #=
    function myfloat(x)
            return x::Float16
    end
    =#

    const MYDDBR = Ptr{UInt8}(36)   #0x24
    const MYPORTB = Ptr{UInt8}(37)  #0x25
    const MYHIGH = 0b00000001
    const MYOUTPUT = 0b00000001
    const MYLOW = 0b00000000

    function volatile_store(x::Ptr{UInt8}, v::UInt8)
            #return println("ok")    #debug
            return Base.llvmcall(
                """
                %ptr = inttoptr i64 %0 to i8*
                store volatile i8 %1, i8* %ptr, align 1
                ret void
                """,
                Cvoid,
                Tuple{Ptr{UInt8},UInt8},
                x,
                v
            )
    end
    
    function digitalWrite(LED_BULTIN::Int64, stm::UInt8)

        if LED_BULTIN==7 && stm == MYHIGH
            v = MYHIGH << LED_BULTIN
            volatile_store(MYPORTB, v)
        elseif stm == MYLOW
            volatile_store(MYPORTB, stm)
        end
    end
    
    function mypinMode(LED_BULTIN::Int64, stm::UInt8)
        v = MYOUTPUT << LED_BULTIN
        volatile_store(MYDDBR, v)
    end

    function keep(x)
        return Base.llvmcall(
            """
            call void asm sideeffect "", "X,~{memory}"(i16 %0)
            ret void
            """,
            Cvoid,
            Tuple{Int16},
            x
        )
    end

    function mydelay(ms::Int16)
            for y in Int16(1):Int16(ms)
            keep(y)
        end
    end

    using GPUCompiler
    using LLVM
        #####
        # Compiler Target
        #####

        struct Arduino <: GPUCompiler.AbstractCompilerTarget end

        GPUCompiler.llvm_triple(::Arduino) = "avr-unknown-unknown"
        GPUCompiler.runtime_slug(::GPUCompiler.CompilerJob{Arduino}) = "native_avr-jl_blink"

        struct ArduinoParams <: GPUCompiler.AbstractCompilerParams end

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

        function native_job(@nospecialize(func), @nospecialize(types))
            @info "Creating compiler job for '$func($types)'"
            source = GPUCompiler.FunctionSpec(
                        func, # our function
                        Base.to_tuple_type(types), # its signature
                        false, # whether this is a GPU kernel
                        GPUCompiler.safe_name(repr(func))) # the name to use in the asm
            target = Arduino()
            params = ArduinoParams()
            job = GPUCompiler.CompilerJob(target, source, params)
        #    return job
        end

        function build_ir(job, @nospecialize(func), @nospecialize(types))
            @info "Bulding LLVM IR for '$func($types)'"
            mi, _ = GPUCompiler.emit_julia(job)
            ir, ir_meta = GPUCompiler.emit_llvm(
                            job, # our job
                            mi; # the method instance to compile
                            libraries=false, # whether this code uses libraries
                            deferred_codegen=false, # is there runtime codegen?
                            optimize=true, # do we want to optimize the llvm?
                            only_entry=false, # is this an entry point?
                            ctx=JuliaContext()) # the LLVM context to use
            return ir, ir_meta
        end

        function build_obj(@nospecialize(func), @nospecialize(types); kwargs...)
            job = native_job(func, types)
            @info "Compiling AVR ASM for '$func($types)'"
            ir, ir_meta = build_ir(job, func, types)
            obj, _ = GPUCompiler.emit_asm(
                        job, # our job
                        ir; # the IR we got
                        strip=true, # should the binary be stripped of debug info?
                        validate=true, # should the LLVM IR be validated?
                        format=LLVM.API.LLVMObjectFile) # What format would we like to create?
            return obj
        end

        function builddump(fun, args)
            obj = build_obj(fun, args)
            write("./jl_blink.o", obj)
            mktemp() do path, io
                write(io, obj)
                flush(io)
                str = read(`avr-objdump -dr $path`, String)
            end |> print
        end




#=export greet
greet() = print("Hello World!")=#
end # module