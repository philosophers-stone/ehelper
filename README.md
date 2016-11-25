Ehelper
=============

** Provides a command "e" for accessing external documentation from the Iex shell**

## Motivation

Eventually in any Elixir project you will need to access some Erlang apis.
This project started as way to extend the h command in iex to access
documentation on Erlang functions from the man pages installed on with
Erlang on most unix installations. It has grown since then as a way to
provide a dynamic backend to internal documentation within iex.

## Documentation

The `Ehelper` defines a behaviour and plugin scheme that can
access documentation in many different ways. Currently it comes with
helpers that can open the documentation for functions in either Dash,
a web browser or provide inline documentation for Erlang functions.

## Examples

    iex> import Ehelper
    iex> e Atom
                                      Atom
    Convenience functions for working with atoms.
    See also Kernel.is_atom/1.

    iex> Ehelper.Config.configure(doc_helpers: [helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman]])
    iex>  e :crypto.stop
                              :crypto.stop()
    stop() -> ok
    Equivalent to application:stop(crypto).

    iex> Ehelper.Config.configure(doc_helpers: [helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.PrintUrl]])
    iex(13)> e :erlang.xor/1

                                    :erlang

    Documentation can be found at http://www.erlang.org/doc/man/erlang.html#xor-1

Note: The Erlman man page parser is still a work in progress and still has many edge
cases to work through. If you are using the Erlman helper and get No documentation
found, do not take that as gospel.

## Using Ehelper

The current list of DocHelpers:

  * Ehelper.DocHelp.Elixir
    - Duplicates current h command for Elixir modules.
  * Ehelper.DocHelp.Erlman
    - Duplicate h command for Erlang functions by parsing man pages.
  * Ehelper.DocHelp.PrintUrl
    - Print a url for either Elixir or Erlang functions, is hex aware, but
      assumes all Erlang functions are at erlang.org.
  * Ehelper.DocHelp.OpenUrl
    - Calls system open on the output of PrintUrl, only tested on OS X.
  * Ehelper.DocHelp.DashDoc
    - Open Dash to documentation for function, is currently not hex aware.

The current default helpers are `[Ehelper.DocHelp.Elixir, Ehelper.DocHelp.PrintUrl]`
In order to use Ehelper from within iex, you must start iex with the location of all
the Ehelper BEAM files in it's code path. You can then use import Ehelper at the
iex prompt or in your .iex files.

## TODO

  * Document all the Helpers
  * Automate the install procedure
  * Fix Erlman Edge cases
  * Figure out how to open URL's on Windows and Linux.

## Installation

There is a simple install script install.sh that will install the compiled BEAM
files into `~/.iex/ebin` and a `sample.iex.exs` file that configures the e command
to use Erlang man pages. You will need to either call `iex` with the `--pa` or `--pz`
options or `env ERL_LIBS=~/.iex iex`.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ehelper` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ehelper, "~> 0.1.0"}]
    end
    ```

  2. Ensure `ehelper` is started before your application:

    ```elixir
    def application do
      [applications: [:ehelper]]
    end
    ```
