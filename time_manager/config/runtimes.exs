# config/runtime.exs
import Config

if config_env() == :prod do
  config :time_manager, TimeManager.Repo,
    adapter: Ecto.Adapters.Postgres,  # Explicitly set adapter
    url: System.get_env("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: [verify: :verify_none]

  # The secret key base is used to sign/encrypt cookies and other secrets
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :time_manager, TimeManagerWeb.Endpoint,
    server: true,
    url: [host: host, port: port],
    http: [
      ip: {0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # Configure your database
  config :time_manager,
    ecto_repos: [TimeManager.Repo]

  # Force IPv4 to speed up startup
  config :time_manager, TimeManager.Repo,
    socket_options: [:inet6]
end
