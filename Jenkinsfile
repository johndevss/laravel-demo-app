pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Clean the workspace and check out the latest code
                cleanWs()
                checkout scm
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    echo 'Building and deploying the application...'
                    // The docker-compose commands will manage the containers.
                    // --build: Rebuilds the 'app' service image with the latest code.
                    // -d: Runs containers in detached mode.
                    // --remove-orphans: Removes containers for services no longer defined.
                    sh 'docker-compose up --build -d --remove-orphans'
                }
            }
        }

        stage('Run Post-Deploy Commands') {
            steps {
                script {
                    echo 'Running database migrations...'
                    // Execute migrations inside the newly created 'app' container
                    sh 'docker-compose exec -T app php artisan migrate --force'

                    echo 'Clearing application caches...'
                    sh 'docker-compose exec -T app php artisan optimize:clear'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}