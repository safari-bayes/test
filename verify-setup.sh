#!/bin/bash
# Verification script for shared library setup

echo "=========================================="
echo "Verifying Shared Library Setup"
echo "=========================================="

echo ""
echo "1. Checking shared-jenkins-library repository..."
cd /home/samson-safari/bayes/shared-jenkins-library
echo "   Repository: $(git remote get-url origin)"
echo "   Branch: $(git branch --show-current)"
echo "   Latest commit: $(git log -1 --oneline)"

echo ""
echo "2. Checking required files..."
if [ -f "vars/samplePipeline.groovy" ]; then
    echo "   ✅ vars/samplePipeline.groovy exists"
else
    echo "   ❌ vars/samplePipeline.groovy NOT FOUND"
fi

if [ -f "vars/samplePipeline.txt" ]; then
    echo "   ✅ vars/samplePipeline.txt exists"
else
    echo "   ❌ vars/samplePipeline.txt NOT FOUND"
fi

echo ""
echo "3. Checking test repository..."
cd /home/samson-safari/bayes/test
echo "   Repository: $(git remote get-url origin)"
echo "   Branch: $(git branch --show-current)"
echo "   Latest commit: $(git log -1 --oneline)"

if [ -f "Jenkinsfile" ]; then
    echo "   ✅ Jenkinsfile exists"
    echo ""
    echo "   Jenkinsfile content:"
    echo "   --------------------"
    grep "@Library" Jenkinsfile
    grep "samplePipeline" Jenkinsfile
else
    echo "   ❌ Jenkinsfile NOT FOUND"
fi

echo ""
echo "=========================================="
echo "Configuration Checklist:"
echo "=========================================="
echo ""
echo "In Jenkins, ensure:"
echo "  [ ] Global Pipeline Library configured"
echo "  [ ] Library name: 'shared-jenkins-library'"
echo "  [ ] Repository URL: https://github.com/safari-bayes/shared-jenkins-library.git"
echo "  [ ] Default version: 'main'"
echo "  [ ] Branch: '*/main' or 'refs/heads/main'"
echo ""
echo "To configure:"
echo "  Jenkins → Manage Jenkins → Configure System"
echo "  → Global Pipeline Libraries → Add"
echo "=========================================="

