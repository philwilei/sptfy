defmodule Sptfy.Object.PlayHistory do
  @moduledoc """
  Module for recently played history struct.
  """

  use Sptfy.Object

  alias Sptfy.Object.{Context, SimplifiedTrack}

  defstruct ~w[
    context
    played_at
    track
  ]a

  def new(fields) do
    fields =
      fields
      |> Helpers.atomize_keys()
      |> Map.update(:context, nil, &build_context(&1))
      |> Map.update(:played_at, nil, &Helpers.parse_timestamp/1)
      |> Map.update(:track, nil, &SimplifiedTrack.new/1)

    struct(__MODULE__, fields)
  end

  defp build_context(_field = nil), do: nil
  defp build_context(field), do: Context.new(field)
end
