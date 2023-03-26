defmodule DailyfoodWeb.Router do
  use DailyfoodWeb, :router

  alias DailyfoodWeb.Plugs.UUIDChecker

  pipeline :api do
    plug :accepts, ["json"]
    plug UUIDChecker
  end

  pipeline :auth do
    plug DailyfoodWeb.Auth.Pipeline
  end

  scope "/api", DailyfoodWeb do
    pipe_through [:api, :auth]

    get "/users/", UsersController, :show
    put "/users/", UsersController, :update

    post "/meals/create", MealsController, :create
    get "/meals/:initial_date/:final_date", MealsController, :show
    post "/meals/generate-pdf", MealsController, :generate_pdf
  end

  scope "/api", DailyfoodWeb do
    pipe_through :api
    post "/auth/login", AuthController, :login
    post "/auth/sing_up", AuthController, :sing_up
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.s
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: DailyfoodWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
