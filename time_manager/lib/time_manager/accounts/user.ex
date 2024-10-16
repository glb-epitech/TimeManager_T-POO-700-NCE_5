defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :role, :string, default: "user"
    belongs_to :team, TimeManager.Teams.Team
    field :password, :string, virtual: true  # Virtual field for plain text password
    field :password_hash, :string

    has_one :managed_teams, TimeManager.Teams.Team, foreign_key: :manager_id  # This adds the relation for managed teams

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role, :team_id])
    |> validate_required([:username, :email, :role])
    |> unique_constraint(:email, name: "users_email_index")
    |> validate_length(:password, min: 6)  # Add password length validation
    |> put_password_hash()
  end

  # Function to hash the password using PBKDF2
  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset
      password ->
        hash = Pbkdf2.hash_pwd_salt(password)
        put_change(changeset, :password_hash, hash)
    end
  end

end
