pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub'
        IMAGE_NAME = 'mydocker691/netflix-app'
        APP_VERSION = "v1.0.${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/gitproject96/netflix-clone.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🚀 Building Docker Image: $IMAGE_NAME:$BUILD_NUMBER"
                    sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker push $IMAGE_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                    sed -i "s|mydocker691/netflix-app:.*|$IMAGE_NAME:$BUILD_NUMBER|g" k8s/k8s-deployment.yaml
                    kubectl --kubeconfig=$KUBECONFIG apply -f k8s/k8s-deployment.yaml
                    kubectl --kubeconfig=$KUBECONFIG rollout status deployment/netflix-app
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful on Kubernetes!"
        }
        failure {
            echo "❌ Deployment failed. Check logs!"
        }
    }
}
