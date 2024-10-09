defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller
  alias TimeManager.TimeTracking
  alias TimeManager.TimeTracking.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  # GET /api/workingtimes
  def index(conn, _params) do
    working_times = TimeTracking.list_workingtimes()
    render(conn, TimeManagerWeb.WorkingTimeJSON, "index.json", working_times: working_times)
  end

  # GET /api/workingtimes/:user_id?start=START_DATE&end=END_DATE
  def index(conn, %{"user_id" => user_id, "start" => start_date, "end" => end_date}) do
    working_times = TimeTracking.list_working_times(user_id, start_date, end_date)
    render(conn, TimeManagerWeb.WorkingTimeJSON, "index.json", working_times: working_times)
  end

  # GET /api/workingtimes/:user_id/:id
  def show(conn, %{"id" => id}) do
    working_time = TimeTracking.get_working_time!(id)
    render(conn, TimeManagerWeb.WorkingTimeJSON, "show.json", working_time: working_time)
  end

  # POST /api/workingtimes/:user_id
  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    # Log the params to ensure user_id is included
    IO.inspect(user_id, label: "User ID from URL")
    IO.inspect(working_time_params, label: "Initial Working Time Params")

    # Merge the user_id from the URL into working_time_params
    working_time_params = Map.put(working_time_params, "user_id", user_id)

    # Log final params before inserting
    IO.inspect(working_time_params, label: "Final Working Time Params with User ID")

    with {:ok, %WorkingTime{} = working_time} <- TimeTracking.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> render(TimeManagerWeb.WorkingTimeJSON, "show.json", working_time: working_time)
    end
  end

  # PUT /api/workingtimes/:id/
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = TimeTracking.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- TimeTracking.update_working_time(working_time, working_time_params) do
      render(conn, TimeManagerWeb.WorkingTimeJSON, "show.json", working_time: working_time)
    end
  end

  # DELETE /api/workingtimes/:id
  def delete(conn, %{"id" => id}) do
    working_time = TimeTracking.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- TimeTracking.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
