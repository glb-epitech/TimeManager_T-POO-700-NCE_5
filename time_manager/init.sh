#!/bin/sh

echo "Starting initialization script..."

# Parse DATABASE_URL if it exists
if [ ! -z "$DATABASE_URL" ]; then
    # Extract database connection info from DATABASE_URL
    DB_USER=$(echo $DATABASE_URL | awk -F[:/@] '{print $4}')
    DB_PASS=$(echo $DATABASE_URL | awk -F[:/@] '{print $5}')
    DB_HOST=$(echo $DATABASE_URL | awk -F[:/@] '{print $6}')
    DB_PORT=$(echo $DATABASE_URL | awk -F[:/@] '{print $7}' | awk -F/ '{print $1}')
    DB_NAME=$(echo $DATABASE_URL | awk -F[:/@] '{print $8}')

    # Export these variables so they're available to the Phoenix app
    export DB_USER
    export DB_PASS
    export DB_HOST
    export DB_PORT
    export DB_NAME
fi

# Debug: Print all database-related environment variables
echo "Database connection info:"
echo "DATABASE_URL: $DATABASE_URL"
echo "DB_USER: $DB_USER"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_NAME: $DB_NAME"

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

# Installing hex if not present
mix local.hex --force
mix local.rebar --force

echo "Setting up database..."
mix ecto.create
mix ecto.migrate

echo "Starting Phoenix server..."
mix phx.server