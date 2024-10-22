echo "init.sh"

# Ensure Hex is installed
mix local.hex --force
mix local.rebar --force

# Debug port information
echo "Port configuration:"
echo "PORT: $PORT"


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

# Install dependencies
mix deps.get

echo "Starting Phoenix server on port $PORT..."
mix phx.server