defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Token

  action_fallback TimeManagerWeb.FallbackController

  def signup(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("user.json", user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> render("error.json", message: inspect(reason))
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    IO.puts("Starting login process")
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        IO.puts("User authenticated successfully")
        {token, xsrf_token} = Token.generate_and_sign_token(%{"user_id" => user.id})
        IO.puts("Token generated")
        conn
        |> put_status(:ok)
        |> render("login.json", %{user: user, token: token, xsrf_token: xsrf_token})
      {:error, :unauthorized} ->
        IO.puts("Authentication failed")
        conn
        |> put_status(:unauthorized)
        |> render("error.json", %{message: "Invalid email or password"})
    end
  end
end
