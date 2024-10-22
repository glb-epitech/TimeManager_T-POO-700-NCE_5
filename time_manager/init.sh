#!/bin/sh

echo "Starting initialization script..."

# Force development environment since we're testing in dev mode
export MIX_ENV=dev
export PHX_SERVER=true

if [ ! -z "$DATABASE_URL" ]; then
    echo "Database URL is set"
else
    echo "ERROR: DATABASE_URL is not set"
    exit 1
fi

echo "PORT is set to: $PORT"

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

# Ensure dependencies are available
mix local.hex --force
mix local.rebar --force
mix deps.get

echo "Starting Phoenix server..."
elixir --erl "-detached" -S mix phx.server