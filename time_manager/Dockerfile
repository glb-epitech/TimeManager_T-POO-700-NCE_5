# Build stage
FROM elixir:1.14-alpine AS builder

# Install build dependencies
RUN apk add --no-cache build-base git postgresql-client npm

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set environment variables
ENV MIX_ENV=prod

# Set the working directory
WORKDIR /app

# Copy mix files first
COPY mix.exs mix.lock ./

# Install and compile dependencies
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy the rest of the application code
COPY . .

# Compile the project
RUN mix do compile

# Final stage
FROM elixir:1.14-alpine

# Install runtime dependencies
RUN apk add --no-cache build-base git postgresql-client npm && \
    mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

# Copy the entire app and deps
COPY --from=builder /app .
COPY --from=builder /root/.mix /root/.mix
COPY --from=builder /app/deps ./deps
COPY --from=builder /app/_build ./_build

# Set environment variables
ENV LANG=C.UTF-8
ENV PHX_SERVER=true
ENV MIX_ENV=prod
ENV PATH="/usr/local/bin:$PATH"

# Make init script executable
RUN chmod +x ./init.sh

# Verify deps are present
RUN mix deps.get --only prod

EXPOSE 4000

CMD ["./init.sh"]