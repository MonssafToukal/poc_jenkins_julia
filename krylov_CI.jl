using Pkg
Pkg.activate("./jenkins_env/")

Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators", "LearnBase","LibGit2"])
Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="./"))
Pkg.update()

using PkgBenchmark
using SuiteSparseMatrixCollection
using JSON
using LibGit2
using GitHub

ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

repo = LibGit2.GitRepo(@__DIR__)
println("checkout on master: ", LibGit2.lookup_branch(repo, "master") === nothing && LibGit2.branch!(repo, "master", force=true))
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

