defmodule Ehelper.ErlmanNroffTest do
  use ExUnit.Case

  @tc_str "tc(Module, Function, Arguments) -> {Time, Value}\n.br\n.fi\n.br\n.RS\n.LP\nTypes:\n\n.RS 3\nModule = module()\n.br\nFunction = atom()\n.br\nArguments = [term()]\n.br\nTime = integer()\n.br\n.RS 2\nIn microseconds\n.RE\nValue = term()\n.br\n.RE\n.RE\n.RS\n.LP\n\n.RS 2\n.TP 2\n.SS \\fItc/3\\fR\\&:\nEvaluates \\fIapply(Module, Function, Arguments)\\fR\\& and measures the elapsed real time as reported by \\fIos:timestamp/0\\fR\\&\\&. Returns \\fI{Time, Value}\\fR\\&, where \\fITime\\fR\\& is the elapsed real time in \\fImicroseconds\\fR\\&, and \\fIValue\\fR\\& is what is returned from the apply\\&.\n.TP 2\n.SS \\fItc/2\\fR\\&:\nEvaluates \\fIapply(Fun, Arguments)\\fR\\&\\&. Otherwise works like \\fItc/3\\fR\\&\\&.\n.TP 2\n.SS \\fItc/1\\fR\\&:\nEvaluates \\fIFun()\\fR\\&\\&. Otherwise works like \\fItc/2\\fR\\&\\&.\n.RE \n.RE\n.LP\n.nf\n"
  test "Can swap inline " do
    assert Ehelper.ErlmanNroff.swap_inline("\\fB") == "`\n"
  end

  test "Translate inline after .SS macro" do
    refute String.contains?(Ehelper.ErlmanNroff.to_markdown(@tc_str),["\\fR","\\fI"])
  end

end
