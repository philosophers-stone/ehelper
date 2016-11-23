defmodule Ehelper.DocHelp.PrintUrlTest do
  use ExUnit.Case
  doctest Ehelper.DocHelp.PrintUrl

  test "Elixir Core url" do
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(Atom)
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(Atom, :to_string)
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(Atom, :to_string, 1)
  end

  test "Elixir url" do
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(Ecto.Date)
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(Ecto.Date, :from_erl)
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(Ecto.Date, :from_erl, 1)
  end

  test "Erlang url" do
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(:erlang)
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(:erlang, :binary_to_integer)
    assert {:found, _doc_list} = Ehelper.DocHelp.PrintUrl.documentation(:erlang, :binary_to_integer, 1)
  end

end
