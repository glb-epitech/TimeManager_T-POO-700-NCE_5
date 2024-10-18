defmodule TimeManagerWeb.UserView do
  use TimeManagerWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role
    }
  end
end
