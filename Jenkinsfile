pipeline {
    agent any
    stages {
        stage('Delivery') {
            steps {
                withAWS(credentials: 'samtest', region: 'us-gov-west-1') {
                    sh 'echo "test">test.txt'
                    s3Upload(bucket:"ensvaqacicd", path:'wars-v1/', includePathPattern:'**/*'
                }
            }
        }
    }
}
