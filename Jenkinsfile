pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Environment Check') {
            steps {
                sh 'docker --version'
                sh 'docker compose version'
            }
        }

        stage('Force Cleanup') {
            steps {
                sh 'docker rm -f tailmate-mongodb tailmate-server tailmate-client || true'
            }
        }

        stage('Stop Old Containers') {
            steps {
                sh 'docker compose down --remove-orphans'
            }
        }

        stage('Build & Start Services') {
            steps {
                sh 'docker compose up --build -d'
            }
        }

        stage('Wait for Services') {
            steps {
                sleep(time: 30, unit: 'SECONDS')
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                for i in {1..10}
                do
                  curl -f http://localhost:5000/health && break
                  echo "Waiting for backend..."
                  sleep 5
                done
                '''
                sh 'curl -f http://localhost:3000 || exit 1'
            }
        }

        stage('Show Logs') {
            steps {
                sh 'docker compose logs --tail=50'
            }
        }
    }

    post {
        failure {
            sh 'docker compose logs --tail=100'
            echo 'Build failed ❌'
        }
        success {
            echo 'Build successful ✅'
        }
    }
}