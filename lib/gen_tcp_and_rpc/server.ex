defmodule GenTcpAndRpc.Server do
  use GenServer
  require Logger

  @port 8080

  ## API
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{socket: nil}, name: :tcp_server)
  end

  ## Callback
  @impl true
  def init(state) do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: :line, active:
                                            true, reuseaddr: true])
    Logger.info("Server: listen socket #{inspect(socket)}.")
    spawn_link(fn -> acceptor(socket) end)
    {:ok, %{state | socket: socket}}
  end

  @impl true
  def handle_info({:tcp, socket, data}, state) do
    Logger.info "Server: received #{data}"
    Logger.info "Server: sending it back"
    :ok = :gen_tcp.send(socket, data)
    {:noreply, state}
  end

  @impl true
  def handle_info(:terminate, state) do
    Logger.info("Server: received terminate message.")
    {:noreply, state}
  end

  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def terminate(_reason, _) do
    :ok
  end

  defp acceptor(socket) do
    {:ok, _client} = :gen_tcp.accept(socket)
    Logger.info "Server: Client connected successfully"
    acceptor(socket)
  end
end
