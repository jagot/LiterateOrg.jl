println("Building LiterateOrg.jl")

# Bootstrap package by extracting all package code to a Julia file and
# include it.

src_file = joinpath(dirname(@__FILE__), "..", "src", "LiterateOrg.org")

deps_dir = joinpath(dirname(@__FILE__), "..", "deps")
bootstrap_file = joinpath(deps_dir, "bootstrap.jl")

start_code_pat = r"[ ]*#\+begin_src[ ]+julia(.*)"
end_code_pat = r"[ ]*#\+end_src"

test_pat = r"^([*]+)[ ]+test"
sec_pat = r"^([*]+)"

println("Bootstrapping LiterateOrg.jl to $(bootstrap_file)")

code_mode = false
# We use this to keep track of which section level the last test
# section was seen at. Lower-level sections are parts of the test
# section, and should be skipped from the bootstrap file.
test_level = Inf

open(src_file) do infile
    open(bootstrap_file, "w") do outfile
        for line in readlines(infile)
            global code_mode, test_level
            lline = lowercase(line)
            if occursin(test_pat, lline) && test_level == Inf
                # If we've found a test section and have not seen one
                # before, count the number of stars to find out which
                # level we are on.
                m = match(test_pat, lline)
                test_level = length(m[1])
                continue
            elseif occursin(sec_pat, lline)
                # If we've found a normal section on a higher level
                # than the last seen test section, leave test mode.
                m = match(sec_pat, lline)
                if length(m[1]) < test_level
                    test_level = Inf
                end
                continue
            elseif occursin(start_code_pat, lline) && test_level == Inf
                # Copy code to the bootstrap file, as long as we're
                # not in test mode.
                code_mode = true
                continue
            elseif occursin(end_code_pat, lline)
                code_mode = false
                continue
            end
            code_mode && write(outfile, "$(line)\n")
        end
    end
end

println("Running bootstrap file")
include(bootstrap_file)
rm(bootstrap_file)

println("Tangling LiterateOrg.jl")

tangle_package(src_file, "LiterateOrg")
