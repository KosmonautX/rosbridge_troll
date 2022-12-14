defmodule TrollWeb.OperationLive.Index do
  use TrollWeb, :live_view

  alias Troll.Protocol
  alias Troll.Protocol.Operation
  alias Troll.Bridge
  alias Troll.Users
  @impl true
  @topic "operation"
  def mount(_params, _session, socket) do
    if connected?(socket), do: Troll.BridgeComm.subscribe(@topic)
      {:ok, socket |> assign(:operations, list_operations()
      |> Enum.group_by(&Map.get(&1, :op_id))
      |> Enum.sort_by(&elem(&1, 1)
      |> List.first()
      |> Map.get(:inserted_at), :desc)
        )
      |> assign(:operator, nil)}
   end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Operation")
    |> assign(:operation, Protocol.get_operation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Choose your Destination")
    |> assign(:operation, %Operation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Operations")
    |> assign(:operation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    operation = Protocol.get_operation!(id)
    {:ok, _} = Protocol.delete_operation(operation)

    {:noreply, assign(socket, :operations, list_operations())}
  end

  @impl true
  def handle_info({:pubsub, {:operator, :detected}, operator_id}, socket) do
    {:noreply, socket
    |> assign(operator: Users.get_user!(operator_id))
    |> assign(operator_ops: Protocol.list_operations_by_operator(operator_id))}
  end

  defp list_operations do
    Protocol.list_operations()
  end
end
