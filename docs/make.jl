using JuliaArduino
using Documenter

DocMeta.setdocmeta!(JuliaArduino, :DocTestSetup, :(using JuliaArduino); recursive=true)

makedocs(;
    modules=[JuliaArduino],
    authors="Hiroyuki Okamura <okamu@hiroshima-u.ac.jp> and contributors",
    repo="https://github.com/okamumu/JuliaArduino.jl/blob/{commit}{path}#{line}",
    sitename="JuliaArduino.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okamumu.github.io/JuliaArduino.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/okamumu/JuliaArduino.jl",
    devbranch="main",
)
