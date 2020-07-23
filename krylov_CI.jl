using Pkg
Pkg.activate("./env/")

Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators", "LearnBase","LibGit2"])
Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="./"))
Pkg.update()

using PkgBenchmark
using SuiteSparseMatrixCollection


ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

include("./benchmark/run_benchmarks.jl")




