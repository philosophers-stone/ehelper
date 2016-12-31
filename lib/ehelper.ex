# Convenience helpers for showing docs
defmodule Ehelper do
    @moduledoc """
    Create an Ehelper.e command for accessing external documentation from the
    iex shell. Shadows the behaviour of IEx.h and provides a way to add
    additional backends for searching Erlang man pages. Backends that come
    with the Ehelper module include:

    * Ehelper.DocHelp.Erlman   - search installed erlang man pages.
    * Ehelper.DocHelp.PrintUrl - prints the most likely url for the module.
    * Ehelper.DocHelp.DashDoc  - searches the Dash documentation tool for the module.
    * Ehelper.DocHelp.PrintUrl - uses the open command on OS/X to open url in the default browser.

    """

    import IEx, only: [dont_display_result: 0]

    @doc """
    Prints the documentation for `Ehelper` and the current
    list of enabled helpers.
    """
    def e() do
      Ehelper.Search.e(Ehelper)
      Ehelper.Search.puts_info "Current Helper list #{inspect(Ehelper.Config.doc_helpers(:helpers))}"
      dont_display_result
    end

    @doc """
    Searchs the documentation for the given module
    or for the given function/arity pair.

    ## Examples

        e(:erlang)
        #=> Searchs documentation for :erlang

    It also accepts functions in the format `fun/arity`
    and `module.fun/arity`, for example:

        e :erlang.abs/1
        e Enum.all?/2
        e Enum.all?

    """
    @h_modules [__MODULE__, Kernel, Kernel.SpecialForms]

    defmacro e(term)
    defmacro e({:/, _, [call, arity]} = term) do
      args =
        case Macro.decompose_call(call) do
          {_mod, :__info__, []} when arity == 1 ->
            [Module, :__info__, 1]
          {mod, fun, []} ->
            [mod, fun, arity]
          {fun, []} ->
            [@h_modules, fun, arity]
          _ ->
            [term]
        end

      quote do
        Ehelper.Search.e(unquote_splicing(args))
      end
    end

    defmacro e(call) do
      args =
        case Macro.decompose_call(call) do
          {_mod, :__info__, []} ->
            [Module, :__info__, 1]
          {mod, fun, []} ->
            [mod, fun]
          {fun, []} ->
            [@h_modules, fun]
          _ ->
            [call]
        end

      quote do
        Ehelper.Search.e(unquote_splicing(args))
      end
    end

end
