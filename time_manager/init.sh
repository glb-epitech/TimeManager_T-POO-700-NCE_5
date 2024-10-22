#!/bin/sh

echo "Starting initialization script..."

# Force production environment
export MIX_ENV=prod
export PHX_SERVER=true

echo "Environment: $MIX_ENV"
echo "Database URL: ${DATABASE_URL//:*@/:****@}"  # Mask the password
echo "Port: $PORT"

# Ensure hex and rebar are installed
mix local.hex --force
mix local.rebar --force
mix deps.get

# Start the server
echo "Starting Phoenix server..."
mix phx.server