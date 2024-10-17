defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_view, json: TimeManagerWeb.ErrorJSON

  end

  pipeline :auth do
    plug TimeManagerWeb.Plugs.Authenticate
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :employee_auth do
    plug TimeManagerWeb.Plugs.EnsureRole, [:employee, :manager, :general_manager]
  end

  pipeline :manager_auth do
    plug TimeManagerWeb.Plugs.EnsureRole, [:manager, :general_manager]
  end

  pipeline :general_manager_auth do
    plug TimeManagerWeb.Plugs.EnsureRole, [:general_manager]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Auth routes (non protégées)
    post "/auth/login", AuthController, :login
    post "/auth/signup", AuthController, :signup
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth, :ensure_auth]

    # Routes for all authenticated users
    get "/users/profile", UserController, :show_current_user
    put "/users/profile", UserController, :update_current_user
    delete "/users/profile", UserController, :delete_current_user

    resources "/workingtimes", WorkingTimeController, only: [:index, :show, :create, :update, :delete]
    resources "/clocks", ClockController, only: [:index, :create, :show]

    get "/dashboard", DashboardController, :show
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth, :ensure_auth, :manager_auth]

    # Routes for managers and general managers
    resources "/teams", TeamController, except: [:new, :edit]
    get "/teams/:id/members", TeamController, :show_members
    post "/teams/:id/members/:user_id", TeamController, :add_member
    delete "/teams/:id/members/:user_id", TeamController, :remove_member

    get "/reports/team/:team_id/daily_hours", ReportController, :team_daily_hours
    get "/reports/team/:team_id/weekly_hours", ReportController, :team_weekly_hours
    get "/reports/employee/:user_id/daily_hours", ReportController, :employee_daily_hours
    get "/reports/employee/:user_id/weekly_hours", ReportController, :employee_weekly_hours
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth, :ensure_auth, :general_manager_auth]

    # Routes for general manager only
    get "/users", UserController, :index
    post "/users/:id/promote", UserController, :promote_to_manager
    post "/users/:id/demote", UserController, :demote_to_employee
    delete "/users/:id", UserController, :delete

    get "/reports/company/daily_hours", ReportController, :company_daily_hours
    get "/reports/company/weekly_hours", ReportController, :company_weekly_hours
  end
end
