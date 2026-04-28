// pipeline {
//     agent any

//     stages {

//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }

//         stage('Stop Old Containers') {
//     steps {
//         bat 'docker compose down --remove-orphans'
//     }
// }

//         stage('Build & Start') {
//             steps {
//                 bat 'docker compose up --build -d'
//             }
//         }

//         stage('Wait') {
//             steps {
//                 sleep(time: 20, unit: 'SECONDS')
//             }
//         }

//         stage('Health Check') {
//             steps {
//                 bat 'docker compose ps'
//                 bat 'curl -f http://localhost:5000/health || exit 1'
//                 bat 'curl -f http://localhost:3000 || exit 1'
//             }
//         }

//         stage('Logs') {
//             steps {
//                 bat 'docker compose logs --tail=20'
//             }
//         }
//     }
// }
// // pipeline {
// //     agent any
// //     stages {
// //         stage('Test Stage') {
// //             steps {
// //                 echo 'Pipeline is working'
// //             }
// //         }
// //     }
// // }




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
                sleep(time: 20, unit: 'SECONDS')
            }
        }

        stage('Health Check') {
            steps {
                sh 'docker compose ps'
                sh 'curl -f http://localhost:5000/health || exit 1'
                sh 'curl -f http://localhost:3000 || exit 1'
            }
        }

        stage('Show Logs') {
            steps {
                sh 'docker compose logs --tail=20'
            }
        }
    }

    post {
        failure {
            echo 'Build failed ❌'
        }
        success {
            echo 'Build successful ✅'
        }
    }
}