defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.TimeTracking.WorkingTime

  # Renders a list of working times for index action
  def index(%{working_times: working_times}) do
    %{data: for(working_time <- working_times, do: working_time_to_json(working_time))}
  end

  # Renders a single working time for show action
  def show(%{working_time: working_time}) do
    %{data: working_time_to_json(working_time)}
  end

  # Helper function to convert a working time to JSON
  defp working_time_to_json(%WorkingTime{id: id, start: start, end: end_time, user_id: user_id}) do
    %{
      id: id,
      start: start,
      end: end_time,
      user_id: user_id
    }
  end


end
