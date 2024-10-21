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
        |> render(TimeManagerWeb.AuthJSON, "user.json", user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TimeManagerWeb.ChangesetJSON)
        |> render("error.json", changeset: changeset)

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(TimeManagerWeb.ErrorJSON)
        |> render("error.json", message: inspect(reason))
    end
  end

  # def login(conn, %{"email" => email, "password" => password}) do
  #   case Accounts.authenticate_user(email, password) do
  #     {:ok, user} ->
  #       {token, xsrf_token} = Token.generate_and_sign_token(%{"user_id" => user.id})
  #       conn
  #       |> put_status(:ok)  # 200 OK pour une authentification réussie
  #       |> json(%{
  #         token: token,
  #         xsrf_token: xsrf_token,
  #         user: %{
  #           id: user.id,
  #           role: user.role,
  #           email: user.email
  #         }
  #       })

  #     {:error, :unauthorized} ->
  #       conn
  #       |> put_status(:unauthorized)  # 401 Unauthorized pour une erreur d'authentification
  #       |> json(%{message: "Invalid email or password"})

  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)  # 422 Unprocessable Entity pour erreurs de validation
  #       |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
  #   end
  # end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = TimeManagerWeb.Guardian.encode_and_sign(user, %{role: user.role})
        conn
        |> put_status(:ok)
        |> json(%{
          token: token,
          user: %{
            id: user.id,
            role: user.role,
            email: user.email
          }
        })

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Invalid email or password"})
    end
  end

  # Traduction des erreurs de changements
  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

end
