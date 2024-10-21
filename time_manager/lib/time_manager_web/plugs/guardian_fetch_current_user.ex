defmodule TimeManagerWeb.Plugs.GuardianFetchCurrentUser do
  import Plug.Conn
  alias TimeManager.Accounts
  alias TimeManagerWeb.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil -> assign(conn, :current_user, nil)
      user -> assign(conn, :current_user, user)
    end
  end
end
