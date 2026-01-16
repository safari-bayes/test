pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'ghcr.io'
        DOCKER_USERNAME = 'sam'
        DOCKER_IMAGE = 'node-app'
        K8S_NAMESPACE = 'default'
        DEPLOYMENT_NAME = 'node-test'
        APP_LABEL = 'node-test'
        DOCKER_TAG = "${env.BUILD_NUMBER ?: 'latest'}"
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Node.js application...'
                sh '''
                if [ -f package.json ]; then
                    echo "Node.js app detected - installing dependencies"
                    npm install
                    echo "Dependencies installed successfully"
                else
                    echo "No package.json found - skipping npm install"
                fi
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:latest"
                echo "Docker image built successfully: ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing Docker image to registry...'
                withCredentials([usernamePassword(credentialsId: 'safari-bayes', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                    echo "\$DOCKER_PASSWORD" | docker login \$DOCKER_REGISTRY -u "\$DOCKER_USERNAME" --password-stdin
                    echo "Docker login successful"
                    docker push \${DOCKER_REGISTRY}/\${DOCKER_USERNAME}/\${DOCKER_IMAGE}:\${DOCKER_TAG}
                    docker push \${DOCKER_REGISTRY}/\${DOCKER_USERNAME}/\${DOCKER_IMAGE}:latest
                    echo "Docker images pushed successfully"
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes cluster...'
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh """
                    echo "Applying Kubernetes manifests..."
                    kubectl apply -f node-deployment.yaml --namespace=${K8S_NAMESPACE}
                    kubectl apply -f node-service.yaml --namespace=${K8S_NAMESPACE}

                    echo "Updating deployment image..."
                    kubectl set image deployment/${DEPLOYMENT_NAME} ${DEPLOYMENT_NAME}=${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG} --namespace=${K8S_NAMESPACE}

                    echo "Waiting for rollout to complete..."
                    kubectl rollout status deployment/${DEPLOYMENT_NAME} --namespace=${K8S_NAMESPACE} --timeout=300s
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                withCredentials([file(credentialsId: 'jenkins-kubeconfig.yaml', variable: 'KUBECONFIG')]) {
                    sh """
                    echo "Checking pod status..."
                    kubectl get pods --namespace=${K8S_NAMESPACE} -l app=${APP_LABEL}

                    echo "Checking service status..."
                    kubectl get svc --namespace=${K8S_NAMESPACE} -l app=${APP_LABEL}

                    echo "Testing service endpoint..."
                    kubectl get svc node-test-service --namespace=${K8S_NAMESPACE} -o jsonpath='{.spec.ports[0].nodePort}'
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Cleaning up local Docker images...'
                sh """
                docker rmi ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG} || true
                docker rmi ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:latest || true
                echo "Cleanup completed"
                """
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline completed successfully!'
            echo "Application deployed to: ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}"
            echo "Service available on NodePort: Check kubectl get svc node-test-service"
        }
        failure {
            echo '❌ Pipeline failed!'
            script {
                echo "Checking cluster status for debugging..."
                try {
                    withCredentials([file(credentialsId: 'jenkins-kubeconfig.yaml', variable: 'KUBECONFIG')]) {
                        sh """
                        kubectl get pods --namespace=${K8S_NAMESPACE} -l app=${APP_LABEL} || true
                        kubectl describe deployment ${DEPLOYMENT_NAME} --namespace=${K8S_NAMESPACE} || true
                        """
                    }
                } catch (Exception e) {
                    echo "Could not retrieve cluster status: ${e.getMessage()}"
                }
            }
        }
        always {
            echo 'Pipeline execution completed.'
            sh 'docker system prune -f || true'
        }
    }
}