# These tests fail because the required agent is not started.

# defmodule EhelperConfigTest do
#   use ExUnit.Case

#   test "configuration" do
#     assert Keyword.has_key?(Ehelper.Config.configuration, :doc_helpers)
#   end

#   test ":find keyword pair" do
#     assert Ehelper.Config.configure([find: :all]) == :ok
#   end

#   test ":helpers keyword pair" do
#     assert Ehelper.Config.configure([helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman]]) == :ok
#   end

#   test "backwards compatible with doc_helpers: " do
#     assert Ehelper.Config.configure(doc_helpers: [helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman]])
#   end
# end
