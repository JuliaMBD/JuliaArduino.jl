# JuliaArduino

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://okamumu.github.io/JuliaArduino.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://okamumu.github.io/JuliaArduino.jl/dev/)
[![Build Status](https://travis-ci.com/okamumu/JuliaArduino.jl.svg?branch=main)](https://travis-ci.com/okamumu/JuliaArduino.jl)

Compile a Julia program for Arduino.

## Using Docker environment

This tool requires the AVR-backend of LLVM, but it has not been implemented in LLVM used by Julia. Therefore, we need to compile Julia from the source codes with LLVM having AVR backend. To make it easy, we recommand to use Docker. The following command executes Julia with AVR backend as a Docker container:
```sh
docker run -it --rm --name julia -v $(pwd):/home/work -w /home/work okamumu/julia:1.8.3-arduino
```
Since `bash` runs in the container, Julia is executed by
```
% julia
```

## Installation

The package requires JSON, LLVM and GPUCompiler packages for Julia. Probably, they can be installed when the packages will also be installed.
```julia
using Pkg
Pkg.add("JuliaArduino")
```
In addition, the package needs the package `gcc-avr` to handle the binary file of AVR. It can be installed
```sh
apt update
apt install gcc-avr
```

## Compile Julia codes

This tool provides an ELF (Executable and Linkable Format) file from the module written by Julia. The example of Julia code is in the following.

```julia
module Test
	using JuliaArduino
	@config "atmega328p.json"

	const LED = D13
    
    function main()::Int8
		pinmode(LED, OUTPUT)
		while true
			digitalwrite(LED, HIGH)
            @delay_ms(500)
			digitalwrite(LED, LOW)
            @delay_ms(500)
		end
        return 0
    end
end
```

The code has one module `Test`. In the module, there are three constants `R`, `G` and `B`, and one function `main`. 

The following code is an example of compiling the module defined above.

```julia
target = Arduino(Test.MMCU, "")
obj = build(Test.main, Tuple{},
            target=target, name="main")
write("Test_main.o", obj)
```

The variable `target` means the target MCU for the binary. In this case, it uses the variable `MMCU` which is defined in the module `Test`. This variable is defined in the macro `@config atmega328p.json`. The function `build` makes the binary data. The first argument is the function to be compiled. The second argument indicates the type of argument of the function given as the first argument. In this case, `Test.main` does not take any argument and thus the second argument of `build` is `Tuple{}`. The successive arguments indicate the target of MCU (`target`), the name of compiled function in ELF (`name`).
The returned value of `build` is the binary data of ELF, and then it can be written in the file with the function `write`.

