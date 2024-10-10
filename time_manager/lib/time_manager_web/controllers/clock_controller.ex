defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  alias TimeManager.TimeTracking
  alias TimeManager.TimeTracking.Clock

  action_fallback TimeManagerWeb.FallbackController

  # GET /api/clocks
  def index(conn, _params) do
    clocks = TimeTracking.list_clocks()
    render(conn, TimeManagerWeb.ClockJSON, "index.json", clocks: clocks)
  end

  # GET /clocks/user/:user_id
  def list_user_clocks(conn, %{"user_id" => user_id}) do
    clocks = TimeTracking.list_clocks_for_user(user_id)
    render(conn, TimeManagerWeb.ClockJSON, "index.json", clocks: clocks)
    end
  end

  # POST /api/clocks/:user_id
  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    # Add the user_id to the clock_params
    clock_params = Map.put(clock_params, "user_id", user_id)

    # Log the clock_params to verify the user_id is present
    IO.inspect(clock_params, label: "Clock Params")

    with {:ok, %Clock{} = clock} <- TimeTracking.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> render(TimeManagerWeb.ClockJSON, "show.json", clock: clock)
    end
  end
end
