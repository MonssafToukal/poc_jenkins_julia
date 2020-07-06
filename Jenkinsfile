pipeline { 
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Test') { 
            steps { 
                julia "./krylov_test.jl"
            }
        }
        // stage('Benchmark'){
        //     steps {
        //         sh "./build.sh"
        //     }
        // }        
    }
}