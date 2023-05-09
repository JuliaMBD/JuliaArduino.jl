using JSON
import JuliaArduino: loadregisters, loadtimers, loadgpio, loadconfiguration

@testset "loadregisters" begin
    data = JSON.parsefile("../atmega328p.json")
    d = loadregisters(data)
    println(d)
end

@testset "loadtimers" begin
    data = JSON.parsefile("../atmega328p.json")
    result = loadtimers(data)
    println(result)
end

@testset "loadtimers" begin
    data = JSON.parsefile("../atmega328p.json")
    result = loadgpio(data)
    println(result)
end

@testset "loadconfiguration" begin
    expr = loadconfiguration("../atmega328p.json")
    println(expr)
end
