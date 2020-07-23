using Pkg
Pkg.activate("env/")

using ArgParse
using Git
using GitHub
using Printf
using JSON


function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "--org", "-o"
            help = "Name of GitHub Organization"
            arg_type = String
            default = "ProofOfConceptForJuliSmoothOptimizers"
        "--repo", "-r"
            help = "The name of the repository on GitHub"
            arg_type = String
            required = true
        "--pullrequest", "-p"
            help = "An integer that corresponds to the pull request"
            required = true
            arg_type = Int
        "--gistfile", "-g"
            help = "Path to json file that will be converted to a gist"
            arg_type = String
            default = "./gist.json"
    end

    return parse_args(s, as_symbols=true)
end

function get_repo(api::GitHub.GitHubWebAPI, org::String, repo_name::String; kwargs...)
    my_params = Dict(:visibility => "all")
    # return GitHub.repo(api, repo; params = my_params, kwargs...)
    return Repo(GitHub.gh_get_json(api, "/repos/$(org)/$(repo_name)"; params = my_params, kwargs...))
end

function get_pull_request(api::GitHub.GitHubWebAPI, org::String, repo::Repo, pullrequest_id; kwargs...)
    my_params = Dict(:sort => "popularity",
                    :direction => "desc")
    pull_request = PullRequest(GitHub.gh_get_json(api, "/repos/$(org)/$(repo.name)/pulls/$(pullrequest_id)"; params=my_params, kwargs...))
    return pull_request

end

function post_comment_to_pr(org::String, repo_name::String, pullrequest_id::Int, comment::String; kwargs...)
    api = GitHub.DEFAULT_API
    repo = get_repo(api, org, repo_name; kwargs...)
    pull_request = get_pull_request(api, org, repo, pullrequest_id; kwargs...)
    GitHub.create_comment(api, repo, pull_request, comment; kwargs...)

end

function main()
    # parse the arguments first: 
    parsed_args = parse_commandline()
    org = parsed_args[:org]
    repo_name = parsed_args[:repo]
    pullrequest_id = parsed_args[:pullrequest]
    gistfile = parsed_args[:gistfile]
    # Need to add GITHUB_AUTH to your .bashrc
    myauth = GitHub.authenticate(ENV["GITHUB_AUTH"])
    # get gist from json file:
    gist = begin
        open(gistfile, "r") do f
            return JSON.parse(f)
        end
    end
    posted_gist = create_gist(params = gist, auth = myauth)
    println(posted_gist.html_url)
    comment = "The gist of the benchmarks can be found here: $(posted_gist.html_url)"    
    post_comment_to_pr(org, repo_name, pullrequest_id, comment; auth = myauth)
end

main()