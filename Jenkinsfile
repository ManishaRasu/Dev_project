pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Stop Old Containers') {
            steps {
                bat 'docker compose down'
            }
        }

        stage('Build & Start') {
            steps {
                bat 'docker compose up --build -d'
            }
        }

        stage('Wait') {
            steps {
                sleep(time: 20, unit: 'SECONDS')
            }
        }

        stage('Health Check') {
            steps {
                bat 'docker compose ps'
                bat 'curl -f http://localhost:5000/health || exit 1'
                bat 'curl -f http://localhost:3000 || exit 1'
            }
        }

        stage('Logs') {
            steps {
                bat 'docker compose logs --tail=20'
            }
        }
    }
}