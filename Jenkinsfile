pipeline { 
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Test') { 
            steps { 
                withEnv(['PATH+EXTRA=/usr/sbin:/usr/bin:/sbin:/bin']) {  
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
