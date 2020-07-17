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

# Step 2: get correct repository:

api = GitHub.DEFAULT_API
my_username = "MonssafToukal"
my_repo_name = "poc_jenkins_julia"
my_params = Dict(:visibility => "all")
my_repo = Repo(GitHub.gh_get_json(api, "/users/$(my_username)/repos"; params = my_params, auth=my_auth)[1])

# Step 3: fetch all pull_requests

my_params = Dict(:sort => "popularity",
                    :direction => "desc")
my_pull_request = PullRequest(GitHub.gh_get_json(api, "/repos/$(my_username)/$(my_repo.name)/pulls"; params=my_params, auth=myauth)[1])

# Step 4: Post Comment!

comment = GitHub.create_comment(api, my_repo, my_pull_request, "The benchmarks can be found here: $(posted_gist.html_url)"; auth = myauth)



