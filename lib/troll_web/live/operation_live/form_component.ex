defmodule TrollWeb.OperationLive.FormComponent do
  use TrollWeb, :live_component

  alias Troll.Protocol


  @impl true
  def update(%{operation: operation} = assigns, socket) do
    changeset = Protocol.change_operation(operation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"operation" => operation_params}, socket) do
    changeset =
      socket.assigns.operation
      |> Protocol.change_operation(operation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"operation" => operation_params}, socket) do
    save_operation(socket, socket.assigns.action, operation_params)
  end

  defp save_operation(socket, :edit, operation_params) do
    case Protocol.update_operation(socket.assigns.operation, operation_params) do
      {:ok, _operation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Operation updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_operation(socket, :new, operation_params) do
    case Protocol.advertise_and_publish(operation_params) do
      {:ok, _operation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Operation created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
  end
