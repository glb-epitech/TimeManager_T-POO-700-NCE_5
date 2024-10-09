defmodule TimeManager.TimeTracking.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime
    belongs_to :user, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    IO.inspect(attrs, label: "Attrs in Changeset")  # Add this line to log attrs
    clock
    |> cast(attrs, [:time, :status, :user_id])  # Ensure user_id is here
    |> validate_required([:time, :status, :user_id])
    |> IO.inspect(label: "Changeset after cast")
  end
end
