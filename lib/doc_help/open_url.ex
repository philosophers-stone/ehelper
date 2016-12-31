defmodule Ehelper.DocHelp.OpenUrl do
  @moduledoc """
  Implements DocHelp by printing out a documentation url.

  """

  def documentation(module) do
    case elixir?(module) do
      true -> find(Ehelper.DocHelp.ElixirUrl, module)
      _  -> find(Ehelper.DocHelp.ErlangUrl, module)
    end
  end

  def documentation(module, _function) do
    documentation(module)
  end

  def documentation(module, function, arity) do
    case elixir?(module) do
      true -> find(Ehelper.DocHelp.ElixirUrl, module, function, arity)
      _ ->  find(Ehelper.DocHelp.ErlangUrl, module, function, arity)
    end
  end

  defp find(url_module, module) do
    case url_module.url(module) do
      nil -> {:not_found, "No url documentation found for #{inspect module}\n"}
      url when is_binary(url) ->
        System.cmd("open", [ url ])
        {:found, [{inspect(module), "Documentation can be found at "<>url<>"\n"}]}
    end
  end

  defp find(url_module, module, function, arity) do
    case url_module.url(module, function, arity) do
      nil -> {:not_found, "No url documentation found for #{inspect module}\n"}
      url when is_binary(url) ->
        System.cmd("open", [ url ])
        {:found, [{inspect(module), "Documentation can be found at "<>url<>"\n"}]}
    end
  end

  defp elixir?(module) do
    Atom.to_string(module) |>
    String.starts_with?("Elixir.")
  end

end
