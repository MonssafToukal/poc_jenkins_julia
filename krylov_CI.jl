using Pkg
Pkg.activate("./jenkins_env/")

Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators", "LearnBase"])
Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="./"))
Pkg.update()

using PkgBenchmark
using SuiteSparseMatrixCollection
using JSON

ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

master = benchmarkpkg("Krylov", "master")
commit = benchmarkpkg("Krylov")
judgement = judge(commit, master)
export_markdown("judgement.md", judgement)
export_markdown("master.md", master)
export_markdown("commit.md", commit)

gist_json = JSON.parse("""
    {
        "description": "A benchmark for Krylov repository",
        "public": true,
        "files": {
            "judgement.md": {
                "content": "$(escape_string(sprint(export_markdown, judgement)))"
            },
            "master.md": {
                "content": "$(escape_string(sprint(export_markdown, master)))"
            },
            "commit.md": {
                "content": "$(escape_string(sprint(export_markdown, commit)))"
            }
        }
    }""")

# Need to add GITHUB_AUTH to your .bashrc
myauth = GitHub.authenticate(ENV["GITHUB_AUTH"])
posted_gist = create_gist(params = gist_json, auth = myauth)
println(posted_gist.html_url)

