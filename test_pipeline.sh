#!/bin/bash
# Comprehensive Pipeline Test Script
# Tests the dockerPipeline function from the shared library

# Don't exit on error, we want to count failures
set +e

echo "=========================================="
echo "Testing dockerPipeline Pipeline"
echo "=========================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "\n${YELLOW}Testing: ${test_name}${NC}"
    if eval "$test_command"; then
        echo -e "${GREEN}✓ PASSED: ${test_name}${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAILED: ${test_name}${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Test 1: Check if Jenkinsfile exists
run_test "Jenkinsfile exists" "test -f Jenkinsfile"

# Test 2: Check if Dockerfile exists
run_test "Dockerfile exists" "test -f Dockerfile || test -f Dockerfile.test"

# Test 3: Check if docker-compose.yml exists
run_test "docker-compose.yml exists" "test -f docker-compose.yml"

# Test 4: Validate Jenkinsfile syntax (basic check)
run_test "Jenkinsfile has @Library directive" "grep -q '@Library' Jenkinsfile"

# Test 5: Validate Jenkinsfile calls dockerPipeline
run_test "Jenkinsfile calls dockerPipeline" "grep -q 'dockerPipeline' Jenkinsfile"

# Test 6: Check required parameters in Jenkinsfile
run_test "dockerImage parameter present" "grep -q 'dockerImage' Jenkinsfile"
run_test "appPort parameter present" "grep -q 'appPort' Jenkinsfile"

# Test 7: Validate Dockerfile syntax (basic)
if [ -f "Dockerfile" ]; then
    run_test "Dockerfile has FROM directive" "grep -q '^FROM' Dockerfile"
    run_test "Dockerfile has EXPOSE directive" "grep -q '^EXPOSE' Dockerfile || grep -q 'EXPOSE' Dockerfile"
fi

# Test 8: Validate docker-compose.yml syntax
run_test "docker-compose.yml has services section" "grep -q 'services:' docker-compose.yml"

# Test 9: Check shared library syntax
echo -e "\n${YELLOW}Testing shared library syntax...${NC}"
cd ../shared-jenkins-library
if groovyc -cp /dev/null vars/dockerPipeline.groovy 2>&1 | grep -q "error"; then
    echo -e "${RED}✗ FAILED: dockerPipeline.groovy has syntax errors${NC}"
    groovyc -cp /dev/null vars/dockerPipeline.groovy 2>&1
    ((TESTS_FAILED++))
else
    echo -e "${GREEN}✓ PASSED: dockerPipeline.groovy syntax is valid${NC}"
    ((TESTS_PASSED++))
fi
cd ../test

# Test 10: Check if Docker is available (if running in environment with Docker)
if command -v docker &> /dev/null; then
    run_test "Docker is available" "docker --version"
else
    echo -e "${YELLOW}⚠ SKIPPED: Docker not available (this is OK for syntax testing)${NC}"
fi

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "${GREEN}Passed: ${TESTS_PASSED}${NC}"
echo -e "${RED}Failed: ${TESTS_FAILED}${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Ensure Jenkins is configured with the shared library"
    echo "2. Create a Pipeline job pointing to this Jenkinsfile"
    echo "3. Configure required Jenkins credentials (Infisical)"
    echo "4. Run the pipeline in Jenkins"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please fix the issues above.${NC}"
    exit 1
fi

