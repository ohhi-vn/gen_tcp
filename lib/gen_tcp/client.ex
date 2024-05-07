defmodule GenTcp.Client do
  use GenServer
  require Logger

  @port 8080
  @host :localhost

  ## API
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{socket: nil}, name: :tcp_client)
  end

  def send_to_server(msg) do
    send(Process.whereis(:tcp_client), {:send_to_server, msg})
  end

  def close_socket() do
    send(Process.whereis(:tcp_client), :close_socket)
  end

  ## Callback
  @impl true
  def init(state) do
    Logger.info "Client: connecting to #{@host}"

    case :gen_tcp.connect(@host, @port, [:binary, packet: 4, active: true, reuseaddr: true]) do
      {:ok, socket} ->
        Logger.info "Client: connected successfully to #{@host} !"
        {:ok, %{state | socket: socket}}
      {:error, reason} ->
        Logger.info "Client: disconnected: #{reason}"
        {:stop, :normal}
    end
  end

  @impl true
  def handle_info({:tcp, _socket, <<msg::binary>>}, state) do
    Logger.info "Client: received msg from server: #{msg}"
    {:noreply, state}
  end

  @impl true
  def handle_info({:send_to_server, msg}, %{socket: socket} = state) do
    Logger.info("Client: send to server a message: #{msg}.")
    :gen_tcp.send(socket, <<msg::binary>>)
    {:noreply, state}
  end

  @impl true
  def handle_info(:close_socket, %{socket: socket} = state) do
    Logger.info("Client: close socket.")
    :gen_tcp.close(socket)
    new_state = Map.delete(state, :socket)
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:terminate, state) do
    Logger.info("Client: received terminate message.")
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

end
