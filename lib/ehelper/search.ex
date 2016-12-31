# Convenience helpers for showing docs
defmodule Ehelper.Search do
  @moduledoc """
  Create an Ehelper.e command for access external documentation from the
  iex shell. Shadows the behaviour of IEx.Introspection.h

  """

  import IEx, only: [dont_display_result: 0]

  @doc """
  Prints the documentation for the given module.
  """
  def e(module) when is_atom(module) do
    case Code.ensure_loaded(module) do
      {:module, _} ->
        {find, helpers} = get_helper_config
        Enum.map(get_docs(find, helpers,[module]),
          fn {status, doc_list} -> display_doc_list(status, doc_list) end)
      {:error, reason} ->
        puts_error("Could not load module #{inspect module}, got: #{reason}")
    end

    dont_display_result
  end

  def e(_) do
    puts_error("Invalid arguments for h helper")

    dont_display_result
  end

  @doc """
  Prints the documentation for the given function
  with any arity in the list of modules or a single module.

  Accepts either a single module name, or a list of modules.
  The list version is used to find functions that are either
  iex commands or kernel functions.
  """
  def e(modules, function) when is_list(modules) and is_atom(function) do
    helpers = Ehelper.Config.doc_helpers(:helpers)

    modules
    |> Enum.find_value({nil, "No documentation for #{to_string(function)} was found"},
        fn(module) ->
          Enum.find_value(helpers, fn(helper) -> found_help(helper.documentation(module, function)) end)
        end)
    |> display_list_result

    dont_display_result
  end

  def e(module, function) when is_atom(module) and is_atom(function) do
    {find, helpers} = get_helper_config
    Enum.map(get_docs(find, helpers, [module, function]),
             fn {status, doc_list} -> display_doc_list(status, doc_list) end)

    dont_display_result
  end

  @doc """
  Prints the documentation for the given function
  and arity in the list of modules or a single module.

  Accepts either a single module name, or a list of modules.
  The list version is used to find functions that are either
  iex commands or kernel functions.
  """
  def e(modules, function, arity) when is_list(modules) and is_atom(function) and is_integer(arity) do
    helpers = Ehelper.Config.doc_helpers(:helpers)

    modules
    |> Enum.find_value({nil, "No documentation for #{to_string(function)}/#{inspect(arity)} was found"},
        fn(module) ->
          Enum.find_value(helpers, fn(helper) -> found_help(helper.documentation(module, function, arity)) end)
        end)
    |> display_list_result

    dont_display_result
  end

  def e(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity) do
    {find, helpers} = get_helper_config
    Enum.map(get_docs(find, helpers, [module, function, arity]),
             fn {status, doc_list} -> display_doc_list(status, doc_list) end)

    dont_display_result
  end

  defp get_docs(:first, helpers, args) do
    helpers
    |> Enum.find_value(fn(helper) -> can_help(Kernel.apply(helper, :documentation, args)) end)
    |> check_nil_doclist(args)
  end

  defp get_docs(_, helpers, args) do
    helpers
    |> Enum.map(fn(helper) -> Kernel.apply(helper, :documentation, args) end)
    |> Enum.filter(fn({status, _doc_list}) -> status != :unknown end)
  end

  defp get_helper_config do
    {Ehelper.Config.doc_helpers(:find), Ehelper.Config.doc_helpers(:helpers)}
  end

  defp check_nil_doclist(nil, args) do
    [Kernel.apply(Ehelper.DocHelp, :not_found_doc_return, args)]
  end

  defp check_nil_doclist(doc_list, _args) do
    doc_list
  end

  defp can_help({:unknown, _doc_list}), do:  nil
  defp can_help({:found, doc_list}), do: [{:found, doc_list}]
  defp can_help({:not_found, doc_list}), do:  [{:not_found, doc_list}]

  defp found_help({:found, doc_list}), do: {:found, doc_list}
  defp found_help(_), do: nil

  defp display_list_result({:found, doc_list}), do: display_doc_list(:found, doc_list)
  defp display_list_result({nil, message}), do: print_error(nil, message)

  defp display_doc_list(status, doc_list) do
    case status do
      :found ->
        Enum.map(doc_list, fn({header, doc}) -> print_doc(header, doc) end)
      :not_found ->
        Enum.map(doc_list, fn({header, doc}) -> print_error(header, doc) end)
    end
  end

  defp print_error(_heading, doc) do
    doc = doc || ""
    puts_error(doc)
  end

  defp print_doc(heading, doc) do
    doc = doc || ""
    if opts = IEx.Config.ansi_docs do
      IO.ANSI.Docs.print_heading(heading, opts)
      IO.ANSI.Docs.print(doc, opts)
    else
      IO.puts "* #{heading}\n"
      IO.puts doc
    end
  end

  def puts_info(string) do
    IO.puts IEx.color(:eval_info, string)
  end

  def puts_error(string) do
    IO.puts IEx.color(:eval_error, string)
  end

end
