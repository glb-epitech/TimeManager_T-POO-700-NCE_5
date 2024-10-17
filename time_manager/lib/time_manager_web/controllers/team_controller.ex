defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.Team

  # GET /teams - Lister toutes les équipes
  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, "index.json", teams: teams)
  end

  # GET /teams/:id - Récupérer une équipe spécifique
  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, "show.json", team: team)
  end

  # POST /teams - Créer une nouvelle équipe
  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end

  # PUT /teams/:id - Mettre à jour une équipe
  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  # DELETE /teams/:id - Supprimer une équipe
  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
