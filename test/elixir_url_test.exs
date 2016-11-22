defmodule ElixirUrlTest do
  use ExUnit.Case
  doctest ElixirUrl

  test "Elixir url" do
    assert ElixirUrl.url(Atom) == "http://elixir-lang.org/docs/stable/elixir/Atom.html"
    assert ElixirUrl.url(Atom, :to_string) == "http://elixir-lang.org/docs/stable/elixir/Atom.html#functions"
    assert ElixirUrl.url(Atom, :to_string, 1) == "http://elixir-lang.org/docs/stable/elixir/Atom.html#to_string/1"
  end

  test "Erlang url" do
    assert ElixirUrl.url(:erlang) == nil
    assert ElixirUrl.url(:erlang, :binary_to_integer) == nil
    assert ElixirUrl.url(:erlang, :binary_to_integer, 1) == nil
  end

  test "Elixir url for hex project" do
    assert ElixirUrl.url(Ecto) == "http://hexdocs.pm/ecto/Ecto.html"
    assert ElixirUrl.url(Ecto.Date, :cast) == "http://hexdocs.pm/ecto/Ecto.Date.html#functions"
    assert ElixirUrl.url(Ecto.Date, :cast, 1) == "http://hexdocs.pm/ecto/Ecto.Date.html#cast/1"
  end

  test "Elixir url for Mix" do
    assert ElixirUrl.url(Mix) == "http://elixir-lang.org/docs/stable/mix/Mix.html"
  end

  test "Elixir url for ExUnit" do
    assert ElixirUrl.url(ExUnit) == "http://elixir-lang.org/docs/stable/ex_unit/ExUnit.html"
  end

end
