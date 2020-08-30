defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  # accounts context
  alias Rumbl.Accounts
  # User struct
  alias Rumbl.Accounts.User

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
    # call into our context first, registering our user in the application.
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # Then take connection and transform it twice, adding a flash message with the put_flash function, and then add a
        # redirect instruction with the redirect function.
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
