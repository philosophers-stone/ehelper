defmodule Ehelper.DocHelp.ErlangUrl do
  @moduledoc """
  Create Erlang URL's for the documention callbacks.


  """

  @head "http://www.erlang.org/doc/man/"

  def url(module) do
    case elixir?(module) do
      false -> @head<>trim(module)<>".html"
      _  ->  nil
    end
  end

  # No anchors w/o arity
  def url(module, _function) do
    case elixir?(module) do
      false -> url(module)
      _  -> nil
    end
  end

  #open http://www.erlang.org/doc/man/crypto.html\#exor-2
  def url(module, function, arity) do
     case elixir?(module) do
      false -> @head<>trim(module)<>".html"<>"\#"<>trim(function)<>"\-"<>Integer.to_string(arity)
      _  ->  nil
    end

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
