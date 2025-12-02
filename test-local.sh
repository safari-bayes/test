#!/bin/bash

set -e

echo "=== Testing Test App Locally ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Cleanup function
cleanup() {
    echo ""
    echo "Cleaning up..."
    docker-compose down 2>/dev/null || true
    docker rm -f test-app 2>/dev/null || true
}

trap cleanup EXIT

echo "1. Creating minimal .env file if it doesn't exist..."
if [ ! -f .env ]; then
    echo "# Minimal .env for local testing" > .env
    echo "API_PORT=8080" >> .env
    echo "Created .env file for local testing"
fi

echo ""
echo "2. Building Docker image..."
docker-compose build

echo ""
echo "3. Starting container..."
docker-compose up -d

echo ""
echo "4. Waiting for container to be ready..."
sleep 5

echo ""
echo "5. Checking container status..."
if docker ps | grep -q test-app; then
    echo -e "${GREEN}✓ Container is running${NC}"
else
    echo -e "${RED}✗ Container is not running${NC}"
    docker-compose logs
    exit 1
fi

echo ""
echo "6. Checking container health status..."
HEALTH=$(docker inspect --format='{{.State.Health.Status}}' test-app 2>/dev/null || echo "none")
echo "Health status: $HEALTH"

echo ""
echo "7. Testing /health endpoint from host..."
for i in {1..10}; do
    if curl -sf http://localhost:8080/health >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Health endpoint is responding${NC}"
        RESPONSE=$(curl -s http://localhost:8080/health)
        echo "Response: $RESPONSE"
        break
    else
        if [ $i -eq 10 ]; then
            echo -e "${RED}✗ Health endpoint not responding after 10 attempts${NC}"
            echo "Container logs:"
            docker-compose logs --tail 20
            exit 1
        fi
        echo "Waiting for health endpoint... (attempt $i/10)"
        sleep 2
    fi
done

echo ""
echo "8. Testing /health endpoint from inside container..."
if docker exec test-app curl -sf http://localhost:8080/health >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Health endpoint works from inside container${NC}"
    RESPONSE=$(docker exec test-app curl -s http://localhost:8080/health)
    echo "Response: $RESPONSE"
else
    echo -e "${RED}✗ Health endpoint not working from inside container${NC}"
    exit 1
fi

echo ""
echo "9. Testing root endpoint..."
if curl -sf http://localhost:8080/ >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Root endpoint is responding${NC}"
    RESPONSE=$(curl -s http://localhost:8080/ | head -1)
    echo "Response: $RESPONSE"
else
    echo -e "${RED}✗ Root endpoint not responding${NC}"
    exit 1
fi

echo ""
echo "10. Checking container logs..."
echo "--- Container Logs (last 10 lines) ---"
docker-compose logs --tail 10

echo ""
echo -e "${GREEN}=== All tests passed! ===${NC}"
echo ""
echo "Container is running at: http://localhost:8080"
echo "Health endpoint: http://localhost:8080/health"
echo ""
echo "To stop the container, run: docker-compose down"

