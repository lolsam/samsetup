pipeline {
    agent any
    stages {
        stage('Delivery') {
            steps {
                withAWS(credentials: 'vaqa-jenkins', region: 'us-gov-west-1') {
                    sh 'echo "test">test.txt'
                    s3Upload(file: 'text.txt', bucket:"ensvaqacicd", path:'wars-v1/', includePathPattern:'**/*')
                    archiveArtifacts artifacts: 'test.txt', fingerprint: true, onlyIfSuccessful: true
                }
            }
        }
    }
}
