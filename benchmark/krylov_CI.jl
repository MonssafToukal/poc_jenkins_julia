using Pkg
Pkg.activate("./benchmark/")
print("load path 1: $(Base.load_path())")


Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="."))
Pkg.update()
print("load path 2: $(Base.load_path())")

using SuiteSparseMatrixCollection

ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

include("./run_benchmarks.jl")




