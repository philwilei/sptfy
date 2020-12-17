defmodule Sptfy.Object.FullTrack do
  @type t :: %__MODULE__{}

  alias Sptfy.Object.{Album, Artist, TrackLink, TrackRestriction}

  defstruct ~w[
    album
    artists
    available_markets
    disc_number
    duration_ms
    explicit
    external_ids
    external_urls
    href
    id
    is_playable
    linked_from
    restrictions
    name
    popularity
    preview_url
    track_number
    type
    uri
    is_local
  ]a

  def new(fields) do
    fields =
      fields
      |> Sptfy.Object.Helpers.atomize_keys()
      |> Map.update(:album, nil, &Album.new/1)
      |> Map.update(:artists, [], fn artists -> Enum.map(artists, &Artist.new/1) end)
      |> Map.update(:linked_from, nil, &TrackLink.new/1)
      |> Map.update(:restrictions, nil, &TrackRestriction.new/1)

    struct(__MODULE__, fields)
  end
end
