pipeline {
    agent any

    environment {
        TARGET_IP = "192.168.0.146"
        TARGET_USER = "root" 
        CONTAINER_NAME = "laravel_demo_app"
        REMOTE_CMD = "ssh -o StrictHostKeyChecking=no ${TARGET_USER}@${TARGET_IP}"
    }

    stages {
        stage('0. Environment Check') {
            steps {
                script {
                    sh "${REMOTE_CMD} 'docker exec ${CONTAINER_NAME} php -v'"
                }
            }
        }

        stage('2. Sync Code to Target') {
            steps {
                script {
                    sh "rsync -avz -e 'ssh -o StrictHostKeyChecking=no' --exclude='.git' . ${TARGET_USER}@${TARGET_IP}:/tmp/${CONTAINER_NAME}_deploy"
                    sh "${REMOTE_CMD} 'docker cp /tmp/${CONTAINER_NAME}_deploy/. ${CONTAINER_NAME}:/app'"
                    sh "${REMOTE_CMD} 'docker exec ${CONTAINER_NAME} chown -R www-data:www-data /app'"
                }
            }
        }

        stage('3. Update Dependencies & Clear Cache') {
            steps {
                script {
                    sh """
                        ${REMOTE_CMD} "docker exec ${CONTAINER_NAME} bash -c '
                            git config --global --add safe.directory /app && \
                            composer install --no-dev --optimize-autoloader --no-scripts && \
                            php artisan optimize:clear && \
                            php artisan migrate --force && \
                            php artisan filament:upgrade && \
                            php artisan optimize
                        '"
                    """
                }
            }
        }

        stage('4. Cleanup Target Temp Files') {
            steps {
                script {
                    sh "${REMOTE_CMD} 'rm -rf /tmp/${CONTAINER_NAME}_deploy'"
                }
            }
        }
    }

    post {
        success {
            echo "--- Deployment updated successfully for ${CONTAINER_NAME}! ---"
        }
        failure {
            echo "--- Deployment failed ---"
        }
    }
}