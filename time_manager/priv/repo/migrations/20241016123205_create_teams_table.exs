defmodule TimeManager.Repo.Migrations.CreateTeamsTable do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :manager_id, references(:users, on_delete: :nothing), null: false  # Foreign key to users table

      timestamps()
    end

    # Optionally, you can also add an index to ensure that only users with the role of 'manager' can be assigned as manager.
    create index(:teams, [:manager_id])
  end
end
