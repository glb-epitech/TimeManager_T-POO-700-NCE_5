defmodule TimeManagerWeb.TeamView do
  use TimeManagerWeb, :view

  def render("show_with_members.json", %{team: team}) do
    %{
      data: %{
        id: team.id,
        name: team.name,
        manager_id: team.manager_id,
        members: for member <- team.members do
          %{
            id: member.id,
            username: member.username,
            email: member.email,
            role: member.role
          }
        end,
        inserted_at: team.inserted_at
      }
    }
  end
end
