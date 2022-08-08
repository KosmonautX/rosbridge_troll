defmodule Troll.Protocol.Operation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:op_id, Ecto.UUID, autogenerate: true}
  @foreign_key_type :binary_id
  schema "operations" do
    field :op, Ecto.Enum, values: [set_level: "set_level", auth: "auth", advertise: "advertise", unadvertise: "unadvertise", publish: "publish", subscribe: "subscribe", unsubscribe: "unsubscribe", call_service: "call_service", advertise_service: "advertise_service", unadvertise_service: "unadvertise_service", service_response: "service_response"]
    field :id, Ecto.UUID
    field :topic, :string
    field :type, :string
    embeds_one :msg, Troll.Protocol.Message, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(operation, attrs) do
    operation
    |> cast(attrs, [:op, :id, :topic, :type])
    |> cast_embed(:msg)
    |> validate_required([:op, :topic])
  end

  def publish(operation, attrs) do
    operation
    |> Map.put(:op, :publish)
    |> cast(attrs, [:id, :topic])
    |> cast_embed(:msg)
    |> validate_required([:op, :topic, :msg])
  end

  def advertise(operation, attrs) do
    operation
    |> Map.put(:op, :advertise)
    |> cast(attrs, [:id, :topic, :type])
    |> validate_required([:op, :topic, :type])
  end
end
