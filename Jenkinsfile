// Test Jenkinsfile for Docker deployment
// This demonstrates how to use the dockerPipeline function from the shared library

@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'test-app',
    appPort: '8080',
    containerName: 'test-app',
    infisicalPath: '/kplc-web-application/',
    deploymentMethod: 'docker-compose',
    healthCheckWait: '30',
    cleanupOldImages: true,
    keepImageVersions: '3',
    project: 'afcen',
    healthCheckUrl: '/health'
)

// Note: This test requires:ssnszgss
// - Dockerfile.test (test Dockerfile)az
// - docker-compose.test.yml (rename to docker-compose.yml or use -f flag)
// - .env file (will be created from Infisical)

