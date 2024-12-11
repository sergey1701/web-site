pipeline {
    agent { label 'docker' } // Ensure this matches your Jenkins agent label

    triggers {
        pollSCM('* * * * *') // Poll SCM every minute for changes
    }

    environment {
        APP_NAME = "apache-web-server"
        COMPOSE_FILE = "docker-compose.yml" // Path to docker-compose file
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    echo "Initializing deployment pipeline for ${APP_NAME}..."
                }
            }
        }

        stage('Build and Start Apache') {
            steps {
                script {
                    echo "Building and starting services with docker-compose, without recreating containers..."
                    sh """
                    docker-compose -f ${COMPOSE_FILE} up --build --no-recreate -d
                    """
                }
            }
        }

        stage('Output Logs') {
            steps {
                script {
                    echo "Fetching logs for verification..."
                    sh """
                    docker-compose -f ${COMPOSE_FILE} logs
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Deployment process completed."
        }
        success {
            echo "Pipeline successfully deployed to production!"
        }
        failure {
            echo "Deployment failed. Check logs for errors."
        }
    }
}
