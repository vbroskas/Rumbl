defmodule Rumbl.Accounts do
  @moduledoc """
  the Accounts context
  """
  alias Rumbl.Accounts.User

  def list_users do
    [
      %User{id: "1", name: "José", username: "josevalim"},
      %User{id: "2", name: "Loren", username: "lobaca"},
      %User{id: "3", name: "Chris", username: "chrismccord"}
    ]
  end

  def get_user(id) do
    # find(enumerable, default \\ nil, fun)
    Enum.find(list_users(), fn map -> map.id == id end)
  end

  def get_user_by(params) do
    # iterate over User maps until we find one where the params given are the same for the params of the given user
    Enum.find(list_users(), fn a_user_map ->
      Enum.all?(params, fn {key, val} -> Map.get(a_user_map, key) == val end)
    end)
  end
end
