defmodule Troll.ProtocolFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Troll.Protocol` context.
  """

  @doc """
  Generate a operation.
  """
  def operation_fixture(attrs \\ %{}) do
    {:ok, operation} =
      attrs
      |> Enum.into(%{
        id: "7488a646-e31f-11e4-aace-600308960662",
        op: "some op",
        topic: "some topic",
        type: "some type"
      })
      |> Troll.Protocol.create_operation()

    operation
  end
end
