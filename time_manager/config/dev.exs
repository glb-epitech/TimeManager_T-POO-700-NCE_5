# backend/config/dev.exs
import Config

# Debug: Print environment variables
dburl = System.get_env("DATABASE_URL")
IO.puts "DATABASE_URL: #{dburl}"
IO.puts "DB_NAME: #{System.get_env("DB_NAME")}"
IO.puts "DB_USER: #{System.get_env("DB_USER")}"
IO.puts "DB_HOST: #{System.get_env("DB_HOST")}"
IO.puts "DB_PORT: #{System.get_env("DB_PORT")}"

# Validate required environment variables
if System.get_env("DATABASE_URL") && (
  is_nil(System.get_env("DB_USER")) ||
  is_nil(System.get_env("DB_PASS")) ||
  is_nil(System.get_env("DB_HOST")) ||
  is_nil(System.get_env("DB_NAME"))
) do
  IO.warn """
  Some database environment variables are missing!
  Make sure all these environment variables are set:
  - DB_USER
  - DB_PASS
  - DB_HOST
  - DB_NAME
  """
end

# Configure your database
config :time_manager, TimeManager.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  hostname: System.get_env("DB_HOST"),
  database: System.get_env("DB_NAME"),
  port: String.to_integer(System.get_env("DB_PORT") || "5432"),
  ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  show_sensitive_data_on_connection_error: true,
  stacktrace: true

# For development, we disable any cache and enable
# debugging and code reloading.
config :time_manager, TimeManagerWeb.Endpoint,
  http: [
    ip: {0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  server: true,  # Make sure the server starts
  secret_key_base: "VYOh1HDmw0ng3paROJ1bPCYi/2BatcDuyt3G1bJcySsuxzLn9TSqrN303REqKqUo",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:time_manager, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:time_manager, ~w(--watch)]}
  ]

# Enable dev routes for dashboard and mailbox
config :time_manager, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
