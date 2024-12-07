pipeline {
    agent { label 'local-docker' } // Use the local agent

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'docker run --rm -v $WORKSPACE:/app -w /app node:14 npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker run --rm -v $WORKSPACE:/app -w /app node:14 npm test'
            }
        }

        stage('Build Application') {
            steps {
                sh 'docker run --rm -v $WORKSPACE:/app -w /app node:14 npm run build'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed!'
        }
    }
}