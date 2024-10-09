defmodule TimeManager.TimeTracking.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    IO.inspect(attrs, label: "Changeset Params")  # Log the params being passed to changeset

    working_time
    |> cast(attrs, [:start, :end, :user_id])  # Ensure user_id is included in the changeset
    |> validate_required([:start, :end, :user_id])
  end
end
