node {
 properties([
  pipelineTriggers([
   [
    $class: 'GenericTrigger',
    genericVariables: 
    [
        [
            key: 'action', 
            value: '$.action'
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '[^(created)]', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ],
        [
            key: 'comment',
            value: '$.comment.body',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ],
        [
            key: 'org',
            value: '$.organization.login',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '', //Optional, defaults to empty string
            defaultValue: 'ProofOfConceptForJuliSmoothOptimizers' //Optional, defaults to empty string
        ],
        [
            key: 'pullrequest',
            value: '$.issue.number',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '[^0-9]', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ],
        [
            key: 'repo',
            value: '$.repository.name',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ]
    ],
    genericHeaderVariables: [
     [key: 'X-GitHub-Event', regexpFilter: '']
    ],
    printContributedVariables: true,
    printPostContent: true,
    regexpFilterText: '^?[rR]un[Bb]enchmarks? ?$',
    regexpFilterExpression: ''
   ]
  ])
 ])

 stages("build") {
    stage("init") {
        steps {
            echo " Path of Jenkins: ${PATH}"
        }
    }
    stage("sending comment") {
        steps {
            julia --project=./benchmark/ ./benchmark/send_comment_to_pr.jl --org $org --repo $repo --pullrequest $pullrequest -c "Starting Benchmark Build!"
        }
    }
    stage("benchmarking") {
        steps {
            julia ./benchmark/krylov_CI.jl
            echo "BUILD SUCCESS"
        }
    }
 }
 post {
    success {
        julia ./benchmark/send_comment_to_pr.jl --org $org --repo $repo --pullrequest $pullrequest --gist
    }
    failure {
        julia ./benchmark/send_comment_to_pr.jl --org $org --repo $repo --pullrequest $pullrequest -c "Benchmarks failed..."
    }
 }
}