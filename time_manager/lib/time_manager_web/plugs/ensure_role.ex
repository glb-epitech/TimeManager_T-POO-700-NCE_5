# defmodule TimeManagerWeb.Plugs.EnsureRole do
#   import Plug.Conn
#   import Phoenix.Controller

#   alias TimeManagerWeb.ErrorJSON

#   def init(roles) when is_list(roles), do: roles

#   # def call(conn, roles) do
#   #   user_role = get_user_role(conn)

#   #   if user_role in roles do
#   #     conn
#   #   else
#   #     conn
#   #     |> put_status(:forbidden)
#   #     |> put_view(TimeManagerWeb.ErrorJSON)
#   #     |> render("403.json")
#   #     |> halt()
#   #   end
#   # end
  
#   def call(conn, roles) do
#     current_user_id = Guardian.Plug.current_resource(conn)
#     user = TimeManager.Accounts.get_user!(current_user_id)

#     IO.inspect(user.role, label: "Current User Role")

#     if user.role in roles do
#       conn
#     else
#       conn
#       |> put_status(:forbidden)
#       |> Phoenix.Controller.put_view(TimeManagerWeb.ErrorJSON)
#       |> Phoenix.Controller.render(:error, message: "Forbidden")
#       |> halt()
#     end
#   end

#   defp get_user_role(conn) do
#     conn.assigns[:current_user]
#     |> case do
#       nil -> :guest
#       user -> user.role
#     end
#   end
# end

defmodule TimeManagerWeb.Plugs.EnsureRole do
  import Plug.Conn
  import Phoenix.Controller

  def init(roles), do: roles

  def call(conn, roles) do
    user = Guardian.Plug.current_resource(conn)

    IO.inspect(user, label: "User in EnsureRole plug")
    IO.inspect(roles, label: "Required Roles")

    if user && Enum.any?(roles, &(to_string(&1) == user.role)) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Not authorized"})
      |> halt()
    end
  end
end