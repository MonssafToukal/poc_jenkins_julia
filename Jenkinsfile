pipeline { 
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Test') { 
            steps { 
                sh "./test.sh"
            }
        }
        // stage('Benchmark'){
        //     steps {
        //         sh "./build.sh"
        //     }
        // }        
    }
}