defmodule Rumbl.Repo.Migrations.AddCategoryIdToVideo do
  use Ecto.Migration

  @doc """
  This code sets up a database constraint between videos and categories, one
  that will ensure that the category_id for a video exists.
  """
  def change do
    alter table(:videos) do
      add :category_id, references(:categories)
    end
  end
end
