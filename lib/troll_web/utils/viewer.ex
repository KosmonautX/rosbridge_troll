defmodule TrollWeb.Util.Viewer do

  def operation(operation) do
    %{
      op: operation.op,
      id: operation.id,
      type: operation.type,
      topic: operation.topic,
      msg: (if operation.msg, do: %{data: operation.msg.data})
    }
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
  end


end
