pipeline {
    agent any

    environment {
        CONTAINER_NAME = "laravel_demo_app"
    }

    stages {
        stage('0. Environment Check') {
            steps {
                script {
                    sh "docker exec ${CONTAINER_NAME} php -v"
                }
            }
        }

        stage('1. Run Tests') {
            steps {
                script {
                    echo "--- Running Unit and Feature Tests ---"
                    sh "docker exec ${CONTAINER_NAME} php artisan test --parallel"
                }
            }
        }

        stage('2. Sync Code to Container') {
            steps {
                script {
                    sh "docker cp . ${CONTAINER_NAME}:/app"
                    sh "docker exec ${CONTAINER_NAME} chown -R www-data:www-data /app"
                }
            }
        }

        stage('3. Update Dependencies & Clear Cache') {
            steps {
                script {
                    sh "docker exec ${CONTAINER_NAME} git config --global --add safe.directory '*'"
                    sh "docker exec ${CONTAINER_NAME} composer install --no-dev --optimize-autoloader --no-scripts"
                    sh "docker exec ${CONTAINER_NAME} rm -f bootstrap/cache/services.php bootstrap/cache/packages.php bootstrap/cache/config.php"
                    sh "docker exec ${CONTAINER_NAME} php artisan optimize:clear"
                    sh "docker exec ${CONTAINER_NAME} php artisan migrate --force"
                    sh "docker exec ${CONTAINER_NAME} php artisan filament:upgrade"
                    sh "docker exec ${CONTAINER_NAME} php artisan optimize"
                }
            }
        }
    }

    post {
        success {
            echo "--- Deployment updated successfully for laravel_demo_app! ---"
        }
        failure {
            echo "--- Deployment failed---"
        }
    }
}
