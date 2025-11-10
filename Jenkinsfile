// Test Jenkinsfile that uses dockerPipeline from the shared library
// This demonstrates Docker deployment using the shared library

@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'test-app',
    appPort: '8080',
    containerName: 'test-app',
    infisicalPath: '/test-app/',
    deploymentMethod: 'docker-compose',
    infisicalMethod: 'export',
    healthCheckUrl: '/health',
    healthCheckWait: '30',
    cleanupOldImages: true,
    keepImageVersions: '3'
)
