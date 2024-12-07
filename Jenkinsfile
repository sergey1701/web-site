pipeline {
    agent { label 'docker' } // Replace 'docker' with the label of your Jenkins agent

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute (adjust as needed)
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

                    // Define the expected origin URL
                    def expectedOrigin = "https://github.com/your-username/your-repo.git"

                    // Abort the pipeline if the origin does not match
                    if (origin != expectedOrigin) {
                        error "Origin does not match the expected URL (${expectedOrigin}). Aborting pipeline."
                    } else {
                        echo "Origin matches the expected URL. Proceeding with the build."
                    }
                }
            }
        }

        stage('Run Apache Container') {
            steps {
                script {
                    echo "Starting Apache web server inside a Docker container for 5 minutes..."
                    sh """
                    # Start the container in detached mode
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${PORT}:80 \
                        ${DOCKER_IMAGE};
                    echo "Apache server is running and accessible at: ${LOCAL_URL}";
                    # Wait for 5 minutes
                    sleep 300;

                    # Stop and remove the container after 5 minutes
                    docker rm -f ${CONTAINER_NAME};
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
        success {
            echo "Pipeline completed successfully! The Apache server was available during the pipeline."
        }
        failure {
            echo "Pipeline failed. The Apache container might not have started correctly."
        }
    }
}
