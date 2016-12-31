#!/bin/sh

mkdir -p ~/.iex/ebin
env MIX_ENV=prod mix compile
cp _build/prod/lib/ehelper/ebin/* ~/.iex/ebin
echo "Set the ENV ERL_LIBS=~/.iex and run iex or use --pa option"
echo "To install sample configuration"
echo "cp sample.iex.exs ~/.iex/exs"
