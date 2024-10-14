# Build stage
FROM elixir:1.14-alpine AS builder

# Install build dependencies
RUN apk add --no-cache build-base git postgresql-client

# Set environment variables
ENV MIX_ENV=prod

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the working directory to /app
WORKDIR /app

# Copy the entire project
COPY . .

# Install dependencies
RUN mix deps.get
RUN mix deps.compile

# Compile assets if using Phoenix
RUN mix assets.deploy

# Compile the application
RUN mix compile

# Build release
RUN mix release

# Final stage
FROM alpine:3.14

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

# Copy the release from the builder stage
COPY --from=builder /app/_build/prod/rel/time_manager ./

# Expose the Phoenix port
EXPOSE 4000

# Set the entrypoint to the Phoenix app
CMD ["bin/time_manager", "start"]