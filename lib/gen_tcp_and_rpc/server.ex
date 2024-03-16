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
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: 4, active:
                                            true, reuseaddr: true])
    Logger.info("Server: listen socket #{inspect(socket)}.")
    spawn_link(fn -> acceptor(socket) end)
    {:ok, state}
  end

  @impl true
  def handle_info({:tcp, socket, <<msg::binary>>}, state) do
    Logger.info "Server: received msg from client: #{msg}"
    Logger.info "Server: sending it back to client"
    :ok = :gen_tcp.send(socket, <<msg::binary>>)
    {:noreply, state}
  end


  @impl true
  def handle_info({:tcp_closed, socket}, state) do
    Logger.info "Server: received tcp_closed from client"
    new_state = Map.delete(state, :socket)
    {:noreply, new_state}
  end

  @impl true
  def handle_info({:update_client_socket, socket}, state) do
    {:noreply, %{state | socket: socket}}
  end

  @impl true
  def handle_info(:terminate, state) do
    Logger.info("Server: received terminate message.")
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.info "Server: received unexpected msg from client: #{msg}"
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
    {:ok, client_socket} = :gen_tcp.accept(socket)
    Logger.info("Server: tcp_server: #{inspect(Process.whereis(:tcp_server))}.")
    :ok = :gen_tcp.controlling_process(client_socket,
                                       Process.whereis(:tcp_server))
    Logger.info "Server: Client connected successfully"
    send(Process.whereis(:tcp_server), {:update_client_socket, client_socket})
    acceptor(socket)
  end
end
