defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TimeManagerWeb.Plugs.Authenticate
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Auth routes (non protégées)
    post "/auth/login", AuthController, :login
    post "/auth/signup", AuthController, :signup
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth]

    # User routes
    get "/users/user", UserController, :show_user_by_email_and_username
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    # Report routes
    get "/reports/daily_hours", ReportController, :daily_hours
    get "/reports/weekly_hours", ReportController, :weekly_hours

    # Working Time routes
    get "/workingtimes", WorkingTimeController, :index
    get "/workingtimes/:user_id/times", WorkingTimeController, :show_user
    get "/workingtimes/:user_id", WorkingTimeController, :show_user_working_time
    get "/workingtime/:id", WorkingTimeController, :show
    post "/workingtime/:user_id", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete

    # Clocking routes
    get "/clocks", ClockController, :index
    post "/clocks/:user_id", ClockController, :create
    get "/clocks/:user_id", ClockController, :show
  end
end
