defmodule GenTcpAndRpc.Node2 do
  require Logger

  def do_somethings(msg, node) do
    Logger.info("receive message #{msg} from node #{node}")
    :ok_received
  end

  def do_somethings() do
    Logger.info("receive message")
    :ok_received
  end

end
