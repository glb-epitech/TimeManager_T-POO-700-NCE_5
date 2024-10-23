#!/bin/sh

echo "Starting initialization script..."

# Force production environment
export MIX_ENV=prod
export PHX_SERVER=true

#!/bin/sh

echo "Starting initialization script..."

# Parse DATABASE_URL and export variables
if [ ! -z "$DATABASE_URL" ]; then
    export DB_USER=$(echo $DATABASE_URL | awk -F[:/@] '{print $4}')
    export DB_PASS=$(echo $DATABASE_URL | awk -F[:/@] '{print $5}')
    export DB_HOST=$(echo $DATABASE_URL | awk -F[:/@] '{print $6}')
    export DB_PORT=$(echo $DATABASE_URL | awk -F[:/@] '{print $7}' | awk -F/ '{print $1}')
    export DB_NAME=$(echo $DATABASE_URL | awk -F[:/@] '{print $8}')

    echo "Database configuration:"
    echo "Host: $DB_HOST"
    echo "Database: $DB_NAME"
    echo "User: $DB_USER"
    echo "Port: $DB_PORT"
fi

echo "Environment: $MIX_ENV"
echo "Database URL: ${DATABASE_URL//:*@/:****@}"  # Mask the password
echo "Port: $PORT"

# Ensure hex and rebar are installed
mix local.hex --force
mix local.rebar --force
mix deps.get

echo "Setting up database..."

# Try to create the database (ignore error if it already exists)
mix ecto.create || echo "Database already exists"

echo "Running migrations..."
mix ecto.migrate

echo "Starting Phoenix server..."
mix phx.server