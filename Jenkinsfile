pipeline {
  agent any
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

     token: 'qaz123',

     printContributedVariables: true,
     printPostContent: true,

     silentResponse: false,

     regexpFilterText: '$comment',
     regexpFilterExpression: '?[rR]un[bB]enchmarks? ?'
    )
  }
  stages {
    stage('print comment') {
      steps {
        sh "echo $comment"
      }
    }
  }
}