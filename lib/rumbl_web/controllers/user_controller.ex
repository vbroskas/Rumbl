defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  # accounts context
  alias Rumbl.Accounts
  # User struct
  alias Rumbl.Accounts.User
  # controller plugs
  # Plug pipelines explicitly check for halted: true between every plug invocation, so the halting concern is neatly solved by Plug.
  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  @doc """
  display form to create new user
  """
  def new(conn, _params) do
    # his function receives a struct, and returns an Ecto.Changeset .
    # changeset is passsed to the form in our template
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  calls to accounts context to create a new user in DB
  """
  def create(conn, %{"user" => user_params}) do
    # call context to insert new user into DB
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        # authenticate new user (put them in session & conn assigns)
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        # redirect logged in user to index page
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
