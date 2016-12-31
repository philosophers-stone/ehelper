
import Ehelper
# This provides an e command that mirrors the h command and search erlang man pages if they are
# installed.
Ehelper.Config.configure([helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman]])
#
# Some other possible configurations.
#
# Configures the e command to run all the doc_helpers, not just the first that claims to
# have documentation. Useful with the printurl and openurl doc helpers.
# This will also print the url for the online version of the documentation.
# Ehelper.Config.configure([find: :all])
# Ehelper.Config.configure([helpers: [Ehelper.DocHelp.Elixir, Ehelper.DocHelp.Erlman, Ehelper.DocHelp.PrintUrl]])
#
# If you are on OS X, these helpers will open the documentation in Dash.
# Ehelper.Config.configure([helpers: [ Ehelper.DocHelp.DashDoc]])
