#!/bin/sh

echo "Starting initialization script..."

# Set environment
export MIX_ENV=dev
export PHX_SERVER=true

# Debug information
echo "Environment variables:"
echo "PORT: $PORT"
echo "MIX_ENV: $MIX_ENV"
echo "DATABASE_URL is set: $(if [ ! -z "$DATABASE_URL" ]; then echo "yes"; else echo "no"; fi)"

if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set"
    exit 1
fi

# Wait for database
echo "Waiting for database to be ready..."
RETRIES=30
until pg_isready -U $(echo $DATABASE_URL | awk -F[:/@] '{print $4}') \
                -h $(echo $DATABASE_URL | awk -F[:/@] '{print $6}') \
                -p $(echo $DATABASE_URL | awk -F[:/@] '{print $7}' | awk -F/ '{print $1}') \
                || [ $RETRIES -eq 0 ]; do
    echo "Waiting for postgres server, $((RETRIES)) remaining attempts..."
    RETRIES=$((RETRIES-1))
    sleep 1
done

if [ $RETRIES -eq 0 ]; then
    echo "Failed to connect to database"
    exit 1
fi

echo "Database is ready!"

# Install and compile dependencies
mix local.hex --force
mix local.rebar --force
mix deps.get
mix compile

echo "Starting Phoenix server..."
# Use exec to replace the shell with the Phoenix server process
exec mix phx.server