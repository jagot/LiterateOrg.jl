using LiterateOrg
using Base.Test

const testfile = joinpath(dirname(@__FILE__), "..", "deps", "build", "tests.jl")
if isfile(testfile)
    include(testfile)
else
    error("LiterateOrg not properly installed. Please run Pkg.build(\"LiterateOrg\") then restart Julia.")
end
