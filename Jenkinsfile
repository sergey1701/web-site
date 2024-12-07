pipeline {
    agent { label 'docker' } // Ensure this matches your Jenkins agent label

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute
    }

    parameters {
        choice(
            name: 'SLEEP_TIME',
            choices: ['1', '2', '5', '10'], // Time options in minutes
            description: 'Select the time (in minutes) to wait while the Apache server runs.'
        )
    }

    environment {
        APP_NAME = "apache-web-server"
        DOCKER_IMAGE = "httpd:latest" // Official Apache HTTP Server Docker image
        CONTAINER_NAME = "apache-test-container"
        PORT = "8082" // Initial host port mapped to container port 80
        LOCAL_URL = "" // URL to be updated dynamically
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    echo "Initializing pipeline for ${APP_NAME}..."
                }
            }
        }

        stage('Check Port Availability') {
            steps {
                script {
                    // Function to check if a port is in use
                    def isPortInUse = { port ->
                        return sh(script: "netstat -tuln | grep ':${port} ' || true", returnStatus: true) == 0
                    }

                    // Check the initial port and find an available one if necessary
                    def port = env.PORT.toInteger()
                    while (isPortInUse(port)) {
                        echo "Port ${port} is in use. Trying next port..."
                        port += 1
                    }

                    // Update the environment variables with the available port
                    env.PORT = port.toString()
                    env.LOCAL_URL = "http://test-server:${env.PORT}"
                    echo "Selected port ${env.PORT} for the Apache server."
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
                    echo "Apache server is running and accessible at: ${LOCAL_URL}";
                    """
                }
            }
        }

        stage('Wait and Monitor') {
            steps {
                echo "Waiting for ${params.SLEEP_TIME} minute(s) while the Apache server runs..."
                script {
                    def totalMinutes = params.SLEEP_TIME.toInteger()
                    def totalTime = totalMinutes * 60 // Convert minutes to seconds
                    for (int i = totalTime; i > 0; i -= 10) {
                        echo "Time remaining: ${i / 60} minute(s) and ${i % 60} second(s)"
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
