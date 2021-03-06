defmodule Ehelper.DocHelp.Erlman do
  @moduledoc """
  This module uses Erlman.get_docs to duplicate the iex h
  command for erlang functions using the new dynamic backend Behaviour.
  """

  def documentation(module) do
    case is_elixir?(module) do
      false -> get_doc(module)
      _  -> { :unknown, [{inspect(module), ""}]}
    end
  end

  def documentation(module, function) do
    case is_elixir?(module) do
      false -> get_doc(module, function)
      _  -> { :unknown, [{inspect( module), ""}]}
    end
  end

  def documentation(module, function, arity) do
    case is_elixir?(module) do
      false -> get_doc(module, function, arity)
      _  -> { :unknown, [{inspect( module), ""}]}
    end
  end


  def is_elixir?(module) do
    Atom.to_string(module) |>
    String.starts_with?("Elixir.")
  end

  # Fix this to return unknown for function versions when we know
  # the function exists, but we can't parse it in the man page.

  def get_doc(module) when is_atom(module) do
    { _line, doc } = Ehelper.Erlman.get_docs(module, :moduledoc)
    case doc do
      nil -> { :not_found, [{ inspect(module), "No moduledocs found\n"}] }
      _   -> { :found, [{ inspect(module), doc}] }
    end
  end

  def get_doc(module, function) when is_atom(module) and is_atom(function) do
    docs = Ehelper.Erlman.get_docs(module, :docs)
    case docs do
      nil -> { :not_found, [{ "#{inspect module}.#{function}", nodoc(module, function)}] }
      _   -> find_doc(docs, module, function)
    end
  end

  def get_doc(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity) do
    docs = Ehelper.Erlman.get_docs(module, :docs)
    case docs do
      nil -> { :not_found, [{ "#{inspect module}.#{function}/#{arity}",  nodoc(module, function, arity)}] }
      _   -> find_doc(docs, module, function, arity)
    end
  end

  #  match on all arities.
  def find_doc(docs, module ,function) do
    doc_list = docs |> Enum.filter( fn(x) -> match_function(x, function) end )
    case doc_list do
      [] -> maybe(module, function)
      _  -> { :found, get_docstrings(doc_list, module) }
    end
  end

  #  match on all arities.
  def find_doc(docs, module ,function, arity ) do
    doc_list = docs |> Enum.filter( fn(x) -> match_function(x, function, arity) end )
    case doc_list do
      [] -> maybe(module, function)
      _  -> { :found, get_docstrings(doc_list, module) }
    end
  end

  def maybe(module, function) do
    case exports?(module, function) do
      true -> { :unknown, [{ "#{inspect module}.#{function}", "#{module} exports #{function}, no documentation found."}] }
      _    -> { :not_found, [{ "#{inspect module}.#{function}", "#{module} does not export the function #{function}.\n"}] }
    end
  end

  # return true if the module exports that function
  defp exports?(module, function) do
    Kernel.apply(module, :module_info, [:exports])
    |> Keyword.has_key?(function)
  end

  defp get_docstrings(doc_list, module) do
    for {{func, _arity}, _line, _type, args, docstring } <- doc_list do
      {":#{to_string(module)}."<>"#{to_string(func)}"<>stringify_args(args), docstring }
    end
  end

  # Turn this [{:string, [], nil}, {:char, [], nil}] into this (string, char)
  defp stringify_args(args) do
    inner = args |> Enum.map(fn(tp) -> format_doc_arg(tp) end ) |> Enum.join(", ")
    "("<>inner<>")"
  end

  defp format_doc_arg({:\\, _, [left, right]}) do
    format_doc_arg(left) <> " \\\\ " <> Macro.to_string(right)
  end

  defp format_doc_arg({var, _, _}) do
    var
    |> Atom.to_string
    |> String.downcase
  end

  defp find_default_doc(doc, function, minimum) do
    case elem(doc, 0) do
      {^function, max} when max > minimum ->
        defaults = Enum.count elem(doc, 3), &match?({:\\, _, _}, &1)
        minimum + defaults >= max
      _ ->
        false
    end
  end

  # Not happy about magic numbers in elem.
  defp match_function(docstring, function) do
    {func, _arity} = elem(docstring,0)
    function == func
  end

  # Not happy about magic numbers in elem.
  # To duplicate current iex behaviour this should
  # match foo/1 when foo/2 has a default second arg.
  defp match_function(docstring, function, arity) do
    case {function, arity} == elem(docstring,0) do
      true  -> true
      false -> find_default_doc(docstring, function, arity)
    end
  end

  defp nodoc(:erlang, function) do
"""
No documentation for :erlang.#{function} found in the :erlang man page
Try the Erlang expression documentation
http://erlang.org/doc/reference_manual/expressions.html
"""
  end

  defp nodoc(module, function) do
    "No documentation for #{module}.#{function} found in the #{module} man page\n"
  end

  defp nodoc(:erlang, function, arity) do
"""
No documentation for :erlang.#{function}/#{arity} found in the :erlang man page
Try the Erlang expression documentation
http://erlang.org/doc/reference_manual/expressions.html
"""
  end

  defp nodoc(module, function, arity) do
    "No documentation for #{module}.#{function}/#{arity} found in the #{module} man page\n"
  end


end
