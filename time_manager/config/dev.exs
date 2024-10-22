# backend/config/dev.exs
import Config

IO.puts "Loading DEV environment configuration..."

# Configure your database
config :time_manager, TimeManager.Repo,
  url: System.get_env("DATABASE_URL"),  # Use the full URL instead of individual parts
  # ssl: [verify: :verify_none],  # Fix SSL warning
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Configure the endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  url: [scheme: "https", host: System.get_env("PHX_HOST") || "localhost", port: 443],
  http: [
    ip: {0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  server: true,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:time_manager, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:time_manager, ~w(--watch)]}
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
