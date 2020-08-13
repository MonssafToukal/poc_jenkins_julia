using Pkg
println("pwd: $(pwd())")
cd("./benchmark/")
println("pwd: $(pwd())")
Pkg.activate(".")
Pkg.instantiate()
Pkg.add(PackageSpec(path="../")) 

using GitHub, JSON, PkgBenchmark

print("benchmarking commit:")
commit = benchmarkpkg("Krylov")  # current state of repository
print("benchmarking master: ")
master = benchmarkpkg("Krylov", "master")
print("judging: ")
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
    
open("gist.json", "w") do f
    JSON.print(f, gist_json)
end