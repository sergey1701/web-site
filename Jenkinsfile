pipeline {
    agent { label 'docker' } // Replace 'docker' with your Jenkins agent label

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute
    }

    environment {
        APP_NAME = "apache-web-server"
        DOCKER_IMAGE = "httpd:latest" // Official Apache HTTP Server Docker image
        CONTAINER_NAME = "apache-container"
        PORT = "8081" // Host port mapped to container port 80
        LOCAL_URL = "http://test-server:${PORT}" // URL to access the container
    }

    stages {
        stage('Check Repository Origin') {
            steps {
                script {
                    // Get the origin URL from Git configuration
                    def origin = sh(script: "git config --get remote.origin.url", returnStdout: true).trim()
                    echo "Detected origin: ${origin}"

                    // Check if the origin contains 'test'
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
                    echo "Starting Apache web server inside a Docker container for 5 minutes..."
                    sh """
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${PORT}:80 \
                        ${DOCKER_IMAGE};
                    echo "Apache server is running and accessible at: ${LOCAL_URL}";
                    sleep 300;
                    docker rm -f ${CONTAINER_NAME};
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! The Apache server was available during the pipeline."
        }
        failure {
            echo "Pipeline failed. The Apache container might not have started correctly."
        }
    }
}
