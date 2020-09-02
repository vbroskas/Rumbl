defmodule RumblWeb.Auth do
  import Plug.Conn

  # need controller functions for flash and redirect in authenticate_user()
  import Phoenix.Controller
  alias RumblWeb.Router.Helpers, as: Routes

  @moduledoc """
  The authentication process works in two stages. First, we’ll store the user ID
  in the session every time a new user registers or a user logs in. Second, we’ll
  check if there’s a new user in the session and store it in conn.assigns for every
  incoming request, so it can be accessed in our controllers and views.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Rumbl.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  @doc """
  returns conn object
  """
  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # tells Plug to send the session cookie back to the client with a different identifier
    |> configure_session(renew: true)
  end

  @doc """
  if we wanted to keep session we could also delete only the user ID information by calling
  delete_session(conn, :user_id)
  """
  def logout(conn) do
    configure_session(conn, drop: true)
  end

  @doc """
  If there’s a current user, we return the connection unchanged. Otherwise we
  store a flash message and redirect back to our application root. We use halt(conn)
  to stop any downstream transformations.

  ***IN ORDER TO PLUG THIS IN OUR APPLICATION WE MUST MAKE IT A FUNCTIONAL PLUG***
  """
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to view this page!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
