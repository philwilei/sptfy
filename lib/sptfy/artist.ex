defmodule Sptfy.Artist do
  use Sptfy.Client

  alias Sptfy.Object.{FullArtist, FullTrack, SimplifiedAlbum}

  get "/v1/artists",
    as: :get_artists,
    query: [:ids],
    mapping: list_of(FullArtist, "artists"),
    return_type: [FullArtist.t()]

  get "/v1/artists/:id",
    as: :get_artist,
    query: [],
    mapping: single(FullArtist),
    return_type: FullArtist.t()

  get "/v1/artists/:id/top-tracks",
    as: :get_top_tracks,
    query: [:market],
    mapping: list_of(FullTrack, "tracks"),
    return_type: [FullTrack.t()]

  get "/v1/artists/:id/related-artists",
    as: :get_related_artists,
    query: [],
    mapping: list_of(FullArtist, "artists"),
    return_type: [FullArtist.t()]

  get "/v1/artists/:id/albums",
    as: :get_albums,
    query: [:include_groups, :market, :limit, :offset],
    mapping: paged(SimplifiedAlbum),
    return_type: Paging.t()
end
