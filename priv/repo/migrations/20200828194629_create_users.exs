defmodule Rumbl.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :password_hash, :string

      timestamps()
    end

    # add a unique index to guarantee that the username field is unique across the whole table.
    create unique_index(:users, [:username])
  end
end
