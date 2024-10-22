# backend/config/runtime.exs
import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :time_manager, TimeManager.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  # Configure the endpoint
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :time_manager, TimeManagerWeb.Endpoint,
    server: true,
    url: [scheme: "https", host: System.get_env("PHX_HOST") || "localhost", port: 443],
    http: [
      port: port
    ],
    secret_key_base: secret_key_base,
    cache_static_manifest: nil  # Removing static manifest requirement for now
end
