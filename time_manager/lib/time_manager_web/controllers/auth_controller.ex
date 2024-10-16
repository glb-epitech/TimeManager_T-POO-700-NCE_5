defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts

  action_fallback TimeManagerWeb.FallbackController

  def signup(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(:user, user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TimeManagerWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token = TimeManager.Token.generate_and_sign(%{"user_id" => user.id})
        conn
        |> put_status(:ok)
        |> render(:login, user: user, token: token)
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> render(:error, message: "Invalid email or password")
    end
  end
end
