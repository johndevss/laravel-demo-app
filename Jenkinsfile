pipeline {
    agent {
        // Use the Dockerfile in the repository to define the build environment.
        dockerfile true
    }

    environment {
        // Set environment variables for a testing environment.
        // It's recommended to use Jenkins secrets for sensitive data like APP_KEY.
        DB_CONNECTION = 'sqlite'
        DB_DATABASE = ':memory:'
        APP_ENV = 'testing'
        APP_KEY = 'base64:your-testing-app-key-here' // Generate with `php artisan key:generate --show`
        CACHE_STORE = 'array'
        SESSION_DRIVER = 'array'
    }

    stages {
        stage('Checkout') {
            steps {
                // Get the source code from your version control system.
                checkout scm
            }
        }

        stage('Prepare Environment') {
            steps {
                // Copy the example environment file.
                sh 'cp .env.example .env'
                // Generate an application key.
                sh 'php artisan key:generate'
            }
        }

        stage('Install PHP Dependencies') {
            steps {
                // Install dependencies using Composer.
                // Caching the vendor directory can speed up subsequent builds.
                sh 'composer install --no-interaction --optimize-autoloader'
            }
        }

        stage('Install Node.js Dependencies') {
            steps {
                // Install frontend dependencies using npm.
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                // Execute the PHPUnit test suite.
                sh 'php artisan test'
            }
        }

        stage('Build Frontend Assets') {
            steps {
                // Compile frontend assets for production.
                sh 'npm run build'
            }
        }
    }

    post {
        always {
            // Clean up workspace after the pipeline runs.
            cleanWs()
        }
    }
}