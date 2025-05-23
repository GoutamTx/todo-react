pipeline {
    agent any

    environment {
        IMAGE_NAME = 'react-todo'
        DOCKER_REGISTRY = 'goutam24'
        PORT = '80'
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install --legacy-peer-deps'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_REGISTRY/$IMAGE_NAME .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh 'docker push $DOCKER_REGISTRY/$IMAGE_NAME'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker stop react-todo-container || true
                    docker rm react-todo-container || true
                    docker run -d --name react-todo-container -p 80:80 $DOCKER_REGISTRY/$IMAGE_NAME
                '''
            }
        }
    }
}
