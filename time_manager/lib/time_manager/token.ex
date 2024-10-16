defmodule TimeManager.Token do
  def generate_and_sign(claims) do
    Phoenix.Token.sign(TimeManagerWeb.Endpoint, "user auth", claims)
  end
end
