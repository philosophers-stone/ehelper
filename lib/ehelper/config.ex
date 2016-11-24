defmodule Ehelper.Config do
  @moduledoc false

  @table IEx.Config
  @agent IEx.Config

  @keys [
    :doc_helpers]


  def configure(options) do
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
