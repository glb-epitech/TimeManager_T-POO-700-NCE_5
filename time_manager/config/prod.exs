# backend/config/prod.exs
import Config

# Configure your database
config :time_manager, TimeManager.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  hostname: System.get_env("DB_HOST"),
  database: System.get_env("DB_NAME"),
  port: String.to_integer(System.get_env("DB_PORT") || "5432"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  ssl_opts: [verify: :verify_none]

# Configure the endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  url: [
    scheme: "https",
    host: System.get_env("PHX_HOST") || "localhost",
    port: 443
  ],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  server: true,
  cache_static_manifest: nil,  # Disable static manifest for now
  check_origin: false  # Allow all origins for testing

# Do not print debug messages in production
config :logger, level: :info

# Force SSL in production
config :time_manager, TimeManagerWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]]
