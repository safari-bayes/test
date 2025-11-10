# Test Directory

This directory contains test files and example Jenkinsfiles that demonstrate how to use the shared Jenkins library.

## Structure

```
test/
├── Jenkinsfile              # Sample pipeline using shared library
├── Jenkinsfile.docker-test  # Docker deployment test
├── docker-compose.test.yml  # Test docker-compose file
├── Dockerfile.test          # Test Dockerfile
├── verify-setup.sh          # Setup verification script
└── README.md                # This file
```

## Using the Shared Library

### Example 1: Sample Pipeline

The `Jenkinsfile` demonstrates basic usage:

```groovy
@Library('shared-jenkins-library') _

samplePipeline(
    message: 'Hello from test folder!',
    environment: 'test'
)
```

### Example 2: Docker Deployment Test

The `Jenkinsfile.docker-test` demonstrates Docker deployment:

```groovy
@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'test-app',
    appPort: '8080',
    infisicalPath: '/test-app/',
    healthCheckUrl: '/health'
)
```

## Docker Deployment Test

To test Docker deployment:

1. **Ensure you have:**
   - `Dockerfile.test` - Test Dockerfile
   - `docker-compose.test.yml` - Test docker-compose file
   - `.env` file (will be created from Infisical)

2. **Configure Jenkins job:**
   - Use `Jenkinsfile.docker-test` as the pipeline script
   - Ensure the shared library is configured in Jenkins

3. **Run the job:**
   - Jenkins will build the test Docker image
   - Deploy using docker-compose
   - Run health checks
   - Clean up old images

## Test Application

The test application (`Dockerfile.test`) is a simple Python HTTP server that:
- Runs on port 8080
- Provides a `/health` endpoint
- Returns "OK" for health checks
- Displays "Test App Running" on the root path

## Available Pipeline Functions

### dockerPipeline

Universal Docker deployment pipeline for all bayes applications.

**Usage:**
```groovy
@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'my-app',
    appPort: '8080',
    infisicalPath: '/my-app/',
    healthCheckUrl: '/health'
)
```

**Key Features:**
- ✅ Infisical secret injection
- ✅ Docker image building
- ✅ Docker Compose or Docker Run deployment
- ✅ Health checks
- ✅ Image cleanup

### samplePipeline

A sample pipeline function for testing.

**Usage:**
```groovy
@Library('shared-jenkins-library') _

samplePipeline(
    message: 'Custom message',
    environment: 'dev'
)
```

## Verification

Run the verification script to check your setup:

```bash
./verify-setup.sh
```

This will verify:
- Shared library repository structure
- Test repository structure
- Required files exist
- Configuration checklist

## See Also

- `/home/samson-safari/bayes/shared-jenkins-library/` - The shared library directory
- `/home/samson-safari/bayes/jenkins-shared-library/` - Another shared library (global)
