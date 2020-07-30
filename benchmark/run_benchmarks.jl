using GitHub, JSON, PkgBenchmark

print("benchmarking master: ")
master = benchmarkpkg("Krylov", "origin/master")
print("benchmarking commit:")
commit = benchmarkpkg("Krylov")  # current state of repository
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