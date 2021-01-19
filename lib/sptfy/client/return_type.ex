defmodule Sptfy.Client.ReturnType do
  @moduledoc false

  @doc false
  @spec ast(tuple()) :: tuple() | :ok | nil
  def ast({:single, _meta, [module | _]}) do
    ok(t(module))
  end

  def ast({:single, module: module}) do
    ok(t(module))
  end

  def ast({:list_of, _meta, [module | _]}) do
    ok([t(module)])
  end

  def ast({:list, opts}) do
    module = Keyword.get(opts, :module)

    ok([t(module)])
  end

  def ast({:paged, _meta, _args}) do
    ok(t(Sptfy.Object.Paging))
  end

  def ast({:paging, _opts}) do
    ok(t(Sptfy.Object.Paging))
  end

  def ast({:paged_with_message, _meta, _args}) do
    {:{}, [], [:ok, t(Sptfy.Object.Paging), t(String)]}
  end

  def ast({:paging_with_message, _opts}) do
    {:{}, [], [:ok, t(Sptfy.Object.Paging), t(String)]}
  end

  def ast({:cursor_paged, _meta, _args}) do
    ok(t(Sptfy.Object.CursorPaging))
  end

  def ast({:cursor_paging, _opts}) do
    ok(t(Sptfy.Object.CursorPaging))
  end

  def ast({:as_is, _meta, _args}) do
    nil
  end

  def ast(:as_is) do
    nil
  end

  def ast({:as_is, _opts}) do
    nil
  end

  def ast(:ok) do
    :ok
  end

  defp t(module) do
    {{:., [], [module, :t]}, [], []}
  end

  defp ok(ast) do
    {:{}, [], [:ok, ast]}
  end
end
