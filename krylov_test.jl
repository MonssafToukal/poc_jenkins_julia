using Pkg
Pkg.activate("./jenkins_env/")
Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators", "LearnBase"])
Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="./"))
Pkg.update()
Pkg.test("Krylov")
