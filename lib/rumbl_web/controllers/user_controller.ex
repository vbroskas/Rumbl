defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  # accounts context
  alias Rumbl.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
