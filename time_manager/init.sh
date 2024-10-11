#!/bin/sh

# Wait for the PostgreSQL container to be ready
while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USER; do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Run migrations
mix ecto.create
mix ecto.migrate

# Finally, start the Phoenix server
exec mix phx.server
