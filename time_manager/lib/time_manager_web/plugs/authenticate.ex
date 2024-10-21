defmodule TimeManagerWeb.Plugs.Authenticate do
  import Plug.Conn
  alias TimeManager.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    # Log the headers for debugging
    IO.inspect(get_req_header(conn, "authorization"), label: "Authorization Header")
    IO.inspect(get_req_header(conn, "x-xsrf-token"), label: "XSRF Token Header")

    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         [xsrf_token] <- get_req_header(conn, "x-xsrf-token"),
         {:ok, claims} <- Token.verify_and_validate_with_xsrf(token, xsrf_token) do
      # Log claims for debugging
      IO.inspect(claims, label: "Token Claims")
      
      assign(conn, :current_user_id, claims["user_id"])
    else
      error ->
        # Log the error that occurred during validation
        IO.inspect(error, label: "Token Validation Error")

        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(json: TimeManagerWeb.ErrorJSON)
        |> Phoenix.Controller.render(:error, status: :unauthorized)
        |> halt()
    end
  end
end
