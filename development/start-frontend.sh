#!/bin/bash

# Frontend startup script
# This script starts the frontend service using Docker Compose

set -e

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

echo "Starting Memos frontend development server..."

# Check if backend is running
if ! curl -s http://localhost:8081/healthz > /dev/null; then
    echo "Warning: Backend doesn't seem to be running on localhost:8081"
    echo "Make sure to start the backend first with: ./start-backend.sh"
    echo "Continuing with frontend startup..."
fi

# Start the frontend service
echo "Starting frontend container..."
docker compose up frontend
