defmodule Troll.Protocol do
  @moduledoc """
  The Protocol context.
  """

  import Ecto.Query, warn: false
  alias Troll.Repo

  alias Troll.Protocol.Operation

  @doc """
  Returns the list of operations.

  ## Examples

      iex> list_operations()
      [%Operation{}, ...]

  """
  def list_operations do
    Repo.all(Operation)
  end

  @doc """
  Gets a single operation.

  Raises `Ecto.NoResultsError` if the Operation does not exist.

  ## Examples

      iex> get_operation!(123)
      %Operation{}

      iex> get_operation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operation!(id), do: Repo.get!(Operation, id)

  @doc """
  Creates a operation.

  ## Examples

      iex> create_operation(%{field: value})
      {:ok, %Operation{}}

      iex> create_operation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_operation(attrs \\ %{}) do
    %Operation{}
    |> Operation.changeset(attrs)
    |> Repo.insert()
  end

  def advertise(attrs \\ %{}) do
    %Operation{}
    |> Operation.advertise(attrs)
    |> Repo.insert()
  end

  def publish(attrs \\ %{}) do
    %Operation{}
    |> Operation.publish(attrs)
    |> Repo.insert()
  end

  defp bridge_communicate(operation) do
    GenServer.call(Troll.Bridge, {:op_send, operation})
  end
  @doc """
  Advertise & Publish

  ## Examples

      iex> create_operation(%{field: value})
      {:ok, %Operation{}}

      iex> create_operation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def advertise_and_publish(attrs \\ %{}) do
    with {:ok, %Operation{} = ad_op} <- advertise(attrs) ,
         {:ok, %Operation{} = pub_op} <- publish(attrs)
      do
       ad_op |> bridge_communicate()
       pub_op |> bridge_communicate()
       {:ok, pub_op}
      else
        err -> err
    end
   end

  @doc """
  Updates a operation.

  ## Examples

      iex> update_operation(operation, %{field: new_value})
      {:ok, %Operation{}}

      iex> update_operation(operation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_operation(%Operation{} = operation, attrs) do
    operation
    |> Operation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a operation.

  ## Examples

      iex> delete_operation(operation)
      {:ok, %Operation{}}

      iex> delete_operation(operation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_operation(%Operation{} = operation) do
    Repo.delete(operation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking operation changes.

  ## Examples

      iex> change_operation(operation)
      %Ecto.Changeset{data: %Operation{}}

  """
  def change_operation(%Operation{} = operation, attrs \\ %{}) do
    Operation.changeset(operation, attrs)
  end
   end
