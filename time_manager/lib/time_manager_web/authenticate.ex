defmodule TimeManagerWeb.Plugs.Authenticate do
  import Plug.Conn
  alias TimeManager.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         [xsrf_token] <- get_req_header(conn, "x-xsrf-token"),
         {:ok, claims} <- Token.verify_and_validate_with_xsrf(token, xsrf_token) do
      assign(conn, :current_user_id, claims["user_id"])
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(TimeManagerWeb.ErrorView)
        |> Phoenix.Controller.render("401.json")
        |> halt()
    end
  end
end
