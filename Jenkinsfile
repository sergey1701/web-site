pipeline {
    agent { label 'docker' } // Replace with the label of your Jenkins agent

    environment {
        APP_NAME = "hello-world-nodejs"
        DOCKER_IMAGE = "node:14" // Using Node.js Docker image
        CONTAINER_NAME = "node-app-container"
        PORT = "3000"
        LOCAL_URL = "http://localhost:${PORT}"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Cloning the repository on the agent..."
                    checkout scm
                }
            }
        }

        stage('Build Node.js Application') {
            steps {
                script {
                    echo "Installing dependencies inside a Docker container..."
                    sh """
                    docker run --rm \
                        -v $WORKSPACE:/app \
                        -w /app \
                        ${DOCKER_IMAGE} \
                        npm install
                    """
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    echo "Starting the application inside a Docker container..."
                    sh """
                    docker run -d --rm \
                        --name ${CONTAINER_NAME} \
                        -p ${PORT}:${PORT} \
                        -v $WORKSPACE:/app \
                        -w /app \
                        ${DOCKER_IMAGE} \
                        node app/server.js
                    """
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
                echo "Cleaning up Docker containers on the agent..."
                sh "docker rm -f ${CONTAINER_NAME} || true"
            }
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
