defmodule Ehelper.ErlmanNroff do
  @moduledoc """
  This module is meant to parse just enough nroff to convert the erlang man pages
  to markdown format compatible with Code.get_docs in elixir. It relies heavily
  on the fact that Erlang man pages have a standard conversion from the original
  XML version of the documentation.
  """
  @man_macros ~W(.TH .SH .SS .TP .LP .RS .RE .nf .fi .br .B )


  # This is serious cheating, we should really implement the nroff state machine.
  # But since that is mostly about indentation, see how far we can get.
  @doc """
  Make a lot of assumptions about the structure of Erlang man pages and
  translate the nroff in them to Markdown syntax used in Elixir docs.
  """
  def to_markdown(string) do
    String.split(string, "\n") |>
    Enum.map_reduce("", fn(line,prepend) -> translate(line,prepend) end) |>
    elem(0) |>
    Enum.join
  end

  # Return { line, prepend }
  @doc """
  A weak attempt at emulating the nroff state machine by translating the
  current line and transforming a prepend that is applied before each
  according to the current nroff macro. Ignores a lot of what nroff does.
  """
  def translate(line, prepend) do
    case String.starts_with?(line, @man_macros) do
      true  -> next_macro(line,prepend)
      false -> { prepend<>swap_inline(line), prepend}
    end
  end

  @doc """
  Replace inline nroff macros with markdown tags.
  Currently maps both Bold and Italice to backquote.
  """
  def swap_inline(line) do
    newline = String.replace(line,"\\fI","`") |>
              String.replace("\\fB","`") |>
              String.replace("\\fR","`") |>
              String.replace("\\&","")
    newline<>"\n"
  end


  def get_macro(line) do
    [ macro | line ] = String.split(line,~r/\s/, parts: 2 )
    case line do
      [] -> {macro, "" }
      _  -> {macro, Enum.at(line,0)}
    end
  end

  @doc """
  Attempt to emulate the nroff state machine as much as possible by
  returning both the line and a prepend expression for the next line.
  """
  def next_macro(line, prepend ) do
    { macro, line } = get_macro(line)
    { newline, newprepend } = swap_macro(macro, line)
    { prepend<>swap_inline(newline), newprepend }
  end

  # Man page title
  def swap_macro(".TH", line) do
    { "# "<>line<>"\n", "" }
  end

  # Heading
  def swap_macro(".SH", line) do
    { "## "<>line<>"\n", "" }
  end

  # Sub Heading
  def swap_macro(".SS", line) do
    { "### "<>line<>"\n", "" }
  end

  # Indented paragraph
  def swap_macro(".TP", _count) do
    { "" , "" }
  end

  # New paragraph
  def swap_macro(".LP", line) do
    { "\n"<>line , "" }
  end

  #  Indent count.to_i spaces, in general this is not
  #  translatable to markdown w/o context ( i.e. is list?)
  def swap_macro(".RS", _count) do
    { "", "" }
  end

  # Remove indentation.
  def swap_macro(".RE", _line) do
    { "", "" }
  end

  #Turn off text fill, largely used to translate <code> blocks
  def swap_macro(".nf", line) do
   { line , "    " }
  end

  # Turn text fill on, Treat as </code>
  def swap_macro(".fi", line) do
   { line, "" }
  end

  # Erlman translates all non-function \n.B\nstring into \n.SS string
  def swap_macro(".B", line) do
    { line , "\n### " }
  end

  # Line break
  def swap_macro(".br", line) do
   { "\n"<>line , "" }
  end

end
