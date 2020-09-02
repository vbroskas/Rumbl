defmodule Rumbl.TestHelpers do
  alias Rumbl.{
    Accounts,
    Multimedia
  }

  @doc """
  user_fixture function that accepts a map of attributes and creates a
  persistent user with them
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "secretpass"
      })
      |> Accounts.register_user()

    user
  end

  @doc """
  video_fixture function that accepts a map of attributes and creates a
  persistent video with them. Must also take the Accounts.User that created the video
  """
  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(
        attrs,
        %{
          title: "A title",
          url: "https://test.com",
          description: "a description"
        }
      )

    {:ok, video} = Multimedia.create_video(user, attrs)
    video
  end
end
