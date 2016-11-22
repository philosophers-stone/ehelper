defmodule ErlangUrlTest do
  use ExUnit.Case
  doctest ErlangUrl

  test "Elixir url" do
    assert ErlangUrl.url(Atom) == nil
    assert ErlangUrl.url(Atom, :to_string) == nil
    assert ErlangUrl.url(Atom, :to_string, 1) == nil
  end

  test "Erlang url" do
    assert ErlangUrl.url(:erlang) == "http://www.erlang.org/doc/man/erlang.html"
    assert ErlangUrl.url(:erlang, :binary_to_integer) == "http://www.erlang.org/doc/man/erlang.html"
    assert ErlangUrl.url(:erlang, :binary_to_integer, 1) == "http://www.erlang.org/doc/man/erlang.html#binary_to_integer-1"
  end

end
