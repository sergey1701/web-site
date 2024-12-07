pipeline {
    agent { label 'local-docker' } // Replace 'docker' with the label of your Jenkins agent

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute (adjust as needed)
    }

    environment {
        APP_NAME = "apache-web-server"
        DOCKER_IMAGE = "httpd:latest" // Official Apache HTTP Server Docker image
        CONTAINER_NAME = "apache-container"
        PORT = "8081" // Host port mapped to container port 80
        LOCAL_URL = "http://jenkins:${PORT}" // URL to access the container
    }

    stages {
        stage('Run Apache Container') {
            steps {
                script {
                    echo "Starting Apache web server inside a Docker container..."
                    sh """
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${PORT}:80 \
                        ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Output URL') {
            steps {
                script {
                    echo "Apache server is running and accessible at: ${LOCAL_URL}"
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Ensuring the Apache container is stopped after the pipeline..."
                sh "docker rm -f ${CONTAINER_NAME} || true"
            }
        }
        success {
            echo "Pipeline completed successfully! The Apache server was available during the pipeline."
        }
        failure {
            echo "Pipeline failed. The Apache container might not have started correctly."
        }
    }
}
