defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RumblWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/manage", RumblWeb do
    pipe_through [:browser, :authenticate_user]

    '''
    video_path  GET     /videos                                RumblWeb.VideoController :index
    video_path  GET     /videos/:id/edit                       RumblWeb.VideoController :edit
    video_path  GET     /videos/new                            RumblWeb.VideoController :new
    video_path  GET     /videos/:id                            RumblWeb.VideoController :show
    video_path  POST    /videos                                RumblWeb.VideoController :create
    video_path  PATCH   /videos/:id                            RumblWeb.VideoController :update
                PUT     /videos/:id                            RumblWeb.VideoController :update
    video_path  DELETE  /videos/:id                            RumblWeb.VideoController :delete
    '''

    resources "/videos", VideoController
  end

  scope "/", RumblWeb do
    pipe_through :browser

    # mix phx.routes to see all available routes!
    # https://hexdocs.pm/phoenix/routing.html#path-helpers ***Routes.something_path***

    get "/", PageController, :index

    """
    user_path
    get "/users", UserController, :index
    get "/users/:id/edit", UserController, :edit
    get "/users/new", UserController, :new
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    patch "/users/:id", UserController, :update
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete
    """

    resources "/users", UserController, only: [:index, :show, :new, :create]

    '''
    session_path  GET     /sessions/new        RumblWeb.SessionController :new (display login form)
    session_path  POST    /sessions            RumblWeb.SessionController :create (handle login form submission)
    session_path  DELETE  /sessions/:id        RumblWeb.SessionController :delete (log out)
    '''

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RumblWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RumblWeb.Telemetry
    end
  end
end
