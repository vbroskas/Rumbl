defmodule RumblWeb.VideoView do
  use RumblWeb, :view

  '''
  View picks all templates in lib/rumbl_web/templates/video and transforms them into
  functions, such as render("index.html", assigns)
  '''

  @doc """
  Populates the select dropdown in the form.html.eex template for video
  """
  def category_select_options(categories) do
    for category <- categories, do: {category.name, category.id}
  end
end
