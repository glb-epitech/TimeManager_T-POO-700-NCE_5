#!/bin/sh

echo "Starting initialization script..."

# Parse DATABASE_URL
if [ ! -z "$DATABASE_URL" ]; then
    export DB_USER=$(echo $DATABASE_URL | awk -F[:/@] '{print $4}')
    export DB_PASS=$(echo $DATABASE_URL | awk -F[:/@] '{print $5}')
    export DB_HOST=$(echo $DATABASE_URL | awk -F[:/@] '{print $6}')
    export DB_PORT=$(echo $DATABASE_URL | awk -F[:/@] '{print $7}' | awk -F/ '{print $1}')
    export DB_NAME=$(echo $DATABASE_URL | awk -F[:/@] '{print $8}')
fi

# Wait for database
until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER; do
    echo "Waiting for postgres..."
    sleep 2
done

# Start the server
mix phx.server

#!/bin/sh

# echo "Starting initialization script..."

# # Parse DATABASE_URL if it exists
# if [ ! -z "$DATABASE_URL" ]; then
#     # Extract database connection info from DATABASE_URL
#     export DB_USER=$(echo $DATABASE_URL | awk -F[:/@] '{print $4}')
#     export DB_PASS=$(echo $DATABASE_URL | awk -F[:/@] '{print $5}')
#     export DB_HOST=$(echo $DATABASE_URL | awk -F[:/@] '{print $6}')
#     export DB_PORT=$(echo $DATABASE_URL | awk -F[:/@] '{print $7}' | awk -F/ '{print $1}')
#     export DB_NAME=$(echo $DATABASE_URL | awk -F[:/@] '{print $8}')

#     # Debug: Print extracted values (except password)
#     echo "Extracted database connection info:"
#     echo "DB_USER: $DB_USER"
#     echo "DB_HOST: $DB_HOST"
#     echo "DB_PORT: $DB_PORT"
#     echo "DB_NAME: $DB_NAME"
# fi

# # Wait for database
# echo "Waiting for database to be ready..."
# RETRIES=30
# until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER || [ $RETRIES -eq 0 ]; do
#     echo "Waiting for postgres server, $((RETRIES)) remaining attempts..."
#     RETRIES=$((RETRIES-1))
#     sleep 1
# done

# if [ $RETRIES -eq 0 ]; then
#     echo "Failed to connect to database"
#     exit 1
# fi

# echo "Database is ready!"

# # Install dependencies if needed
# mix local.hex --force
# mix local.rebar --force
# mix deps.get

# echo "Starting Phoenix server..."
# exec mix phx.server