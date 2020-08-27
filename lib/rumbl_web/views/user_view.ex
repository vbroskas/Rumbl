defmodule RumblWeb.UserView do
  use RumblWeb, :view
  alias Rumbl.Accounts

  def first_name(%Accounts.User{name: name}) do
    IO.puts(name)

    name
    # put name into list
    |> String.split(" ")
    # grab first item in list
    |> Enum.at(0)
  end
end
