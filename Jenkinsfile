// Test Jenkinsfile that uses dockerPipeline from the shared library
// This demonstrates Docker deployment using the shared library

@Library('shared-jenkins-library') _
//ss
dockerPipeline(
    dockerImage: 'test-image',
    appPort: '3000',
    project: 'kplc',                    // Exact match → correct agent
    healthCheckUrl: '/health'

)