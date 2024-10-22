# Build stage
FROM elixir:1.14-alpine AS builder

# Install build dependencies
RUN apk add --no-cache build-base git postgresql-client npm

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the working directory
WORKDIR /app

# Copy the mix.exs and mix.lock files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod

# Copy the rest of the application code
COPY . .

# Compile assets
RUN mix assets.deploy

# Final stage - Using elixir image instead of alpine to keep mix available
FROM elixir:1.14-alpine

# Install runtime dependencies
RUN apk add --no-cache build-base git postgresql-client npm && \
    mix local.hex --force && \
    mix local.rebar --force

# Set the working directory
WORKDIR /app

# Copy the entire app
COPY --from=builder /app ./

# Set necessary environment variables
ENV LANG=C.UTF-8
ENV PHX_SERVER=true
ENV MIX_ENV=prod

# Make init script executable
RUN chmod +x ./init.sh

# Expose the Phoenix port
EXPOSE 4000

# Start the Phoenix app using the init script
CMD ["sh", "./init.sh"]