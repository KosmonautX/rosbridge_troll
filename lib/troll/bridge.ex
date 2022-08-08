defmodule Troll.Bridge do
  use GenServer

  @timeout 10000

  def start_link(args) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, args, [{:name, __MODULE__}])
  end

  def init(arguments) do
    IO.inspect(arguments)
    {:ok, nil, {:continue, :connect}}
  end

  def handle_continue(:connect, _state) do
    connect_opts = %{
      connect_timeout: 60000,
      retry: 10,
      retry_timeout: 300,
      transport: :tcp,
      # Specify :http or :http2 to tell the server what you'd like. Support for http 2  is not great generally
      protocols: [:http],
      # Tell the server which version to use. Note: this is an atom.
      http_opts: %{version: :"HTTP/1.1"}
    }

    {:ok, conn} = :gun.open('localhost', 9090, connect_opts)
    {:ok, :http} = :gun.await_up(conn, 1000)
    ref = :gun.ws_upgrade(conn, '/')
    {:ok, {["websocket"], _header}} = await_upgrade(conn, ref)
    {:noreply, %{conn: conn, ref: ref}}
  end

  def handle_info(:stop, conn) do
    IO.puts("sayonara")
    {:stop, :normal, conn}
  end

  def terminate(reason, conn) do
    _pid = spawn(fn -> :ok = :gun.close(conn) end)
    {:ok, reason}
  end

  def handle_info({:gun_ws, _conn, _stream_ref, {:text, frame}}, state) do
    {:ok, message} = Jason.decode(frame)
    # {:ok, {@channel, ^message}} = PubSub.broadcast_from(@channel, message)
    {:noreply, state}
  end

  def handle_call({:ws_send, frame}, _from, state) do
    {:reply, :gun.ws_send(state.conn, state.ref, {:text, frame |> Jason.encode!()}), state}
  end

  def handle_call({:op_send, operation}, _from, state) do
    IO.inspect(state)
    {:reply, :gun.ws_send(state.conn, state.ref, {:text, operation |> TrollWeb.Util.Viewer.operation() |> Jason.encode!()}), state}
  end

  def handle_call({:say, goodbye}, _from, conn) do
    IO.puts("server going bye bye in T-#{inspect(goodbye)}s")
    :timer.send_interval(:timer.seconds(goodbye), self(), :stop)
    {:reply, {:ok, :saygoodbye}, conn}
  end

  defp await_upgrade(gun_pid, stream_ref) do
    receive do
      {:gun_upgrade, ^gun_pid, ^stream_ref, protocols, headers} ->
        {:ok, {protocols, headers}}
    after
      @timeout ->
        {:error, :timeout}
    end
  end

end
