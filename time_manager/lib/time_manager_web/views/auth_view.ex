defmodule TimeManagerWeb.AuthView do
  use Phoenix.Component

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email
    }
  end

  def render("login.json", %{user: user, token: token}) do
    %{
      user: render("user.json", %{user: user}),
      token: token
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: traverse_errors(changeset)}
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
