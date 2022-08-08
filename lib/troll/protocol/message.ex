defmodule Troll.Protocol.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :data, :string
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:data])
  end
end
