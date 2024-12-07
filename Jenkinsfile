pipeline {
    agent any

    environment {
        APP_NAME = "hello-world-nodejs"
        DOCKER_IMAGE = "hello-world-nodejs:latest"
        PORT = "3000"
        LOCAL_URL = "http://localhost:${PORT}"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Cloning the repository..."
                    checkout scm
                }
            }
        }

        stage('Build Node.js Application') {
            steps {
                script {
                    echo "Installing dependencies..."
                    sh 'cd app && npm install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE} ./app"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo "Running Docker container..."
                    sh "docker run -d --name ${APP_NAME} -p ${PORT}:${PORT} ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Output URL') {
            steps {
                script {
                    echo "Application is running at: ${LOCAL_URL}"
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Cleaning up old Docker containers..."
                sh "docker rm -f ${APP_NAME} || true"
            }
        }
    }
}
