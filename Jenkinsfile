pipeline { 
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Test') { 
            steps { 
                withEnv(['PATH+JULIA=/opt/julia-1.0.5/bin:$HOME/.local/bin']) {  
                    sh "./test.sh"
                }
            }
        }
        // stage('Benchmark'){
        //     steps {
        //         sh "./build.sh"
        //     }
        // }        
    }
}
