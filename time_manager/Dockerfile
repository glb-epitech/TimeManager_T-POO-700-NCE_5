# Build stage
FROM elixir:1.14-alpine AS builder

# Install build dependencies
RUN apk add --no-cache build-base git postgresql-client

# Set environment variabless
ENV MIX_ENV=prod

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the working directory to /app
WORKDIR /app

# Copy the mix.exs and mix.lock files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod

# Copy the rest of the application code
COPY . .

# Compile assets
RUN mix assets.deploy

# Compile the application
RUN mix compile

# Build release
RUN mix release

# Final stage
FROM alpine:3.14

# Install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs libstdc++ postgresql-client

WORKDIR /app

# Copy the release from the builder stage
COPY --from=builder /app/_build/prod/rel/time_manager ./

# Copy the init script
COPY init.sh ./init.sh

# Set necessary environment variables
ENV LANG=C.UTF-8
ENV PHX_SERVER=true

# Expose the Phoenix port
EXPOSE 4000

# Start the Phoenix app using the init script
CMD ["sh", "./init.sh"]