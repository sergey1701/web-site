pipeline {
    agent { label 'docker' } // Ensure this matches your Jenkins agent label

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute
    }

    parameters {
        string(name: 'SLEEP_TIME', defaultValue: '300', description: 'Time (in seconds) to wait while the Apache server runs.')
    }

    environment {
        APP_NAME = "apache-web-server"
        DOCKER_IMAGE = "httpd:latest" // Official Apache HTTP Server Docker image
        CONTAINER_NAME = "apache-container"
        PORT = "8081" // Host port mapped to container port 80
        LOCAL_URL = "http://test-server:${PORT}" // URL to access the container
    }

    stages {
        stage('Initialize') {
            steps {
                echo "Initializing pipeline for ${APP_NAME}..."
            }
        }

        stage('Run Apache Container') {
            steps {
                script {
                    echo "Starting Apache web server inside a Docker container..."
                    sh """
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${PORT}:80 \
                        ${DOCKER_IMAGE};
                    echo "Apache server is running and accessible at: ${LOCAL_URL}";
                    """
                }
            }
        }

        stage('Wait and Monitor') {
            steps {
                echo "Waiting for ${params.SLEEP_TIME} seconds while the Apache server runs..."
                script {
                    def totalTime = params.SLEEP_TIME.toInteger()
                    for (int i = totalTime; i > 0; i -= 10) {
                        echo "Time remaining: ${i} seconds"
                        sleep Math.min(10, i) // Sleep for 10 seconds or remaining time
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo "Stopping and removing the Apache container..."
                sh "docker rm -f ${CONTAINER_NAME} || true"
            }
        }

        stage('Output URL') {
            steps {
                echo "Apache server was running and accessible at: ${LOCAL_URL}"
            }
        }
    }

    post {
        always {
            echo "Ensuring no lingering containers..."
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
