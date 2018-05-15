using LiterateOrg
using Base.Test

const testfile = joinpath(dirname(@__FILE__), "literate_org_tangled_tests.jl")
if isfile(testfile)
    include(testfile)
else
    error("LiterateOrg not properly installed. Please run Pkg.build(\"LiterateOrg\") then restart Julia.")
end
