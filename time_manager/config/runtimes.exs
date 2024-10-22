# config/runtime.exs
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
    ssl: true,
    ssl_opts: [
      verify: :verify_none
    ]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :time_manager, TimeManagerWeb.Endpoint,
    http: [
      port: port,
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    server: true
end

# Optional: Configure the repo for other environments if needed
if config_env() == :dev do
  # These will override dev.exs settings if environment variables exist
  if database_url = System.get_env("DATABASE_URL") do
    config :time_manager, TimeManager.Repo,
      url: database_url,
      pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
  end
end
