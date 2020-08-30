defmodule Rumbl.Accounts do
  @moduledoc """
  the Accounts context
  """
  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def list_users do
    Repo.all(User)
  end

  @doc """
  called by user_controller
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  create new user.
  called from user_controller
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # -------------------------Pre-Database Integration-----------------------------

  # def list_users do
  #   [
  #     %User{id: "1", name: "José", username: "josevalim"},
  #     %User{id: "2", name: "Loren", username: "lobaca"},
  #     %User{id: "3", name: "Chris", username: "chrismccord"}
  #   ]
  # end

  # def get_user(id) do
  #   # find(enumerable, default \\ nil, fun)
  #   Enum.find(list_users(), fn user -> user.id == id end)
  # end

  # def test(params) do
  #   IO.inspect(params)
  # end

  # def get_user_by(user_params) do
  #   # iterate over User maps until we find one where the params given are the same for the params of the given user
  #   Enum.find(list_users(), fn user_map ->
  #     # all?() Iterates over the enumerable and invokes fun on each element. When an invocation of fun returns a falsy value (false or nil) iteration stops immediately and false is returned. In all other cases true is returned.
  #     Enum.all?(user_params, fn {key, val} ->
  #       IO.puts("----------------")
  #       IO.inspect(user_params)
  #       IO.puts(key)
  #       IO.puts(val)
  #       IO.inspect(user_map)
  #       IO.puts("-------**---------")
  #       Map.get(user_map, key) == val
  #     end)

  #     # Enum.all?(user_params, fn {key, val} -> Map.get(user_map, key) == val end)
  #   end)
  # end
end
