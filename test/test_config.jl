using JSON
import JuliaArduino: loadregisters, loadconfiguration

@testset "loadregisters" begin
    data = JSON.parsefile("../atmega328p.json")
    d, r = loadregisters(data)
    println(d)
    println(r)
end

@testset "loadconfiguration" begin
    expr = loadconfiguration("../atmega328p.json")
    println(expr)
end
