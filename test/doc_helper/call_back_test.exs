Code.require_file "../test_helper.exs", __DIR__

defmodule Ehelper.DocHelp.CallBackTest do
  use ExUnit.Case

  test "documentation/1 for Elixir module" do
    assert {:not_found, _} = Ehelper.DocHelp.CallBack.documentation(Ehelper.Case)
    assert {:found, _} = Ehelper.DocHelp.CallBack.documentation(Tuple)
  end

  test "documentation/1 for Erlang module" do
    assert {:unknown, _} = Ehelper.DocHelp.CallBack.documentation(:erlang)
  end

  test "documentation/2 for Elixir module function" do
    assert {:found, _} = Ehelper.DocHelp.CallBack.documentation(Ehelper.DocHelp, :documentation)
  end

  test "documentation/3 for Elixir module function arity" do
    assert {:not_found, _} = Ehelper.DocHelp.CallBack.documentation(Ehelper.DocHelp, :documentation, 4)
    assert {:found, _} = Ehelper.DocHelp.CallBack.documentation(Ehelper.DocHelp, :documentation, 2)
  end

end
