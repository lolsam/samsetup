pipeline {
    agent any
    stages {
        stage('Delivery') {
            steps {
                withAWS(credentials: 'samtest', region: 'us-gov-west-1') {
                    sh 'echo "test">test.txt'
                    s3Upload(file: 'test.txt', bucket:"ensvaqacicd", path:'wars-v1/')
                    archiveArtifacts artifacts: 'test.txt', fingerprint: true, onlyIfSuccessful: true
                }
            }
        }
    }
}
