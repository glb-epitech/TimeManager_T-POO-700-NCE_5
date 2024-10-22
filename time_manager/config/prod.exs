# backend/config/prod.exs
import Config

config :time_manager, TimeManagerWeb.Endpoint,
  cache_static_manifest: nil,  # Disable static manifest for now
  check_origin: false  # Allow all origins for testing

# Do not print debug messages in production
config :logger, level: :info
