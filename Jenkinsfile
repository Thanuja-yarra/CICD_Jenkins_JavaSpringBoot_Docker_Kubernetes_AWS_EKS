pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    environment {
        APP_NAME = 'my_app'
        DOCKER_IMAGE = '07thanuja27/my_app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDENTIALS = credentials('docker-credentials')
        K8S_NAMESPACE = 'dev'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code'
                checkout scm

                sh '''
                    pwd
                    ls -la
                '''
            }
        }

        stage('Initialize') {
            steps {
                sh '''
                    java -version
                    mvn -version
                    docker --version
                    kubectl version --client
                    aws --version
                '''
            }
        }

        stage('Maven Build') {
            steps {
                echo 'Building Spring Boot application'
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image'

                sh '''
                    docker build \
                      -t ${DOCKER_IMAGE}:${BUILD_NUMBER} \
                      -t ${DOCKER_IMAGE}:latest \
                      .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "$DOCKER_CREDENTIALS_PSW" | \
                      docker login \
                      -u "$DOCKER_CREDENTIALS_USR" \
                      --password-stdin
                '''
            }
        }

        stage('Docker Push') {
            steps {
                sh '''
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker push ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply \
                      -f kubernetes/deployment.yaml \
                      -n ${K8S_NAMESPACE}
                '''
            }
        }

        stage('Update Kubernetes Image') {
            steps {
                sh '''
                    kubectl set image \
                      deployment/${APP_NAME} \
                      ${APP_NAME}=${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER} \
                      -n ${K8S_NAMESPACE}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl rollout status \
                      deployment/${APP_NAME} \
                      -n ${K8S_NAMESPACE} \
                      --timeout=180s
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
    }
}
