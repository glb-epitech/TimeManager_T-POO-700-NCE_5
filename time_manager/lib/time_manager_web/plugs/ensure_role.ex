defmodule TimeManagerWeb.Plugs.EnsureRole do
  import Plug.Conn
  import Phoenix.Controller

  alias TimeManagerWeb.ErrorJSON

  def init(roles) when is_list(roles), do: roles

  def call(conn, roles) do
    user_role = get_user_role(conn)

    if user_role in roles do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(TimeManagerWeb.ErrorJSON)
      |> render("403.json")
      |> halt()
    end
  end

  defp get_user_role(conn) do
    conn.assigns[:current_user]
    |> case do
      nil -> :guest
      user -> user.role
    end
  end
end
