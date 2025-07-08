#!/bin/sh

# Wait for dependencies if needed
echo "Starting Memos frontend in development mode..."

# Install dependencies if they don't exist
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  pnpm install --frozen-lockfile
fi

# Start dev server
exec pnpm dev --host 0.0.0.0