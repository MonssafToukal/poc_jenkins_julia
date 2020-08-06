pipeline {
  agent any
  environment {
    julia = "/opt/julia/bin/julia"
  }
  triggers {
    GenericTrigger(
     genericVariables: [
        [
            key: 'action', 
            value: '$.action',
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

     causeString: 'Triggered on $comment',

     token: 'foobar',

     printContributedVariables: true,
     printPostContent: true,

     silentResponse: false,

     regexpFilterText: '$comment',
     regexpFilterExpression: 'runbenchmarks'
    )
  }
  stages {
    stage('run benchmarks') {
      steps {
        sh -x "julia benchmark/krylov_CI.jl"
      }
    }
  }
  post {
    success {
      echo "BUILD SUCCESS"
    }
    failure {
      echo "BUILD FAILURE"
    }
    cleanup {
      sh "rm -f gist.json"
    }
  }
}