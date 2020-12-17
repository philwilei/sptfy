defmodule Sptfy.Client.ResponseMapper do
  def map(json, {key, fun}) do
    Map.get(json, key) |> fun.()
  end

  def list_of(module) do
    fn list ->
      Enum.map(list, fn elem -> struct(module, atomize_keys(elem)) end)
    end
  end

  defp atomize_keys(map) do
    Enum.map(map, fn
      {k, v} when is_binary(k) -> {String.to_existing_atom(k), v}
      {k, v} when is_atom(k) -> {k, v}
    end)
  end
end
