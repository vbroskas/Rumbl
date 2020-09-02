defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  @doc """
  render login form
  """
  def new(conn, _) do
    render(conn, "new.html")
  end

  @doc """
  handle login form submission
  """
  def create(
        conn,
        %{"session" => %{"username" => username, "password" => pass}}
      ) do
    case Rumbl.Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        IO.puts("BACK IN SESSION CONT")

        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> RumblWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
