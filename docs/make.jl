push!(LOAD_PATH,"../src/")

using SatelliteTypes
using Documenter

DocMeta.setdocmeta!(SatelliteTypes, :DocTestSetup, :(using SatelliteTypes); recursive=true)

makedocs(;
    modules=[SatelliteTypes],
    authors="Joshua Billson",
    repo="https://github.com/JoshuaBillson/SatelliteTypes.jl/blob/{commit}{path}#{line}",
    sitename="SatelliteTypes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JoshuaBillson.github.io/SatelliteTypes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JoshuaBillson/SatelliteTypes.jl",
    devbranch="main",
)
