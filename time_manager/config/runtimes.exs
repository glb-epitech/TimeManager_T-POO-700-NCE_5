# backend/config/runtime.exs
import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :time_manager, TimeManager.Repo,
    # Instead of using url, let's parse it manually
    username: System.get_env("DB_USER"),
    password: System.get_env("DB_PASS"),
    hostname: System.get_env("DB_HOST"),
    database: System.get_env("DB_NAME"),
    port: String.to_integer(System.get_env("DB_PORT") || "5432"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true,
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :time_manager, TimeManagerWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base,
    server: true
end

# Optional development configuration
if config_env() == :dev do
  database_url = System.get_env("DATABASE_URL")
  if database_url do
    config :time_manager, TimeManager.Repo,
      username: System.get_env("DB_USER"),
      password: System.get_env("DB_PASS"),
      hostname: System.get_env("DB_HOST"),
      database: System.get_env("DB_NAME"),
      port: String.to_integer(System.get_env("DB_PORT") || "5432"),
      pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
  end
end
