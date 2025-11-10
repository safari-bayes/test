# Test Directory

This directory contains test files and example Jenkinsfiles that demonstrate how to use the shared Jenkins library.

## Structure

```
test/
├── Jenkinsfile          # Example Jenkinsfile using shared library
├── README.md            # This file
└── .gitkeep            # Keep folder in git
```

## Using the Shared Library

### Example Jenkinsfile

The `Jenkinsfile` in this directory demonstrates how to use the shared library:

```groovy
@Library('shared-jenkins-library') _

samplePipeline(
    message: 'Hello from test folder!',
    environment: 'test'
)
```

## Available Pipeline Functions

### samplePipeline

A simple example pipeline function for testing.

**Usage:**
```groovy
@Library('shared-jenkins-library') _

samplePipeline(
    message: 'Custom message',
    environment: 'dev'
)
```

**Parameters:**
- `message` (optional): Custom message to display
- `environment` (optional): Environment name (default: 'dev')
- `buildNumber` (optional): Build number (default: Jenkins BUILD_NUMBER)

## Testing the Library

1. Configure the shared library in Jenkins:
   - Go to **Manage Jenkins** → **Configure System**
   - Scroll to **Global Pipeline Libraries**
   - Add library:
     - **Name**: `shared-jenkins-library`
     - **Default version**: `main`
     - **Source**: Your Git repository URL

2. Create a Jenkins job that uses this Jenkinsfile

3. Run the job to test the shared library

## Adding More Pipeline Functions

To add more pipeline functions:

1. Create a new `.groovy` file in `/home/samson-safari/bayes/shared-jenkins-library/vars/`
2. Create a corresponding `.txt` file for help documentation
3. Use the function in your Jenkinsfiles with `@Library('shared-jenkins-library') _`

## See Also

- `/home/samson-safari/bayes/shared-jenkins-library/` - The shared library directory
- `/home/samson-safari/bayes/jenkins-shared-library/` - Another shared library (global)
