#!/bin/bash

# Database initialization script
# This script initializes the SQLite database with schema and sample data directly

set -e

SCRIPT_DIR="$(dirname "$0")"
DATA_DIR="$SCRIPT_DIR/data"
SEED_DIR="$SCRIPT_DIR/seed"
SCHEMA_DIR="$SCRIPT_DIR/../store/migration/sqlite"
DB_FILE="$DATA_DIR/memos_dev.db"

echo "Initializing database..."

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

# Check if database already exists
if [ -f "$DB_FILE" ]; then
    echo "Database already exists at $DB_FILE, skipping initialization."
    exit 0
fi

# Check if schema file exists
if [ ! -f "$SCHEMA_DIR/LATEST.sql" ]; then
    echo "Error: Schema file not found at $SCHEMA_DIR/LATEST.sql"
    exit 1
fi

# Check if sample data file exists
if [ ! -f "$SEED_DIR/sample-data.sql" ]; then
    echo "Error: Sample data file not found at $SEED_DIR/sample-data.sql"
    exit 1
fi

# Check if sqlite3 is available
if ! command -v sqlite3 &> /dev/null; then
    echo "Error: sqlite3 is not installed. Please install SQLite3."
    exit 1
fi

echo "Creating database with schema using SQLite directly..."
sqlite3 "$DB_FILE" < "$SCHEMA_DIR/LATEST.sql"
sqlite3 "$DB_FILE" < "$SEED_DIR/sample-data.sql"
echo "Database initialization completed successfully!"

echo "Database created at: $DB_FILE"