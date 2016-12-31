defmodule Ehelper.Config do
  @moduledoc """
  Configures the Ehelper e command.

  There are two options:

    * helpers:  - A List of Modules
    * find:     - Can be either :first or :all
                  determines if the e command stops
                  after the first positive result or
                  uses all the doc_helper modules.

  Examples:

This provides an e command that mirrors the h command and search erlang man pages if they are
installed.

    Ehelper.Config.configure([helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman]])

Some other possible configurations.

Configures the e command to run all the doc_helpers, not just the first that claims to
have documentation. Useful with the printurl and openurl doc helpers.
This will also print the url for the online version of the documentation.

    Ehelper.Config.configure([find: :all])
    Ehelper.Config.configure([helpers: [Ehelper.DocHelp.Elixir,
      Ehelper.DocHelp.Erlman, Ehelper.DocHelp.PrintUrl]])

If you are on OS X, these helpers will open the documentation in Dash.
Ehelper.Config.configure([helpers: [ Ehelper.DocHelp.DashDoc]])

"""

  @table IEx.Config
  @agent IEx.Config

  @keys [
    :doc_helpers]

  @doc """
  Configures the Ehelper e command.

  There are two keyword list options:

    * helpers:  - A List of Modules
    * find:     - Can be either :first or :all
                  determines if the e command stops
                  after the first positive result or
                  uses all the doc_helper modules.

  Only one option can be configured per invocation, i.e. you can
  either use the helpers: or find: keyword, but not both.

  Examples:

  This provides an e command that mirrors the h command and search erlang man pages if they are
  installed.

    Ehelper.Config.configure([helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman]])

  """
  def configure([{:doc_helpers, options}]) do
    config_agent(doc_helpers: options)
  end

  def configure([{:find, option }]) do
    config_agent(doc_helpers: [find: option])
  end

  def configure([{:helpers, helper_list}]) do
    config_agent(doc_helpers: [helpers: helper_list])
  end

  defp config_agent(options) do
    Agent.update(@agent, __MODULE__, :handle_configure, [options])
  end

  def handle_configure(tab, options) do
    options = :lists.ukeysort(1, options)
    get_config()
    |> Keyword.merge(options, &merge_option/3)
    |> put_config()
    tab
  end

  defp get_config() do
    Application.get_all_env(:ehelper)
    |> Keyword.take(@keys)
  end

  defp put_config(config) do
    put = fn({key, value}) when key in @keys ->
      Application.put_env(:ehelper, key, value)
    end
    Enum.each(config, put)
  end


  defp merge_option(:doc_helpers, old, new) when is_list(new), do: Keyword.merge(old,new)

  defp merge_option(k, _old, new) do
    raise ArgumentError, "invalid configuration or value for pair #{inspect k} - #{inspect new}"
  end

  @doc """
  Returns the current configuration of the e command helpers.
  """
  def configuration() do
    Keyword.merge(default_config(), get_config(), &merge_option/3)
  end

  defp default_config() do
    Enum.map(@keys, &{&1, default_option(&1)})
  end

  defp default_option(:doc_helpers), do: [{:find, :first},{:helpers, [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.PrintUrl]}]

  def doc_helpers(key) do
    d_helpers = get(:doc_helpers)
    case key do
      :find    -> d_helpers[key]
      :helpers -> d_helpers[key]
      _        -> raise ArgumentError, "invalid key #{inspect key}"
    end
  end

  defp get(key) do
    case Application.fetch_env(:ehelper, key) do
      {:ok, value} ->
        value
      :error ->
        default_option(key)
    end
  end

end
