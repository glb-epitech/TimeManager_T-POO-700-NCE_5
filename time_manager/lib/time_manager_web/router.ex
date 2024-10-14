defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/api", TimeManagerWeb do
    pipe_through :api

    # User routes
    get "/users/user", UserController, :show_user_by_email_and_username         # URL: /api/users/user (Afficher un utilisateur spécifique)
    get "/users", UserController, :index                                        # URL: /api/users (Liste des utilisateurs)
    get "/users/:id", UserController, :show                                     # URL: /api/users/:id (Afficher un utilisateur spécifique)
    post "/users", UserController, :create                                      # URL: /api/users (Créer un nouvel utilisateur)
    put "/users/:id", UserController, :update                                   # URL: /api/users/:id (Mettre à jour un utilisateur spécifique)
    delete "/users/:id", UserController, :delete                                # URL: /api/users/:id (Supprimer un utilisateur spécifique)

    # Working Time routes
    get "/workingtimes", WorkingTimeController, :index


    # Lister les heures de travail d'un utilisateur
get "/workingtimes/:user_id/times", WorkingTimeController, :show_user

# Lister les heures de travail spécifiques d'un utilisateur
get "/workingtimes/:user_id", WorkingTimeController, :show_user_working_time

    get "/workingtime/:id", WorkingTimeController, :show   # URL: /api/workingtime/:user_id/:id (Afficher une heure de travail spécifique)
    post "/workingtime/:user_id", WorkingTimeController, :create    # URL: /api/workingtime/:user_id (Créer une heure de travail pour un utilisateur)
    put "/workingtime/:id", WorkingTimeController, :update          # URL: /api/workingtime/:id (Mettre à jour une heure de travail spécifique)
    delete "/workingtime/:id", WorkingTimeController, :delete       # URL: /api/workingtime/:id (Supprimer une heure de travail spécifique)

    # Clocking routes
    get "/clocks", ClockController, :index                            # GET all clocks
    # get "/clocks/:user_id", ClockController, :list_user_clocks        # URL: /api/clocks/:user_id (Lister les pointages d'un utilisateur)
    post "/clocks/:user_id", ClockController, :create                 # URL: /api/clocks/:user_id (Créer un pointage pour un utilisateur)

    get "/clocks/:user_id", ClockController, :show # nouvelle route pour lister les pointages d'un utilisateur
  end


end
