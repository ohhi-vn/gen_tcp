defmodule GenTcpAndRpc.Node1 do
  require Logger

  def call_to_node2 do
      result = :rpc.call(:b@localhost, :"Elixir.GenTcpAndRpc.Node2",
                              :do_somethings, ["hello", Node.self()])
      Logger.info("result: #{result}")
  end

end
