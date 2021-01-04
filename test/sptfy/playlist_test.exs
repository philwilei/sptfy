defmodule Sptfy.PlaylistTest do
  use ExUnit.Case, async: false

  import Mock

  alias Sptfy.Playlist
  alias Sptfy.Object.{FullPlaylist, Image, Paging, PlaylistTrack, SimplifiedPlaylist}

  describe "get_my_playlists/2" do
    test "returns a Paging struct" do
      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/me/playlists", _ -> TestHelpers.response(paging_playlists_json()) end do
        assert {:ok, %Paging{items: [%SimplifiedPlaylist{}]}} = Playlist.get_my_playlists("token")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/me/playlists", _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.get_my_playlists("token")
      end
    end
  end

  describe "get_user_playlists/2" do
    test "returns a Paging struct" do
      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/users/abc/playlists", _ -> TestHelpers.response(paging_playlists_json()) end do
        assert {:ok, %Paging{items: [%SimplifiedPlaylist{}]}} = Playlist.get_user_playlists("token", id: "abc")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/users/abc/playlists", _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.get_user_playlists("token", id: "abc")
      end
    end
  end

  describe "create_user_playlist/2" do
    test "returns a Playlist struct" do
      with_mock Sptfy.Client.HTTP, post: fn _, "/v1/users/abc/playlists", _, _ -> TestHelpers.response(playlist_json()) end do
        assert {:ok, %FullPlaylist{}} = Playlist.create_user_playlist("token", id: "abc", name: "Playlist")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, post: fn _, "/v1/users/abc/playlists", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.create_user_playlist("token", id: "abc", name: "Playlist")
      end
    end
  end

  describe "get_playlist/2" do
    test "returns a FullPlaylist struct" do
      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/playlists/abc", _ -> TestHelpers.response(playlist_json()) end do
        assert {:ok, %FullPlaylist{}} = Playlist.get_playlist("token", id: "abc")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/playlists/abc", _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.get_playlist("token", id: "abc")
      end
    end
  end

  describe "update_playlist_details/2" do
    test "returns :ok" do
      with_mock Sptfy.Client.HTTP, put: fn _, "/v1/playlists/abc", _, _ -> TestHelpers.response(%{}) end do
        assert :ok == Playlist.update_playlist_details("token", id: "abc", name: "Playlist")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, put: fn _, "/v1/playlists/abc", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.update_playlist_details("token", id: "abc", name: "Playlist")
      end
    end
  end

  describe "get_playlist_tracks/2" do
    test "returns a Paging struct" do
      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/playlists/abc/tracks", _ -> TestHelpers.response(paging_playlist_tracks_json()) end do
        assert {:ok, %Paging{items: [%PlaylistTrack{}]}} = Playlist.get_playlist_tracks("token", id: "abc")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/playlists/abc/tracks", _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.get_playlist_tracks("token", id: "abc")
      end
    end
  end

  describe "replace_tracks/3" do
    test "returns :ok" do
      json = %{"snapshot_id" => "SNAPSHOT_ID"}

      with_mock Sptfy.Client.HTTP, put: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert :ok == Playlist.replace_tracks("token", id: "abc", uris: ["uri"])
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, put: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.replace_tracks("token", id: "abc", uris: ["uri"])
      end
    end
  end

  describe "reorder_tracks/3" do
    test "returns :ok" do
      json = %{"snapshot_id" => "SNAPSHOT_ID"}

      with_mock Sptfy.Client.HTTP, put: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert :ok == Playlist.reorder_tracks("token", id: "abc", range_start: 0, insert_before: 5)
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, put: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.reorder_tracks("token", id: "abc", range_start: 0, insert_before: 5)
      end
    end
  end

  describe "add_tracks/2" do
    test "returns :ok" do
      json = %{"snapshot_id" => "SNAPSHOT_ID"}

      with_mock Sptfy.Client.HTTP, post: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert :ok == Playlist.add_tracks("token", id: "abc", uris: ["uri"], position: 1)
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, post: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.add_tracks("token", id: "abc", uris: ["uri"], position: 1)
      end
    end
  end

  describe "get_cover_images/2" do
    test "returns a list of Image structs" do
      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/playlists/abc/images", _ -> TestHelpers.response([image_json()]) end do
        assert {:ok, [%Image{}]} = Playlist.get_cover_images("token", id: "abc")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, get: fn _, "/v1/playlists/abc/images", _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.get_cover_images("token", id: "abc")
      end
    end
  end

  describe "upload_cover_image/3" do
    test "returns :ok" do
      with_mock Sptfy.Client.HTTP, put_jpeg: fn _, "/v1/playlists/abc/images", _, _ -> TestHelpers.response(%{}) end do
        assert :ok == Playlist.upload_cover_image("token", "base64", id: "abc")
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, put_jpeg: fn _, "/v1/playlists/abc/images", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.upload_cover_image("token", "base64", id: "abc")
      end
    end
  end

  describe "remove_tracks/2" do
    test "returns :ok" do
      json = %{"snapshot_id" => "SNAPSHOT_ID"}

      with_mock Sptfy.Client.HTTP, delete: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert :ok == Playlist.remove_tracks("token", id: "abc", tracks: [%{uri: "uri"}])
      end
    end

    test "returns Error struct on error" do
      json = %{"error" => %{"message" => "Oops", "status" => 401}}

      with_mock Sptfy.Client.HTTP, delete: fn _, "/v1/playlists/abc/tracks", _, _ -> TestHelpers.response(json) end do
        assert {:error, %Sptfy.Object.Error{message: "Oops", status: 401}} = Playlist.remove_tracks("token", id: "abc", tracks: [%{uri: "uri"}])
      end
    end
  end

  defp paging_playlists_json do
    %{
      "href" => "https://api.spotify.com/v1/users/USER_ID/playlists?offset=0&limit=20",
      "items" => [playlist_json()],
      "limit" => 20,
      "next" => "https://api.spotify.com/v1/users/USER_ID/playlists?offset=20&limit=20",
      "offset" => 0,
      "previous" => nil,
      "total" => 1412
    }
  end

  defp playlist_json do
    %{
      "collaborative" => false,
      "description" => "PLAYLIST DESCRIPTION",
      "external_urls" => %{
        "spotify" => "https://open.spotify.com/playlist/PLAYLIST_ID"
      },
      "href" => "https://api.spotify.com/v1/playlists/PLAYLIST_ID",
      "id" => "PLAYLIST_ID",
      "images" => [
        %{
          "height" => nil,
          "url" => "https://i.scdn.co/image/...",
          "width" => nil
        }
      ],
      "name" => "PLAYLIST NAME",
      "owner" => %{
        "display_name" => "Spotify",
        "external_urls" => %{
          "spotify" => "https://open.spotify.com/user/USER_ID"
        },
        "href" => "https://api.spotify.com/v1/users/USER_ID",
        "id" => "USER_ID",
        "type" => "user",
        "uri" => "spotify:user:USER_ID"
      },
      "primary_color" => nil,
      "public" => true,
      "snapshot_id" => "SNAPSHOT_ID",
      "tracks" => %{
        "href" => "https://api.spotify.com/v1/playlists/PLAYLIST_ID/tracks",
        "total" => 50
      },
      "type" => "playlist",
      "uri" => "spotify:playlist:PLAYLIST_ID"
    }
  end

  defp paging_playlist_tracks_json do
    %{
      "href" => "https://api.spotify.com/v1/playlists/PLAYLIST_ID/tracks?offset=0&limit=100",
      "items" => [playlist_track_json()],
      "limit" => 100,
      "next" => "https://api.spotify.com/v1/playlists/PLAYLIST_ID/tracks?offset=100&limit=100",
      "offset" => 0,
      "previous" => nil,
      "total" => 150
    }
  end

  defp playlist_track_json do
    %{
      "added_at" => "2020-12-21T16:08:09Z",
      "added_by" => %{
        "external_urls" => %{"spotify" => "https://open.spotify.com/user/USER_ID"},
        "href" => "https://api.spotify.com/v1/users/USER_ID",
        "id" => "USER_ID",
        "type" => "user",
        "uri" => "spotify:user:USER_ID"
      },
      "is_local" => false,
      "primary_color" => nil,
      "track" => %{
        "album" => %{
          "album_type" => "album",
          "artists" => [
            %{
              "external_urls" => %{
                "spotify" => "https://open.spotify.com/artist/ARTIST_ID"
              },
              "href" => "https://api.spotify.com/v1/artists/ARTIST_ID",
              "id" => "ARTIST_ID",
              "name" => "ARTIST NAME",
              "type" => "artist",
              "uri" => "spotify:artist:ARTIST_ID"
            }
          ],
          "available_markets" => ["US"],
          "external_urls" => %{
            "spotify" => "https://open.spotify.com/album/ALBUM_ID"
          },
          "href" => "https://api.spotify.com/v1/albums/ALBUM_ID",
          "id" => "ALBUM_ID",
          "images" => [
            %{
              "height" => 640,
              "url" => "https://i.scdn.co/image/...",
              "width" => 640
            },
            %{
              "height" => 300,
              "url" => "https://i.scdn.co/image/...",
              "width" => 300
            },
            %{
              "height" => 64,
              "url" => "https://i.scdn.co/image/...",
              "width" => 64
            }
          ],
          "name" => "ALBUM NAME",
          "release_date" => "1986-06-16",
          "release_date_precision" => "day",
          "total_tracks" => 10,
          "type" => "album",
          "uri" => "spotify:album:ALBUM_ID"
        },
        "artists" => [
          %{
            "external_urls" => %{
              "spotify" => "https://open.spotify.com/artist/ARTIST_ID"
            },
            "href" => "https://api.spotify.com/v1/artists/ARTIST_ID",
            "id" => "ARTIST_ID",
            "name" => "ARTIST NAME",
            "type" => "artist",
            "uri" => "spotify:artist:ARTIST_ID"
          }
        ],
        "available_markets" => ["US"],
        "disc_number" => 1,
        "duration_ms" => 244_586,
        "episode" => false,
        "explicit" => false,
        "external_ids" => %{"isrc" => "ISRC"},
        "external_urls" => %{
          "spotify" => "https://open.spotify.com/track/TRACK_ID"
        },
        "href" => "https://api.spotify.com/v1/tracks/TRACK_ID",
        "id" => "TRACK_ID",
        "is_local" => false,
        "name" => "TRACK NAME",
        "popularity" => 74,
        "preview_url" => "https://p.scdn.co/mp3-preview/...",
        "track" => true,
        "track_number" => 9,
        "type" => "track",
        "uri" => "spotify:track:TRACK_ID"
      }
    }
  end

  defp image_json do
    %{
      "height" => 300,
      "url" => "https://i.scdn.co/image/...",
      "width" => 300
    }
  end
end
