#!/bin/bash

# Test script for development environment setup

echo "Testing Memos development environment setup..."
echo "=============================================="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed or not in PATH"
    exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Check if required files exist
echo "Checking required files..."

required_files=(
    "docker-compose.yml"
    "backend/Dockerfile"
    "backend/entrypoint.sh"
    "frontend/Dockerfile"
    "frontend/entrypoint.sh"
    "seed/sample-data.sql"
    "README.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file is missing"
        exit 1
    fi
done

# Validate Docker Compose configuration
echo "Validating Docker Compose configuration..."
if docker-compose config > /dev/null 2>&1; then
    echo "✅ Docker Compose configuration is valid"
else
    echo "❌ Docker Compose configuration is invalid"
    docker-compose config
    exit 1
fi

# Check if backend dependencies are in place
echo "Checking backend dependencies..."
if [ -f "../go.mod" ]; then
    echo "✅ Go module file exists"
else
    echo "❌ Go module file is missing"
    exit 1
fi

# Check if frontend dependencies are in place
echo "Checking frontend dependencies..."
if [ -f "../web/package.json" ]; then
    echo "✅ Frontend package.json exists"
else
    echo "❌ Frontend package.json is missing"
    exit 1
fi

# Test database schema
echo "Testing database schema..."
if [ -f "../store/migration/sqlite/LATEST.sql" ]; then
    echo "✅ Database schema file exists"
else
    echo "❌ Database schema file is missing"
    exit 1
fi

# Test database initialization (without starting full stack)
echo "Testing database initialization..."
if docker run --rm -v "$(pwd)/data:/data" -v "$(pwd)/seed:/seed" -v "$(pwd)/../store/migration/sqlite:/schema" alpine:latest sh -c "
    apk add --no-cache sqlite
    rm -f /data/memos_dev.db
    sqlite3 /data/memos_dev.db < /schema/LATEST.sql
    sqlite3 /data/memos_dev.db < /seed/sample-data.sql
    echo 'Testing database content...'
    sqlite3 /data/memos_dev.db 'SELECT COUNT(*) FROM user;'
    sqlite3 /data/memos_dev.db 'SELECT COUNT(*) FROM memo;'
"; then
    echo "✅ Database initialization works correctly"
else
    echo "❌ Database initialization failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The development environment is ready."
echo ""
echo "To start the development environment:"
echo "  docker-compose up"
echo ""
echo "To access the application:"
echo "  Frontend: http://localhost:3000"
echo "  Backend:  http://localhost:8081"
echo ""
echo "To stop the environment:"
echo "  docker-compose down"