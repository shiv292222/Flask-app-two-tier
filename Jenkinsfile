pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flaskapp'
        REPO_URL = 'https://github.com/LondheShubham153/two-tier-flask-app.git'
        BRANCH = 'jenkins'
        DOCKERHUB_REPO = 'flaskapp:latest'
    }

    stages {
        stage('Setup Environment') {
            steps {
                cleanWs() // Clean the workspace before starting the job
                echo 'Starting a new build and deploy process.'
            }
        }
        
        stage('Clone Repository') {
            steps {
                git url: "${REPO_URL}", branch: "${BRANCH}"
                echo 'Repository successfully cloned.'
            }
        }

        stage('Build & Test') {
            steps {
                script {
                    try {
                        sh 'docker build . -t ${IMAGE_NAME}'
                        echo 'Docker image built successfully.'
                    } catch (Exception e) {
                        echo "Error during build: ${e.message}"
                        error "Stopping the build due to build failure."
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    script {
                        try {
                            sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                            sh "docker tag ${IMAGE_NAME} ${env.dockerHubUser}/${DOCKERHUB_REPO}"
                            sh "docker push ${env.dockerHubUser}/${DOCKERHUB_REPO}"
                            echo 'Docker image pushed to Docker Hub successfully.'
                        } catch (Exception e) {
                            echo "Error during Docker Hub operations: ${e.message}"
                            error "Stopping the build due to Docker Hub failure."
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    try {
                        sh 'docker-compose down'
                        sh 'docker-compose up -d'
                        echo 'Deployment successful.'
                    } catch (Exception e) {
                        echo "Error during deployment: ${e.message}"
                        error "Deployment failed."
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs() // Clean the workspace after the pipeline execution
        }
        success {
            echo 'Build and deployment process completed successfully.'
        }
        failure {
            echo 'Build or deployment process failed.'
        }
    }
}
