# backend/config/dev.exs
import Config

database_url = System.get_env("DATABASE_URL")

if database_url do
  # Production/staging database config
  config :time_manager, TimeManager.Repo,
    url: database_url,
    ssl: true,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
else
  # Local database config
  config :time_manager, TimeManager.Repo,
    username: "postgres",
    password: "postgres",
    hostname: "localhost",
    database: "time_manager_dev",
    stacktrace: true,
    show_sensitive_data_on_connection_error: true,
    pool_size: 10
end

port = String.to_integer(System.get_env("PORT") || "4000")

config :time_manager, TimeManagerWeb.Endpoint,
  http: [
    ip: {0, 0, 0, 0},
    port: port
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:time_manager, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:time_manager, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/time_manager_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
