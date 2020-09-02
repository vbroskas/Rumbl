defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  # ***use one changeset per use case***

  # mix ecto.gen.migration create_users to create a new migration with name
  # mix ecto.migrate to migrate it **dont migrate till you have made changes to the migration file!**

  # Be careful. The ecto.migrate task will migrate the database for your current
  # environment. So far, we’ve been running the dev environment. To change the
  # environment, you’d set the MIX_ENV operating-system environment variable.

  # Each field corresponds to both a field in the database and a field in our local
  # Accounts.User struct. By default, Ecto defines the primary key called :id auto-
  # matically. From the schema definition, Ecto automatically defines an Elixir
  # struct for us, which we can create by calling %Rumbl.Accounts.User{} as we did
  # before.

  schema "users" do
    field :name, :string
    field :username, :string
    # Virtual schema fields in Ecto exist only in the struct, not the database!
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  @doc """
  Our changeset accepts an Accounts.User struct and attributes. We then pass
  the cast function a list of fields to tell Ecto that name and username are allowed
  to be cast as user input. This casts all allowable user input values to their schema types and rejects everything else. Next, we used validate_required which makes sure we provide all necessary required fields.

  We pipe validate_required , which returns an Ecto.Changeset , into validate_length to
  validate the username length. Ecto.Changeset defines cast , validate_required , and vali-
  date_length , which we’ve imported at the top of our schema module.

  called by change_user() in Accounts.ex
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  # Very lax password implementation....make more robust in production with OWASP 2
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
