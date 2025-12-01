# Testing Guide for Shared Jenkins Library

## Prerequisites

1. **Jenkins Server** with the shared library configured
2. **Shared Library** must be registered in Jenkins (Global Pipeline Libraries)
3. **Docker** installed on Jenkins agents
4. **Required Jenkins Credentials**:
   - `infisical-client-id`
   - `infisical-client-secret`
   - `infisical-api-url`
   - `infisical-project-id`

## Testing Steps

### Step 1: Test Library Connection (Recommended First)

Test that the shared library is properly configured using the simple `samplePipeline`:

```groovy
@Library('shared-jenkins-library') _

samplePipeline(
    message: 'Testing shared library connection',
    environment: 'dev'
)
```

**How to run:**
1. Create a new Jenkins Pipeline job
2. Point it to `test/Jenkinsfile.sample-test`
3. Run the job
4. Verify it completes successfully

### Step 2: Test dockerPipeline

Once the library connection is verified, test the `dockerPipeline`:

**Option A: Using existing test/Jenkinsfile**

```groovy
@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'test-image',
    appPort: '3000',
    project: 'kplc',
    healthCheckUrl: '/health'
)
```

**Option B: Minimal test (no health check)**

```groovy
@Library('shared-jenkins-library') _

dockerPipeline(
    dockerImage: 'test-image',
    appPort: '3000'
)
```

**How to run:**
1. Create a new Jenkins Pipeline job
2. Point it to `test/Jenkinsfile`
3. Ensure you have:
   - A `Dockerfile` in the test directory
   - A `docker-compose.yml` (optional, defaults to docker-compose method)
   - Required credentials configured
4. Run the job

## Required Files for dockerPipeline Test

Your test directory should have:

1. **Dockerfile** - To build the Docker image
2. **docker-compose.yml** (optional) - If using docker-compose deployment method
3. **Jenkinsfile** - The pipeline definition

## Testing in Jenkins UI

1. **Go to Jenkins Dashboard**
2. **New Item** → **Pipeline**
3. **Pipeline Definition**:
   - Select "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: Your repository URL
   - Script Path: `test/Jenkinsfile` (or `test/Jenkinsfile.sample-test`)
4. **Save** and **Build Now**

## Testing via Jenkins CLI

```bash
# If you have Jenkins CLI access
java -jar jenkins-cli.jar -s http://jenkins-url build test-job
```

## Common Issues

### Issue: Library not found
**Solution**: Ensure the shared library is configured in:
- Jenkins → Manage Jenkins → Configure System → Global Pipeline Libraries
- Library name must match: `shared-jenkins-library`

### Issue: Credentials not found
**Solution**: Create the required credentials in:
- Jenkins → Credentials → System → Global credentials

### Issue: Docker not available
**Solution**: Ensure Docker is installed on the Jenkins agent and the Jenkins user has permission to run Docker commands.

### Issue: Agent selection fails
**Solution**: Set the `DEPLOYMENT_MAPPING` environment variable in Jenkins, or the pipeline will default to `'any'` agent.

## Environment Variables (Optional)

You can set these in Jenkins to customize behavior:

- `DEPLOYMENT_MAPPING`: JSON mapping for agent selection
  ```json
  {
    "kplc": {
      "dev": "agent-label-1",
      "prod": "agent-label-2"
    },
    "default": {
      "dev": "any"
    }
  }
  ```

## Verification Checklist

- [ ] Library loads without errors
- [ ] Pipeline stages execute in order
- [ ] Docker image builds successfully
- [ ] Container deploys (if testing full pipeline)
- [ ] Health check passes (if configured)
- [ ] Cleanup runs successfully

