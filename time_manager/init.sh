#!/bin/sh

# Print environment variables for debugging (be careful not to print sensitive data)
echo "Environment variables:"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_USER: $DB_USER"
echo "PORT: $PORT"

# Check if SECRET_KEY_BASE is set
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "ERROR: SECRET_KEY_BASE is not set. Please set it in Heroku config vars."
  exit 1
fi

# Check if PORT is set
if [ -z "$PORT" ]; then
  echo "ERROR: PORT is not set. Using default port 4000."
  export PORT=4000
fi

# Set a timeout for database connection attempts (e.g., 5 minutes)
TIMEOUT=300
ELAPSED=0

echo "Waiting for database to be ready..."
while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USER
do
  echo "$(date) - still waiting for database to start"
  sleep 2
  ELAPSED=$((ELAPSED+2))
  if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "Timeout reached. Database is not ready."
    exit 1
  fi
done
echo "Database is ready!"

echo "Creating database..."
mix ecto.create || { echo "Failed to create database"; exit 1; }

echo "Running migrations..."
mix ecto.migrate || { echo "Failed to run migrations"; exit 1; }

echo "Starting Phoenix server on port $PORT..."
exec mix phx.server