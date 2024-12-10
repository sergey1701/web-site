pipeline {
    agent { label 'docker' } // Ensure this matches your Jenkins agent label

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute
    }

    parameters {
        choice(
            name: 'SLEEP_TIME',
            choices: ['1', '2', '5', '10', '20', '30'], // Time options in minutes
            description: 'Select the time (in minutes) to wait while the Apache server runs. test TEST TEST'
        )
    }

    environment {
        APP_NAME = "apache-web-server"
        COMPOSE_FILE = "docker-compose.yml" // Path to docker-compose file
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    echo "Initializing pipeline for ${APP_NAME}..."
                }
            }
        }

        stage('Build and Start Apache') {
            steps {
                script {
                    echo "Building and starting services with docker-compose..."
                    sh """
                    docker-compose -f ${COMPOSE_FILE} up --build -d
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

        stage('Output Logs') {
            steps {
                script {
                    echo "Fetching logs for troubleshooting or verification..."
                    sh """
                    docker-compose -f ${COMPOSE_FILE} logs
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Stopping and cleaning up services..."
            script {
                sh """
                docker-compose -f ${COMPOSE_FILE} down || echo "Failed to stop and clean services."
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
