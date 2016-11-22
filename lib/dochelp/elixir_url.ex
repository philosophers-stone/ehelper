defmodule ElixirUrl do
  @moduledoc """
  Create Elixir URL's for the documention callbacks.


  """

  @head  "http://elixir-lang.org/docs/stable/"
  @hexhead "http://hexdocs.pm/"
  @elixir_apps [:iex, :logger, :elixir, :mix, :exx, :ex_unit]

  #http://elixir-lang.org/docs/stable/elixir/Base.html
  def url(module) do
    case elixir?(module) do
      true -> head(module)<>trim(module)<>".html"
      _  ->  nil
    end
  end

  # No anchors w/o arity
  def url(module, _function) do
    case elixir?(module) do
      true -> head(module)<>trim(module)<>".html"<>"\#functions"
      _  -> nil
    end
  end

  #http://elixir-lang.org/docs/stable/elixir/Base.html#encode64/1
  def url(module, function, arity) do
     case elixir?(module) do
      true -> head(module)<>trim(module)<>".html"<>"\#"<>trim(function)<>"/"<>Integer.to_string(arity)
      _  ->  nil
    end

  end

  defp elixir?(module) do
    Atom.to_string(module) |>
    String.starts_with?("Elixir.")
  end

  defp head(module) do
    case core_elixir?(module) do
      { true, app } -> @head<>lctrim(app)<>"/"
      _ -> @hexhead<>lctrim(module)<>"/"
    end
  end

  @doc """
  Determines whether module is in core elixir distribution or not.

  """
  def core_elixir?(module) do
    case Enum.find(@elixir_apps, fn(app) -> in_app?(app, module) end) do
      nil ->
        @elixir_apps
        |> Enum.find(fn(app) -> Atom.to_string(app) == lctrim(module) end)
        |> case do
            nil -> false
            app -> {true, app}
          end
      app  -> {true, app}
    end
  end

  # only works for applications that are loaded.
  defp in_app?(application,module) do
    case :application.get_key(application, :modules) do
      {:ok, module_list} -> Enum.any?(module_list, fn(mod) -> mod == module end )
      :undefined -> false
    end
  end

  defp trim(module) do
    module
    |> Atom.to_string
    |> String.replace( ~r/^Elixir./, "")
  end

  defp lctrim(module) do
    module
    |> trim
    |> String.split(".")
    |> Enum.at(0)
    |> add_underscore
    |> String.downcase
  end

  defp add_underscore(string) do
    string
    |> String.replace(~r/([A-Z])/, "_\\1")
    |> String.replace( ~r/^\_/, "")
  end

end