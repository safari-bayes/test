// Test Jenkinsfile for Docker deployment
// This demonstrates how to use the dockerPipeline function from the shared library

@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'test-app-final',
    appPort: '50800',
    containerName: 'test-app-final',
    deployTo: 'kubernetes', // Enable Kubernetes deployment
    infisicalPath: '/afcen-landing-page/',
    deploymentMethod: 'docker-run', // Switch to standard Docker build for K8s
    healthCheckWait: '30',
    cleanupOldImages: true,
    keepImageVersions: '3',
    project: 'afcen',
    healthCheckUrl: '/health',
    technology: 'nextjs',
    
    // Security & Quality
    sonarScan: true,
    sonarProjectKey: 'test-project',
    sonarProjectName: 'Test Project (Next.js)',
    securityScan: true,
    failOnSecurity: true,  // Set to false for initial test to see all results
    trivySeverity: 'CRITICAL,HIGH',
    dockerRegistry: 'ghcr.io',
    dockerRegistryUser: 'safari-bayes',
    dockerRegistryCredentialsId: 'Token', // Jenkins credential ID for registry
    k8sNamespace: 'afcen',
    k8sDeployment: 'node-test',
    k8sAppLabel: 'node-test',
    k8sCredentialsId: 'kubeconfig' // Jenkins credential ID for kubeconfig
)

// Note: This test requires:ssnszgssasassss
// - Dockerfile.test (test Dockerfile)azasssasa
// - docker-compose.test.yml (rename to docker-compsose.ysml or use -f flag)
// - .env file (will be created from Infisical)

