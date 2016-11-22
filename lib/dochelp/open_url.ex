defmodule OpenUrl do
  @moduledoc """
  Uses the system open command to open documentation urls.

  """

  def documentation(module) do
    case elixir?(module) do
      true -> System.cmd("open", [ "dash://elixir:"<>trim(module) ])
            { :found, [{ inspect(module), "Searching in Dash\n"}] }
      _  -> System.cmd("open", [ "dash://erl:"<>Atom.to_string(module) ] )
            { :found, [{ inspect(module), "Searching in Dash\n"}] }
    end
  end

  def documentation(module, function) do
    case elixir?(module) do
      true -> System.cmd("open", [ "dash://elixir:"<>trim(module)<>"."<>Atom.to_string(function) ])
            { :found, [{"#{inspect(module)}.#{to_string(function)}", "Searching in Dash\n"}] }
      _  -> System.cmd("open", [ "dash://erl:"<>Atom.to_string(module)<>":"<>Atom.to_string(function) ] )
            { :found, [{"#{inspect(module)}:#{to_string(function)}", "Searching in Dash\n"}] }
    end
  end

  # No way to specify arity on dash search url.
  def documentation(module, function, _arity) do
    documentation(module, function)
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