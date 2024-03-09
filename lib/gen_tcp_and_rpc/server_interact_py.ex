defmodule GenTcpAndRpc.ServerInteracPy do
  require Logger

  @port 8080

  def start_server() do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: 0, active:
                                            false, reuseaddr: true])
    Logger.info("Server: listen socket #{inspect(socket)}.")
    acceptor(socket)
  end

  defp acceptor(socket) do
    {:ok, s} = :gen_tcp.accept(socket)
    Logger.info "Server: Client connected successfully"
    :gen_tcp.send(s, "Server accept connection")
    spawn_link(fn -> loop_receive(s) end)
    # loop acceptor if there are many clients
    acceptor(socket)
  end

  defp loop_receive(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, chunk} ->
        # data = IEx.Info.info(chunk)
        # Logger.info("Server got check data: #{inspect(data)}")
        Logger.info("Server receive: #{inspect(chunk)}")
        loop_receive(socket)
      {:error, reason} ->
        IO.puts("Server closed socket with reason: #{inspect(reason)}")
        :gen_tcp.close(socket)
    end
  end
end
