# backend/config/prod.exs
import Config

IO.puts "Loading PROD environment configuration..."

# Configure your database
config :time_manager, TimeManager.Repo,
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASS") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: System.get_env("DB_NAME") || "time_manager_prod",
  port: String.to_integer(System.get_env("DB_PORT") || "5432"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  ssl_opts: [verify: :verify_none],
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Configure the endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  url: [
    scheme: System.get_env("SCHEME") || "http",
    host: System.get_env("PHX_HOST") || "localhost",
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  http: [
    ip: {0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  server: true,
  check_origin: false,
  # Remove development-specific options but keep the same structure
  code_reloader: false,
  debug_errors: false,
  watchers: []

# Print current database configuration
IO.puts """
Current database configuration:
Host: #{System.get_env("DB_HOST") || "localhost"}
Database: #{System.get_env("DB_NAME") || "time_manager_prod"}
User: #{System.get_env("DB_USER") || "postgres"}
Port: #{System.get_env("DB_PORT") || "5432"}
SSL: #{System.get_env("DB_SSL") || "false"}
"""

# Configure logging for production
config :logger, :console,
  format: "[$level] $message\n",
  level: :info

# Important: Remove the static manifest configuration if you're not using it
# config :time_manager, TimeManagerWeb.Endpoint,
#   cache_static_manifest: nil
