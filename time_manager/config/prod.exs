# backend/config/prod.exs
import Config

config :time_manager, TimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  cache_static_manifest: nil

# Do not print debug messages in production
config :logger, level: :info
