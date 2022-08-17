defmodule Troll.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE ros_op_type AS ENUM ('advertise', 'unadvertise', 'subscribe', 'unsubscribe', 'publish', 'set_level', 'status', 'auth', 'call_service', 'service_response', 'advertise_service', 'unadvertise_service')"
    drop_query = "DROP TYPE "
    execute(create_query, drop_query)

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      timestamps()
    end

    create unique_index(:users, [:name])

    create table(:operations, primary_key: false) do
      add :op, :ros_op_type
      add :op_id, :uuid, primary_key: true
      add :id, :uuid
      add :topic, :string
      add :type, :string
      add :msg, :jsonb
      add :operator_name, references(:users, column: :name, on_delete: :delete_all, type: :string)

      timestamps()
    end

    create index(:operations, [:operator_name])

  end
end
