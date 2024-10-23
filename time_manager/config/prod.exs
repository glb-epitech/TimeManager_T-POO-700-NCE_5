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
    scheme: "https",
    host: System.get_env("PHX_HOST") || "localhost",
    port: 443
  ],
  http: [
    ip: {0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  server: true,
  check_origin: false,
  # Remove development-specific options
  code_reloader: false,
  debug_errors: false,
  # Remove watchers in production
  watchers: []

# Print current database configuration
IO.puts """
Current database configuration:
Host: #{System.get_env("DB_HOST") || "localhost"}
Database: #{System.get_env("DB_NAME") || "time_manager_prod"}
User: #{System.get_env("DB_USER") || "postgres"}
Port: #{System.get_env("DB_PORT") || "5432"}
SSL: true
"""

# Configure logging for production
config :logger, :console,
  format: "[$level] $message\n",
  level: :info

# Force SSL in production
config :time_manager, TimeManagerWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Configures the endpoint cache static
config :time_manager, TimeManagerWeb.Endpoint,
  cache_static_manifest: nil

# Configure esbuild (without watch mode)
config :esbuild,
  version: "0.17.11",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
