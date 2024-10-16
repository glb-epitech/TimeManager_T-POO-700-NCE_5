defmodule TimeManager.Repo.Migrations.ModifyUsersTable do
  use Ecto.Migration

  def change do
    # Add new 'role' and 'team_id' columns
    alter table(:users) do
      add :role, :string, null: false, default: "user"        # You can set default role as 'user'
      add :team_id, references(:teams, on_delete: :nothing)   
    end
  end

end