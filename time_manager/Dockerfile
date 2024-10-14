# Base Elixir image
FROM elixir:1.14-alpine

# Install build dependencies
RUN apk add --no-cache build-base git postgresql-client

# Set environment variables
ENV MIX_ENV=prod

# Set the working directory to /app
WORKDIR /app

# Copy the mix.exs and mix.lock files to install dependencies
COPY mix.exs mix.lock ./
COPY config config


# Install Elixir dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy the rest of the application code
COPY . .

# Compile the application for production
RUN mix compile

# Copy the init script
COPY init.sh ./init.sh

# Expose the Phoenix port
EXPOSE 4000

# Command to run the init script
CMD ["sh", "./init.sh"]
