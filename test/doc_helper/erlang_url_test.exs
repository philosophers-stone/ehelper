defmodule Ehelper.DocHelp.ErlangUrlTest do
  use ExUnit.Case
  doctest Ehelper.DocHelp.ErlangUrl

  test "Elixir url" do
    assert Ehelper.DocHelp.ErlangUrl.url(Atom) == nil
    assert Ehelper.DocHelp.ErlangUrl.url(Atom, :to_string) == nil
    assert Ehelper.DocHelp.ErlangUrl.url(Atom, :to_string, 1) == nil
  end

  test "Erlang url" do
    assert Ehelper.DocHelp.ErlangUrl.url(:erlang) == "http://www.erlang.org/doc/man/erlang.html"
    assert Ehelper.DocHelp.ErlangUrl.url(:erlang, :binary_to_integer) == "http://www.erlang.org/doc/man/erlang.html"
    assert Ehelper.DocHelp.ErlangUrl.url(:erlang, :binary_to_integer, 1) == "http://www.erlang.org/doc/man/erlang.html#binary_to_integer-1"
  end

end
