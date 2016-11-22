defmodule DashUrl do
  @moduledoc """
  Create Dash URL's for the documention callbacks.

  Only intended to work on OS X machines with Dash installed.
  """

  def url(module) do
    case elixir?(module) do
      true -> head(module)<>trim(module)
      _  ->  "dash://erl:"<>Atom.to_string(module)
    end
  end

  def url(module, function) do
    case elixir?(module) do
      true -> head(module)<>trim(module)<>"."<>Atom.to_string(function)
      _  -> "dash://erl:"<>Atom.to_string(module)<>":"<>Atom.to_string(function)
    end
  end

  defp head(module) do
    case ElixirUrl.core_elixir?(module) do
      {true, _app} -> "dash://elixir:"
      _ -> "dash://hex:"
    end
  end

  # No way to specify arity on dash search url.
  def url(module, function, _arity) do
    url(module, function)
  end

  defp elixir?(module) do
    Atom.to_string(module) |>
    String.starts_with?("Elixir.")
  end

  defp trim(module) do
    Atom.to_string(module) |>
    String.replace( ~r/^Elixir./, "")
  end

end