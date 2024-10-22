# backend/config/prod.exs
import Config

config :time_manager, TimeManager.Repo,
  ssl: true,
  pool_size: 10

config :time_manager, TimeManagerWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  server: true

# Do not print debug messages in production
config :logger, level: :info
