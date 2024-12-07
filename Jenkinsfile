pipeline {
    agent any
    environment {
        // Set environment variables if needed
        GIT_REPO = 'https://github.com/your-username/your-repo.git'
        BRANCH = 'main' // Change to your branch name
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "${BRANCH}"]],
                    userRemoteConfigs: [[url: "${GIT_REPO}"]]
                ])
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    // Ensure the required tools are installed
                    sh 'npm install'
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    // Run tests
                    sh 'npm test'
                }
            }
        }
        stage('Lint Code') {
            steps {
                script {
                    // Run linting (optional, based on your project setup)
                    sh 'npm run lint'
                }
            }
        }
        stage('Build Application') {
            steps {
                script {
                    // Build the application (optional, for production-ready code)
                    sh 'npm run build'
                }
            }
        }
    }
    post {
        always {
            // Archive test results, logs, or any relevant artifacts
            archiveArtifacts artifacts: '**/test-results/*.xml', allowEmptyArchive: true
            // Publish test results (if using JUnit or other reporting tools)
            junit '**/test-results/*.xml'
        }
        success {
            echo 'Build and tests succeeded!'
        }
        failure {
            echo 'Build or tests failed!'
        }
    }
}
