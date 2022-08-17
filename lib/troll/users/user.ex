defmodule Troll.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, Ecto.UUID, autogenerate: false}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
  end
end
