defmodule Troll.ProtocolTest do
  use Troll.DataCase

  alias Troll.Protocol

  describe "operations" do
    alias Troll.Protocol.Operation

    import Troll.ProtocolFixtures

    @invalid_attrs %{id: nil, op: nil, topic: nil, type: nil}

    test "list_operations/0 returns all operations" do
      operation = operation_fixture()
      assert Protocol.list_operations() == [operation]
    end

    test "get_operation!/1 returns the operation with given id" do
      operation = operation_fixture()
      assert Protocol.get_operation!(operation.id) == operation
    end

    test "create_operation/1 with valid data creates a operation" do
      valid_attrs = %{id: "7488a646-e31f-11e4-aace-600308960662", op: "some op", topic: "some topic", type: "some type"}

      assert {:ok, %Operation{} = operation} = Protocol.create_operation(valid_attrs)
      assert operation.id == "7488a646-e31f-11e4-aace-600308960662"
      assert operation.op == "some op"
      assert operation.topic == "some topic"
      assert operation.type == "some type"
    end

    test "create_operation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Protocol.create_operation(@invalid_attrs)
    end

    test "update_operation/2 with valid data updates the operation" do
      operation = operation_fixture()
      update_attrs = %{id: "7488a646-e31f-11e4-aace-600308960668", op: "some updated op", topic: "some updated topic", type: "some updated type"}

      assert {:ok, %Operation{} = operation} = Protocol.update_operation(operation, update_attrs)
      assert operation.id == "7488a646-e31f-11e4-aace-600308960668"
      assert operation.op == "some updated op"
      assert operation.topic == "some updated topic"
      assert operation.type == "some updated type"
    end

    test "update_operation/2 with invalid data returns error changeset" do
      operation = operation_fixture()
      assert {:error, %Ecto.Changeset{}} = Protocol.update_operation(operation, @invalid_attrs)
      assert operation == Protocol.get_operation!(operation.id)
    end

    test "delete_operation/1 deletes the operation" do
      operation = operation_fixture()
      assert {:ok, %Operation{}} = Protocol.delete_operation(operation)
      assert_raise Ecto.NoResultsError, fn -> Protocol.get_operation!(operation.id) end
    end

    test "change_operation/1 returns a operation changeset" do
      operation = operation_fixture()
      assert %Ecto.Changeset{} = Protocol.change_operation(operation)
    end
  end
end
