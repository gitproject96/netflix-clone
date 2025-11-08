pipeline {
    agent any
    environment {
        IMAGE = "netflix-clone"
        CONTAINER = "netflix-clone-container"
        APP_VERSION = "v1.0.${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE:$APP_VERSION .'
                }
            }
        }

 stage('Stop Old Container') {
  steps {
    script {
      // Check if container exists
      def container = sh(script: "docker ps -a -q -f name=netflix-clone-container", returnStdout: true).trim()
      if (container) {
        echo "Stopping and removing existing container: ${container}"
        sh "docker stop ${container} || true"
        sh "docker rm ${container} || true"
      } else {
        echo "No existing container found."
      }
    }
  }
}
        stage('Run New Container') {
            steps {
                script {
                    sh '''
                    docker run -d --name $CONTAINER -p 5000:5000 -e APP_VERSION=$APP_VERSION $IMAGE:$APP_VERSION
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Visit http://<EC2-PUBLIC-IP>:5000"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

