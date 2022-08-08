defmodule TrollWeb.OperationLive.Show do
  use TrollWeb, :live_view

  alias Troll.Protocol
  alias Troll.Bridge

  @impl true
  def mount(_params, _session, socket) do
      {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:operation, Protocol.get_operation!(id))}
  end

  defp page_title(:show), do: "Show Operation"
  defp page_title(:edit), do: "Edit Operation"
end
