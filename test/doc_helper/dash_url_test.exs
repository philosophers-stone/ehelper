defmodule Ehelper.DocHelp.DashUrlTest do
  use ExUnit.Case
  doctest Ehelper.DocHelp.DashUrl

  test "Elixir Core url" do
    assert Ehelper.DocHelp.DashUrl.url(Atom) == "dash://elixir:Atom"
    assert Ehelper.DocHelp.DashUrl.url(Atom, :to_string) == "dash://elixir:Atom.to_string"
    assert Ehelper.DocHelp.DashUrl.url(Atom, :to_string, 1) == "dash://elixir:Atom.to_string"
  end

  test "Elixir url" do
    assert Ehelper.DocHelp.DashUrl.url(Ecto.Date) == "dash://hex:Ecto.Date"
    assert Ehelper.DocHelp.DashUrl.url(Ecto.Date, :from_erl) == "dash://hex:Ecto.Date.from_erl"
    assert Ehelper.DocHelp.DashUrl.url(Ecto.Date, :from_erl, 1) == "dash://hex:Ecto.Date.from_erl"
  end

  test "Erlang url" do
    assert Ehelper.DocHelp.DashUrl.url(:erlang) == "dash://erl:erlang"
    assert Ehelper.DocHelp.DashUrl.url(:erlang, :binary_to_integer) == "dash://erl:erlang:binary_to_integer"
    assert Ehelper.DocHelp.DashUrl.url(:erlang, :binary_to_integer, 1) == "dash://erl:erlang:binary_to_integer"
  end

end
