defmodule Ehelper.DocHelp.ElixirUrlTest do
  use ExUnit.Case
  doctest Ehelper.DocHelp.ElixirUrl

  test "Elixir url" do
    assert Ehelper.DocHelp.ElixirUrl.url(Atom) == "http://elixir-lang.org/docs/stable/elixir/Atom.html"
    assert Ehelper.DocHelp.ElixirUrl.url(Atom, :to_string) == "http://elixir-lang.org/docs/stable/elixir/Atom.html#functions"
    assert Ehelper.DocHelp.ElixirUrl.url(Atom, :to_string, 1) == "http://elixir-lang.org/docs/stable/elixir/Atom.html#to_string/1"
  end

  test "Erlang url" do
    assert Ehelper.DocHelp.ElixirUrl.url(:erlang) == nil
    assert Ehelper.DocHelp.ElixirUrl.url(:erlang, :binary_to_integer) == nil
    assert Ehelper.DocHelp.ElixirUrl.url(:erlang, :binary_to_integer, 1) == nil
  end

  test "Elixir url for hex project" do
    assert Ehelper.DocHelp.ElixirUrl.url(Ecto) == "http://hexdocs.pm/ecto/Ecto.html"
    assert Ehelper.DocHelp.ElixirUrl.url(Ecto.Date, :cast) == "http://hexdocs.pm/ecto/Ecto.Date.html#functions"
    assert Ehelper.DocHelp.ElixirUrl.url(Ecto.Date, :cast, 1) == "http://hexdocs.pm/ecto/Ecto.Date.html#cast/1"
  end

  test "Elixir url for Mix" do
    assert Ehelper.DocHelp.ElixirUrl.url(Mix) == "http://elixir-lang.org/docs/stable/mix/Mix.html"
  end

  test "Elixir url for ExUnit" do
    assert Ehelper.DocHelp.ElixirUrl.url(ExUnit) == "http://elixir-lang.org/docs/stable/ex_unit/ExUnit.html"
  end

end
