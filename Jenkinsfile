pipeline {
    agent { label 'docker' }
    
    environment {
        COMPOSE_PROJECT_NAME = "tailmate"
        REGISTRY = ""
        IMAGE_TAG = "${BUILD_NUMBER}"
        TIMESTAMP = bat(script: '@echo off && for /f "tokens=2 delims==" %%i in (\'wmic os get localdatetime /value\') do set datetime=%%i && echo %datetime:~0,8%_%datetime:~8,6%', returnStdout: true).trim()
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 60, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Environment Check') {
            steps {
                script {
                    bat 'docker --version'
                    bat 'docker-compose --version'
                    bat 'node --version'
                    bat 'npm --version'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    bat 'docker-compose build'
                }
            }
        }

        stage('Cleanup') {
    steps {
        script {
            bat 'docker rm -f tailmate-mongodb tailmate-server tailmate-client || true'
            bat 'docker-compose down --volumes --remove-orphans || true'
            bat 'docker system prune -f || true'
        }
    }
}
stage('Start Services') {
    steps {
        script {
            bat 'docker-compose up -d'
            sleep(time: 30, unit: 'SECONDS')
        }
    }
}

        stage('Health Checks') {
            steps {
                script {
                    bat 'docker-compose ps'
                    bat 'curl -f http://localhost:5000//health || exit 1'
                    bat 'curl -f http://localhost:3000 || exit 1'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Tests skipped (configure when ready)"
                }
            }
        }

        stage('Service Status') {
            steps {
                script {
                    bat 'docker-compose ps'
                    bat 'docker-compose logs --tail=20'
                }
            }
        }
    }
}