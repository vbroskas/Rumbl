defmodule Rumbl.Multimedia.Video do
  use Ecto.Schema
  import Ecto.Changeset

  '''
  To relate our data at the schema level, we need to tell Ecto
  about our Video to User association. Replace your field :user_id, :id line in your
  video schema with the following association
  '''

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    # field :user_id, :id
    # Indicates a one-to-one or many-to-one association with another schema.
    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Rumbl.Multimedia.Category

    timestamps()
  end

  @doc false
  '''
    cast uses a
    whitelist to tell Ecto which fields from user-input may be allowed in the input.
    validate_required is a validation that tells Ecto which fields must be present from
    that list of fields‘
  '''

  @doc """
  assoc_constraint converts foreign-key constraint errors into human-readable
  error messages and guarantees that a video is created only if the category
  exists in the database.

  takes in a video struct & attrs
  """
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
  end
end
