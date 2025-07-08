#!/bin/bash

# Backend startup script
# This script starts the backend service using Docker Compose

set -e

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

echo "Starting Memos backend development server..."

# Initialize database if it doesn't exist
if [ ! -f "./data/memos_dev.db" ]; then
    echo "Database not found. Running database initialization..."
    ./init-db.sh
fi

# Start the backend service
echo "Starting backend container..."
docker compose up backend
