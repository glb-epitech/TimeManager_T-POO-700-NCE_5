#!/bin/sh

echo "Starting initialization script..."

# Set environment explicitly
export MIX_ENV=prod  # Change this to 'dev' if you want to use dev.exs
echo "Running in environment: $MIX_ENV"

echo "Port configuration:"
echo "PORT: $PORT"
echo "DATABASE_URL: ${DATABASE_URL//:*@/:****@}"  # Print URL with password masked

# Install dependencies
mix local.hex --force
mix local.rebar --force
mix deps.get

# Start the server
echo "Starting Phoenix server..."
mix phx.server