defmodule TimeManagerWeb.ReportController do
    use TimeManagerWeb, :controller
    alias TimeManager.Repo
    alias TimeManager.TimeTracking.Clock
    import Ecto.Query

    def weekly_hours(conn, %{"user_id" => user_id}) do
        user_id = String.to_integer(user_id)

        # Calculate the date range for the past week
        end_date = Date.utc_today()
        start_date = Date.add(end_date, -6)  # 7 days ago

        # Fetch all clock-in and clock-out entries for the specified user and date range
        entries = 
        from(te in Clock,
            where: te.user_id == ^user_id and fragment("DATE(?)", te.time) >= ^start_date and fragment("DATE(?)", te.time) <= ^end_date,
            order_by: te.time
        )
        |> Repo.all()

        # Calculate hours worked grouped by day
        hours_by_day = calculate_hours_grouped_by_day(entries)

        # Calculate total hours for the week
        total_hours = Enum.sum(Map.values(hours_by_day))

        # Send the response with total hours worked for each day in the range and the total for the week
        json(conn, %{
        user_id: user_id,
        start_date: Date.to_iso8601(start_date),
        end_date: Date.to_iso8601(end_date),
        hours_by_day: hours_by_day,
        total_hours: total_hours
        })
    end

    def daily_hours(conn, %{"user_id" => user_id, "start_date" => start_date_string, "end_date" => end_date_string}) do
        user_id = String.to_integer(user_id)

        # Parse start_date and end_date strings into Date structs
        case {Date.from_iso8601(start_date_string), Date.from_iso8601(end_date_string)} do
        {{:ok, start_date}, {:ok, end_date}} ->
            # Fetch all clock-in and clock-out entries for the specified user and date range
            entries = 
            from(te in Clock,
                where: te.user_id == ^user_id and fragment("DATE(?)", te.time) >= ^start_date and fragment("DATE(?)", te.time) <= ^end_date,
                order_by: te.time
            )
            |> Repo.all()

            # Calculate hours worked grouped by day
            hours_by_day = calculate_hours_grouped_by_day(entries)

            # Send the response with total hours worked for each day in the range
            json(conn, %{
            user_id: user_id,
            start_date: start_date_string,
            end_date: end_date_string,
            hours_by_day: hours_by_day
            })

        {:error, _} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Invalid date format"})
        end
    end

    # Function to calculate hours worked grouped by day
    defp calculate_hours_grouped_by_day(entries) do
        entries
        |> Enum.chunk_every(2) # Group into pairs of clock-in and clock-out
        |> Enum.reduce(%{}, fn
        [%{time: in_time, status: true}, %{time: out_time, status: false}], acc ->
            date_key = Date.to_iso8601(NaiveDateTime.to_date(in_time)) # Group by date
            duration_in_seconds = DateTime.diff(out_time, in_time)
            duration_in_hours = duration_in_seconds / 3600

            Map.update(acc, date_key, duration_in_hours, &(&1 + duration_in_hours)) # Sum hours per day
        _, acc -> 
            acc # Ignore invalid pairs
        end)
    end
    
end
