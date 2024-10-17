defmodule TimeManagerWeb.TeamView do
  use TimeManagerWeb, :view

  def render("index.json", %{teams: teams}) do
    %{data: for team <- teams do
      %{
        id: team.id,
        name: team.name,
        manager_id: team.manager_id,
        inserted_at: team.inserted_at
      }
    end}
  end

  def render("show.json", %{team: team}) do
    %{
      data: %{
        id: team.id,
        name: team.name,
        manager_id: team.manager_id,
        inserted_at: team.inserted_at
      }
    }
  end
end
