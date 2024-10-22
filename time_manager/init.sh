#!/bin/sh

echo "Starting initialization script..."

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