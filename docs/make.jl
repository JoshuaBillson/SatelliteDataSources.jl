push!(LOAD_PATH,"../src/")

using SatelliteDataSources
using Documenter

DocMeta.setdocmeta!(SatelliteDataSources, :DocTestSetup, :(using SatelliteDataSources); recursive=true)

makedocs(;
    modules=[SatelliteDataSources],
    authors="Joshua Billson",
    repo="https://github.com/JoshuaBillson/SatelliteDataSources.jl/blob/{commit}{path}#{line}",
    sitename="SatelliteDataSources.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JoshuaBillson.github.io/SatelliteDataSources.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JoshuaBillson/SatelliteDataSources.jl",
    devbranch="main",
)
