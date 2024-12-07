pipeline {
    agent { label 'docker' }

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute hello
    }

    environment {
        APP_NAME = "apache-web-server"
        DOCKER_IMAGE = "httpd:latest"
        CONTAINER_NAME = "apache-container"
        PORT = "8081"
        LOCAL_URL = "http://test-server:${PORT}"
    }

    stages {
        stage('Check Repository Origin') {
            steps {
                script {
                    echo "Starting repository origin check..."
                    def origin = sh(script: "git config --get remote.origin.url || echo 'no-origin'", returnStdout: true).trim()
                    echo "Detected origin: ${origin}"

                    if (!origin.contains("test")) {
                        error "Origin does not contain 'test'. Aborting pipeline."
                    } else {
                        echo "Origin contains 'test'. Proceeding with the pipeline."
                    }
                }
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
                    echo "Apache server is running at: ${LOCAL_URL}";
                    sleep 300;
                    docker rm -f ${CONTAINER_NAME};
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Ensuring the Apache container is cleaned up..."
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
