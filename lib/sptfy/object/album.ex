defmodule Sptfy.Object.Album do
  use Sptfy.Object

  alias Sptfy.Object.{Artist, Image, AlbumRestriction}

  defstruct ~w[
    album_group
    album_type
    artists
    available_markets
    external_urls
    href
    id
    images
    name
    release_date
    release_date_precision
    restrictions
    type
    uri
  ]a

  def new(fields) do
    fields =
      fields
      |> Helpers.atomize_keys()
      |> Map.update(:artists, [], fn artists -> Enum.map(artists, &Artist.new/1) end)
      |> Map.update(:images, [], fn images -> Enum.map(images, &Image.new/1) end)
      |> Map.update(:restrictions, nil, &AlbumRestriction.new/1)

    struct(__MODULE__, fields)
  end
end
