using Pkg
Pkg.activate("./benchmark/")


Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="."))
Pkg.update()

using SuiteSparseMatrixCollection

ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

include("./run_benchmarks.jl")




