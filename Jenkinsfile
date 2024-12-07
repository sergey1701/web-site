pipeline {
    agent { label 'docker' } // Ensure this matches your Jenkins agent label

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute
    }

    parameters {
        choice(
            name: 'SLEEP_TIME',
            choices: ['1', '2', '5', '10', '20', '30'], // Time options in minutes
            description: 'Select the time (in minutes) to wait while the Apache server runs.'
        )
    }

    environment {
        APP_NAME = "apache-web-server"
        DOCKER_IMAGE = "httpd:latest" // Official Apache HTTP Server Docker image
        CONTAINER_NAME = "apache-test-container"
        PORT = "8001" // Initial host port to start trying
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

        stage('Find Available Port and Run Apache Container') {
            steps {
                script {
                    def port = env.PORT.toInteger()
                    while (true) {
                        try {
                            echo "Trying to start Apache container on port ${port}..."
                            sh """
                            docker run -d \
                                --name ${CONTAINER_NAME} \
                                -p ${port}:80 \
                                ${DOCKER_IMAGE};
                            """
                            // If the container starts successfully, break out of the loop
                            env.PORT = port.toString()
                            env.LOCAL_URL = "http://test-server:${env.PORT}"
                            echo "Apache server is running on port ${env.PORT} and accessible at: ${env.LOCAL_URL}"
                            break
                        } catch (Exception e) {
                            echo "Port ${port} failed. Incrementing port and trying again..."
                            port += 1
                        }
                    }
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

        stage('Output URL') {
            steps {
                script {
                    if (env.LOCAL_URL?.trim()) {
                        echo "Apache server was running and accessible at: ${env.LOCAL_URL}"
                    } else {
                        echo "Apache server URL could not be determined. Check logs for details."
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Ensuring no lingering containers..."
            script {
                sh """
                docker ps -a --filter "name=${CONTAINER_NAME}" --format "{{.Names}}" | grep -w ${CONTAINER_NAME} && docker rm -f ${CONTAINER_NAME} || echo "Container ${CONTAINER_NAME} not found. Skipping cleanup."
                """
            }
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
