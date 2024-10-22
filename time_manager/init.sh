#!/bin/sh

echo "Starting initialization script..."

# Parse DATABASE_URL if it exists
if [ ! -z "$DATABASE_URL" ]; then
  # Extract database connection info from DATABASE_URL
  # Format: postgres://user:password@host:port/dbname
  DB_USER=$(echo $DATABASE_URL | awk -F[:/@] '{print $4}')
  DB_PASS=$(echo $DATABASE_URL | awk -F[:/@] '{print $5}')
  DB_HOST=$(echo $DATABASE_URL | awk -F[:/@] '{print $6}')
  DB_PORT=$(echo $DATABASE_URL | awk -F[:/@] '{print $7}' | awk -F/ '{print $1}')
  DB_NAME=$(echo $DATABASE_URL | awk -F[:/@] '{print $8}')
fi

# Print non-sensitive connection info for debugging
echo "Database connection info:"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"

# Check required environment variables
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "ERROR: SECRET_KEY_BASE is not set"
  exit 1
fi

if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL is not set"
  exit 1
fi

# Wait for database to be ready
echo "Waiting for database to be ready..."
RETRIES=30
until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER || [ $RETRIES -eq 0 ]; do
  echo "Waiting for postgres server, $((RETRIES)) remaining attempts..."
  RETRIES=$((RETRIES-1))
  sleep 1
done

if [ $RETRIES -eq 0 ]; then
  echo "Failed to connect to database"
  exit 1
fi

echo "Database is ready!"

# Create and migrate database
echo "Setting up database..."
mix phx.digest
mix local.hex --force
mix ecto.create
mix ecto.migrate

echo "Starting Phoenix server..."
exec mix phx.server