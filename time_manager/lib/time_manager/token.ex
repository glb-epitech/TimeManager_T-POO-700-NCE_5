defmodule TimeManager.Token do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(
      iss: "time_manager",
      aud: "time_manager_users"
    )
    |> add_claim("xsrf", fn -> generate_xsrf_token() end)
  end

  def generate_xsrf_token do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
  end

  def generate_and_sign_token(claims) do
    xsrf_token = generate_xsrf_token()
    {:ok, token, _claims} = generate_and_sign(claims)
    {token, xsrf_token}
  end

  def verify_and_validate_with_xsrf(token, xsrf_token) do
    case verify_and_validate(token) do
      {:ok, claims} ->
        if claims["xsrf"] == xsrf_token do
          {:ok, claims}
        else
          {:error, :invalid_xsrf_token}
        end
      error -> error
    end
  end
end
