#!/bin/sh

# Wait for dependencies if needed
echo "Starting Memos backend in development mode..."

# Run go directly
exec go run ./bin/memos/main.go --mode dev --port 8081