defmodule GenTcpAndRpcTest do
  use ExUnit.Case
  doctest GenTcpAndRpc

  test "greets the world" do
    assert GenTcpAndRpc.hello() == :world
  end
end
