pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the repository
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "*/${BRANCH}"]],
                        userRemoteConfigs: [[
                            url: "${GIT_REPO}",
                            credentialsId: "${GIT_CREDENTIALS_ID}"
                        ]]
                    ])
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Ensure Node.js dependencies are installed
                    sh 'npm install'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run the test suite
                    sh 'npm test'
                }
            }
        }

        stage('Lint Code') {
            steps {
                script {
                    // Lint the codebase
                    sh 'npm run lint'
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    // Build the application (if applicable)
                    sh 'npm run build'
                }
            }
        }
    }

    post {
        always {
            script {
                // Archive test results and artifacts
                archiveArtifacts artifacts: '**/test-results/*.xml', allowEmptyArchive: true
                junit '**/test-results/*.xml'
            }
        }

        success {
            echo 'Build and tests completed successfully!'
        }

        failure {
            echo 'Build or tests failed. Check logs for details.'
        }
    }
}
