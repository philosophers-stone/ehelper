defmodule EhelperTest do
  use ExUnit.Case
  doctest Ehelper

  test "display Elixir moduledoc" do
    assert Ehelper.e(Atom)
  end

  test "display Elixir function" do
    assert Ehelper.e(Atom, :to_string)
  end

  test "display Elixir function arity" do
    assert Ehelper.e(Atom, :to_string, 1)
  end
end
