pipeline {
    agent any

    triggers {
        // This will poll your SCM on a schedule.
        // For a push-based trigger, you'll need to configure a webhook in your Git provider.
        pollSCM('* * * * *')
    }

    stages {
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo 'Deploying latest changes from main branch...'
                    sh 'docker exec laravel_demo_app sh -c "git fetch origin && git pull origin main"'
                    echo 'Deployment finished.'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}