# # config/runtime.exs
# import Config

# # config/runtime.exs is executed for all environments, including
# # during releases. It is executed after compilation and before the
# # system starts, so it is typically used to load production configuration
# # and secrets from environment variables or elsewhere.

# if config_env() == :prod do
#   database_url =
#     System.get_env("DATABASE_URL") ||
#       raise """
#       environment variable DATABASE_URL is missing.
#       For example: ecto://USER:PASS@HOST/DATABASE
#       """

#   maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

#   config :time_manager, TimeManager.Repo,
#     url: database_url,
#     pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
#     socket_options: maybe_ipv6

#   # The secret key base is used to sign/encrypt cookies and other secrets.
#   secret_key_base =
#     System.get_env("SECRET_KEY_BASE") ||
#       raise """
#       environment variable SECRET_KEY_BASE is missing.
#       You can generate one by calling: mix phx.gen.secret
#       """

#   host = System.get_env("PHX_HOST") || "example.com"
#   port = String.to_integer(System.get_env("PORT") || "4000")

#   config :time_manager, TimeManagerWeb.Endpoint,
#     url: [scheme: "https", host: host, port: 443],
#     http: [
#       # Enable IPv6 and bind on all interfaces.
#       # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
#       ip: {0, 0, 0, 0, 0, 0, 0, 0},
#       port: port
#     ],
#     secret_key_base: secret_key_base,
#     server: true,
#     check_origin: false,  # Be careful with this in production
#     cache_static_manifest: "priv/static/cache_manifest.json"

#   # Force SSL in production
#   config :time_manager, TimeManagerWeb.Endpoint,
#     force_ssl: [rewrite_on: [:x_forwarded_proto]]

#   # Configure your database
#   config :time_manager, TimeManager.Repo,
#     ssl: true,
#     url: database_url,
#     pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

#   # Do not print debug messages in production
#   config :logger, level: :info
# end

# # If you are using Phoenix channels, you need to configure the endpoint
# if System.get_env("PHX_SERVER") do
#   config :time_manager, TimeManagerWeb.Endpoint, server: true
# end
